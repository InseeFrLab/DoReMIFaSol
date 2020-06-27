#' Téléchargement des données sur le site de l'Insee
#'
#' @param donnees le nom des données que l'on souhaite télécharger sur le site de l'Insee, que l'on peut retrouver dans la table [liste_donnees]
#' @param date optionnel : le millésime des données si nécessaire. Peut prendre le format YYYY ou encore DD/MM/YYYY ; dans le dernier cas, on prendra le premier jour de la période de référence.
#' @param telDir optionnel : le dossier dans lequel sont téléchargées les données brutes. Par défaut, un dossier temporaire de cache.
#' @param ... paramètres additionnels relatifs à l'importation des données
#'
#' @return un objet tibble contenant les données téléchargées sur le site de l'Insee.
#' @export
#'
#' @examples \dontrun{
#' bpe_ens_2018 <- telechargerDonnees(donnees = "BPE_ENS")
#' }
#' @importFrom utils download.file unzip read.csv tail
#' @export
telechargerDonnees <- function(donnees, date=NULL, telDir=NULL, ...) {
  ## check the parameter donnees takes a valid value
  if (!donnees %in% ld$nom)
    stop("Le param\u00e8tre donnees est mal sp\u00e9cifi\u00e9, la valeur n'est pas r\u00e9f\u00e9renc\u00e9e")
  caract <- ld[ld$nom == donnees, ]
  ## check whether date is needed
  if (nrow(caract) > 1) {
    if (is.null(date)) stop("Il faut sp\u00e9cifier une date de r\u00e9f\u00e9rence pour ces donn\u00e9es.")
    if (nchar(date) == 4)
      select <- (format(caract$date_ref, "%Y") == as.character(date)) else
        select <- (caract$date_ref == as.Date(date, format = "%d/%m/%Y"))
    if (!any(select)) stop("La date sp\u00e9cifi\u00e9e n'est pas disponible.")
    if (sum(as.numeric(select), na.rm = TRUE) > 1) stop("Donn\u00e9es infra-annuelles a priori. Mieux sp\u00e9cifier la date de r\u00e9f\u00e9rence.")
    caract <- caract[which(select), ]
  }
  
  #dossier de téléchargement # si NULL aller dans le cache
  if (is.null(telDir))
    telDir <- tempdir()
  
  nomFichier <- paste0(telDir, "/", tail(unlist(strsplit(caract$lien, "/")), n=1L))
  #stringr::str_extract(url, "^*([^/]*)$")
  if (!file.exists(nomFichier))
    download.file(url = caract$lien, destfile = nomFichier) else
      message("utilisation du cache")
  
  if (caract$zip) {
    if (substr(nomFichier, nchar(nomFichier) - 3, nchar(nomFichier)) != ".zip") {
      stop("Le fichier t\u00e9l\u00e9charg\u00e9 n'est pas une archive zip.")
    } else {
      unzip(nomFichier, exdir = telDir)
      fichierAImporter <- paste0(telDir, "/", caract$fichier_donnees)
    }
  } else {
    if (stringr::str_extract(nomFichier, "^*([^.]*)$") != caract$type) 
      stop("le fichier t\u00e9l\u00e9charg\u00e9 n'est pas du type attendu.")
    fichierAImporter <- nomFichier
  }
  
  # importation donnees
  if (caract$type == "csv") {
    args <- list(file = fichierAImporter, delim = eval(parse(text = caract$separateur)), col_names = TRUE, ...)
    if (!is.na(caract$encoding))
      args[["locale"]] <- readr::locale(encoding = caract$encoding)
    res <- do.call(readr::read_delim, args)  
    #res <- readr::read_delim(fichierAImporter, delim = eval(parse(text = caract$separateur)), col_names = TRUE, ...)
  }
  else if (caract$type == "xls") {
    args <- list(path = fichierAImporter, skip = caract$premiere_ligne - 1)
    if (!is.na(caract$derniere_ligne))
      args[["n_max"]] <- caract$derniere_ligne - caract$premiere_ligne
    if (!is.na(caract$valeurs_manquantes))
      args[["na"]] <- unlist(strsplit(caract$valeurs_manquantes, "/"))
    if (!is.na(caract$onglet)) {
      args[["sheet"]] <- caract$onglet
      res <- do.call(readxl::read_xls, args)
    } else {
      res_int <- lapply(readxl::excel_sheets(fichierAImporter), function(x) {
        args[["sheet"]] <- x
        table <- do.call(readxl::read_xls, args)
        table$onglet <- x
        return(table)
      })
      res <- do.call(rbind, res_int)
    }
  }
  else if (caract$type == "xlsx")
    res <- readxl::read_xlsx(fichierAImporter, sheet = caract$onglet, skip = caract$premiere_ligne - 1)
  else stop("Type de fichier inconnu")
  if (caract$zip)
    file.remove(fichierAImporter)
  if (!is.na(caract$fichier_meta))
    file.remove(paste0(telDir, "/", caract$fichier_meta))
  return(as.data.frame(res))
}
