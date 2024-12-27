#' Télécharger un fichier sur le site de l'Insee
#'
#' @param donnees le nom court des données que l'on souhaite télécharger sur le site de l'Insee. La description complète des données associés à ce nom figure dans la table [`liste_donnees`]. Insensible à la casse.
#' @param date optionnel : le millésime des données si nécessaire. Peut prendre le format YYYY ou encore DD/MM/YYYY ; dans le dernier cas, on prendra le premier jour de la période de référence. Spécifier `"dernier"` sélectionne automatiquement le millésime le plus récent.
#' @param telDir optionnel : le dossier dans lequel sont téléchargées les données brutes. Par défaut, la valeur définie par `options(doremifasol.telDir = ...)`. Si l'utilisateur n'a pas défini cette valeur au préalable, un dossier temporaire de cache.
#' @param argsApi optionnel : dans le cas où c'est une API REST qui est utilisée, il est possible de spécifier des paramètres spécifiques à cette API de manière à collecter l'information désirée. Cf. section _Details_.
#' @param force forcer le téléchargement, même si le fichier a déjà été téléchargé (et est identique). 
#' 
#' @details 
#' La fonction permet de télécharger les données disponibles sur le site de l'Insee sous format csv, xls ou encore xlsx. Elle permet également, de manière expérimentale, de requêter certaines API REST de l'Insee ; ces services peuvent être repérés dans la table [`liste_donnees`] grâce à la variable `api_rest`.
#'
#' @return Une liste contenant le résultat du téléchargement et les informations pour l'importation des données en R (de manière invisible).
#' @export
#'
#' @examples \dontrun{
#' telechargerFichier(donnees = "BPE_ENS")
#' 
#' telechargerFichier("RP_LOGEMENT", date = "2016")
#' }
#' @importFrom utils unzip read.csv tail
#' @export
telechargerFichier <- function(donnees, date=NULL, telDir=getOption("doremifasol.telDir"), argsApi=NULL, force=FALSE) {
  
  ## vérifie donnees et date. si ok les infos nécessaires sont extraites dans caract
  caract <- infosDonnees(donnees, date)

  ## test de la connexion
  if (!curl::has_internet()) stop("aucune connexion Internet")
  
  #dossier de téléchargement # si NULL aller dans le cache
  cache <- FALSE
  if (is.null(telDir)) {
    telDir <- tempdir()
    cache <- TRUE
  } else {
    dir.exists(telDir) || dir.create(telDir)
  }
  
  ## télécharge les fichiers csv, xls, xlsx...
  if (!caract$api_rest) {
    
    nomFichier <- file.path(telDir, basename(caract$lien))
    dl <- NULL
    
    if (!file.exists(nomFichier) || force) {
      res <- try(httr::GET(caract$lien, httr::write_disk(nomFichier, overwrite = TRUE), httr::progress()))
      if (res$status_code == 200) {
        dl <- 0
      } else {
        file.remove(nomFichier)
        return(
          list(
            resultat = dl,
            message = res$status_code
          )
        )
      }
      if (tools::md5sum(nomFichier) != caract$md5) {
        warning("Fichier sur insee.fr modifi\u00e9 ou corruption lors du t\u00e9l\u00e9chargement.")
      }
      if (cache)
        message("Aucun r\u00e9pertoire d'importation n'est d\u00e9fini. Les donn\u00e9es ont \u00e9t\u00e9 t\u00e9l\u00e9charg\u00e9es par d\u00e9faut dans le dossier: ", telDir)
    } else if (tools::md5sum(nomFichier) != caract$md5){
      if (cache) {
        message("Aucun r\u00e9pertoire d'importation n'est d\u00e9fini. Les donn\u00e9es utilis\u00e9es sont stock\u00e9es dans le dossier: ", telDir)}
      message("Les donn\u00e9es doivent \u00eatre mises \u00e0 jour.")
      res <- tryCatch(httr::GET(caract$lien, httr::write_disk(nomFichier, overwrite = TRUE), httr::progress()))
      if (res$status_code == 200) dl <- 0
    } else {
      dl <- 0
      message("Donn\u00e9es d\u00e9j\u00e0 pr\u00e9sentes dans ", shQuote(telDir), ", pas de nouveau t\u00e9l\u00e9chargement.")
    }
    
    if (caract$zip) {
      fileArchive <- nomFichier
      fichierAImporter <- paste0(telDir, "/", caract$fichier_donnees)
    } else {
      fileArchive <- NULL
      fichierAImporter <- nomFichier
    }
    
    if (caract$type == "csv") {
      argsImport <- list(file = fichierAImporter, delim = eval(parse(text = caract$separateur)), col_names = TRUE)
      if (!is.null(caract$encoding))
        argsImport[["locale"]] <- readr::locale(encoding = caract$encoding)
      if (!is.null(caract$valeurs_manquantes))
        argsImport[["na"]] <- unlist(strsplit(caract$valeurs_manquantes, "/"))
    } else if (caract$type == "xls") {
      argsImport <- list(path = fichierAImporter, skip = caract$premiere_ligne - 1, sheet = caract$onglet)
      if (!is.null(caract$derniere_ligne))
        argsImport[["n_max"]] <- caract$derniere_ligne - caract$premiere_ligne
      if (!is.null(caract$valeurs_manquantes))
        argsImport[["na"]] <- unlist(strsplit(caract$valeurs_manquantes, "/"))
    } else if (caract$type == "xlsx") {
      argsImport <- list(path = fichierAImporter, sheet = caract$onglet, skip = caract$premiere_ligne - 1)
    } else if (caract$type == "parquet") {
      argsImport <- list(file = fichierAImporter)
    }
    
    if (!is.null(caract$type_col)) {
      listvar <- lapply(
        caract$type_col,
        function(x) eval(parse(text = paste0("readr::col_", x, "()")))
      )
      cols <- readr::cols()
      cols$cols <- listvar
      argsImport[["col_types"]] <- cols
    }
    
  } else {
    
    ## télécharge les données sur l'API
    
    if (!nzchar(Sys.getenv("INSEE_APP_KEY")) || !nzchar(Sys.getenv("INSEE_APP_SECRET"))) {
      stop("d\u00e9finir les variables d'environnement INSEE_APP_KEY et INSEE_APP_SECRET")
    }
    
    timestamp <- gsub("[^0-9]", "", as.character(Sys.time()))
    dossier_json <- paste0(telDir, "/json_API_", caract$nom, "_", timestamp, "_", genererSuffixe(4))
    dir.create(dossier_json)
    writeLines(
      utils::URLdecode(httr::modify_url(caract$lien, query = argsApi)),
      file.path(dossier_json, "requete.txt")
    )
    
    token <- apinsee::insee_auth()
    if (!is.null(date))
      argsApi <- c(date = as.character(date), argsApi)
    if (is.null(argsApi$nombre)) {
      argsApi[["nombre"]] <- 0
      url <- httr::modify_url(caract$lien, query = argsApi)
      res <- tryCatch(httr::GET(url, httr::config(token = token), 
                                httr::write_memory()),
                      error = function(e) message(e$message))
      total <- tryCatch(httr::content(res)[[1]]$total,
                        error = function(e) return(NULL))
      if (is.null(total))
        total <- 0
    } else {
      total <- argsApi[["nombre"]]
    }
    argsApi[["nombre"]] <- min(total, 1000)
    if (is.null(argsApi[["tri"]]))
      argsApi[["tri"]] <- "siren"
    if (total > 1000)
      argsApi[["curseur"]] <- "*"
    nombrePages <- ceiling(total/1000)
    url <- httr::modify_url(caract$lien, query = argsApi)
    fichierAImporter <- sprintf("%s/results_%06i.json", dossier_json, 1)
    res <- requeteApiSirene(url = url, fichier = fichierAImporter, token = token, 
                            nbTentatives = 400)
    resultat <- res$status_code
    if (nombrePages > 1) {
      for (k in 2:nombrePages) {
        argsApi[["curseur"]] <-httr::content(res)$header$curseurSuivant
        url <- httr::modify_url(caract$lien, query = argsApi)
        fichierAImporter <- c(fichierAImporter, sprintf("%s/results_%06i.json", dossier_json, k))
        res <- requeteApiSirene(url, fichierAImporter, token, 400)
        resultat <- c(resultat, res$status_code)
      }
    }
    dl <- NULL
    if (all(resultat == 200) & total > 0)
      dl <- 0
    argsImport <- list(fichier = fichierAImporter, nom = caract$nom)
    fileArchive <- NULL
    
  }
  
  invisible(
    list(
      result      = dl,
      lien        = caract$lien,
      zip         = caract$zip,
      big_zip     = caract$big_zip,
      fileArchive = fileArchive,
      type        = caract$type,
      argsImport  = argsImport,
      collection  = caract$collection,
      nom         = caract$nom
    )
  )
  
}

genererSuffixe <- function(longueur) {
  liste <- c(0:9, letters, LETTERS)
  paste(sample(liste, longueur, replace = TRUE), collapse = "")
}

requeteApiSirene <- function(url, fichier, token, nbTentatives) {
  count <- 1
  res <- tryCatch(httr::GET(url, 
                            httr::config(token = token), 
                            httr::write_disk(tail(fichier, 1)), 
                            httr::progress()),
                  error = function(e) {
                    message(e$message)
                    return(list(status_code = 429))})
  while(res$status_code == 429 & count <= nbTentatives) {
    message("Trop de requ\u00eates, patienter 10 secondes...")
    Sys.sleep(10)
    message("Nouvelle tentative...")
    res <- tryCatch(httr::GET(url, 
                              httr::config(token = token), 
                              httr::write_disk(tail(fichier, 1), overwrite = TRUE), 
                              httr::progress()),
                    error = function(e) {
                      message(e$message)
                      return(list(status_code = 429))})
    count <- count + 1
  }
  return(res)
}
