#' Charger les données téléchargées dans R
#'
#' @param telechargementFichier une liste contenant l'ensemble des informations nécessaires au chargement des données, créée en sortie de la fonction [`telechargerFichier`].
#' @param vars un vecteur de variables à importer, afin d'utiliser les ressources computationnelles avec parcimonie. Par défaut NULL, ce qui signifie que l'ensemble des variables disponibles sont chargées.
#' @param ... des paramètres additionnels pour l'importation des données
#' 
#' @details 
#' Les données mises à disposition sont en général des tables de taille raisonnable, qui peuvent être chargées sans problème en mémoire sur un large spectre de machines. Néanmoins, pour certaines données (telles celles du Recensement de Population ou encore SIRENE), les données sont très volumineuses et exigent donc des machines très performantes. L'utilisateur a donc la possibilité de choisir les variables qui l'intéressent et de ne charger que ces dernières en mémoire, de manière à être parcimonieux.
#'
#' @return un objet data.frame contenant les données téléchargées (sauf dans le cas des données téléchargées depuis les API, pour lesquelles ce sont généralement des listes contenant les différents objets data.fame).
#' @export
#'
#' @examples \dontrun{
#' dl_bpe <- telechargerFichier(donnees = "BPE_ENS")
#' bpe <- chargerDonnees(dl_bpe)}
chargerDonnees <- function(telechargementFichier, vars = NULL, ...) {

  ## check download has worked
  if (is.null(telechargementFichier$result)) {
    if (!is.null(telechargementFichier$message)) {
      stop("Le t\u00e9l\u00e9chargement a rencontr\u00e9 un probl\u00e8me : erreur ", telechargementFichier$message)
    } else if (telechargementFichier$type == "json" & file.exists(telechargementFichier$argsImport$fichier)) {
      message <- jsonlite::read_json(telechargementFichier$argsImport$fichier)
      stop("Le t\u00e9l\u00e9chargement a rencontr\u00e9 un probl\u00e8me : erreur ",  message$header$statut, " - ", message$header$message)
    } else {
      warning("Le t\u00e9l\u00e9chargement a rencontr\u00e9 un probl\u00e8me.")
    }
  }
  
  ## unzip if necessary
  if (telechargementFichier$zip) {
    nomFichier <- telechargementFichier$fileArchive
    dossier_unz <- dirname(nomFichier)
    if (!endsWith(nomFichier, ".zip")) {
      stop("Le fichier t\u00e9l\u00e9charg\u00e9 n'est pas une archive zip.")
    } else {
      if (!telechargementFichier$big_zip) {
        unzipped <- unzip(nomFichier, exdir = dossier_unz)
      } else {
        unzipped <- file.path(dossier_unz, unzip(nomFichier, list = TRUE)$Name)
        err_unz <- tryCatch(unzip(nomFichier, exdir = dossier_unz, unzip = "unzip"))
        if (!is.null(err_unz)) stop(err_unz$message)
      }
    }
    # supprime fichiers décompressés (même en cas de plantage)
    on.exit(unlink(unzipped))
    ## check the dl file exists
    if (!file.exists(nomFichier))
      stop("Le fichier t\u00e9l\u00e9charg\u00e9 est introuvable.")
  }

  fichierAImporter <-
    switch(
      telechargementFichier$type,
      "csv"  = telechargementFichier$argsImport$file,
      "parquet" = telechargementFichier$argsImport$file,
      "json" = telechargementFichier$argsImport$fichier,
      telechargementFichier$argsImport$path # (autres extensions)
    )

  ## check the file to import exists
  if (!all(file.exists(fichierAImporter)))
    stop("Le fichier de donn\u00e9es est introuvable.")
  ## import data
  if (telechargementFichier$type == "csv") {
    if (!is.null(vars)) {
      listvar <- lapply(vars, function(x) readr::col_guess())
      names(listvar) <- vars
      colsOnly <- readr::cols_only()
      colsOnly$cols <- listvar
      telechargementFichier$argsImport[["col_types"]] <- colsOnly
    }
    res <- as.data.frame(do.call(readr::read_delim, c(telechargementFichier$argsImport, ...))) 
  } else if (telechargementFichier$type == "xls") {
    if (!is.null(telechargementFichier$argsImport$sheet)) {
      res <- as.data.frame(do.call(readxl::read_xls, c(telechargementFichier$argsImport, ...)))
    } else {
      onglets <- readxl::excel_sheets(telechargementFichier$argsImport$path)
      res_int <- lapply(intersect(onglets, toupper(onglets)), function(x) {
        telechargementFichier$argsImport[["sheet"]] <- x
        table <- do.call(readxl::read_xls, c(telechargementFichier$argsImport, ...))
        table$onglet <- x
        return(table)
      })
      res <- as.data.frame(do.call(rbind, res_int))
    }
  } else if (telechargementFichier$type == "xlsx") {
    if (!is.null(telechargementFichier$argsImport$sheet) & telechargementFichier$argsImport$sheet != "__MELODI__") {
      res <- as.data.frame(do.call(readxl::read_xlsx, telechargementFichier$argsImport))
      } else {
      onglets <- readxl::excel_sheets(telechargementFichier$argsImport$path)
      if (telechargementFichier$argsImport$sheet == "__MELODI__"){
        onglets <- onglets[!onglets %in% c("Métadonnées", "Documentation")]
      } else {
        onglet <- intersect(onglets, toupper(onglets))
      }
      res_int <- lapply(onglets, function(x) {
        telechargementFichier$argsImport[["sheet"]] <- x
        table <- do.call(readxl::read_xlsx, c(telechargementFichier$argsImport, ...))
        table$onglet <- x
        return(as.data.frame(table))
      })
      #res <- as.data.frame(do.call(rbind, res_int))
      res <- res_int
      names(res) <- onglets
    }
    } else if (telechargementFichier$type == "json") {
    if (!is.null(vars))
      warning("Il n'est pas possible de filtrer les variables charg\u00e9es en m\u00e9moire sur le format JSON pour le moment.")
    res <- do.call(chargerDonneesJson, telechargementFichier$argsImport)
  } else if (telechargementFichier$type == "parquet") {
    if (!is.null(vars))
      telechargementFichier$argsImport$col_select <- vars
    res <- do.call(arrow::read_parquet, telechargementFichier$argsImport)
  } else stop("Type de fichier inconnu")

  # ajout attribut source (pour data.frames hors API)
  if (is.data.frame(res)) {
    class(res) <- c("insee_data_frame", class(res))
    attr_url <- sub("fichier/([0-9]+)/.+$", "\\1", telechargementFichier$lien)
    if (telechargementFichier$collection == "GEOGRAPHIE" || substr(telechargementFichier$nom, 1, 8) == "DECES_20") {
      # url différente pour COG, aires urbaines et décès
      attr_url <- sub("/statistiques/", "/information/", attr_url)
    }
    attr(res, "source") <-
      list(
        producteur = "Institut National de la Statistique et des \u00c9tudes \u00c9conomiques (Insee)",
        url = attr_url,
        infos_diffusion = "https://www.insee.fr/fr/information/1300614"
      )
  }
  
  return(res)

}

chargerDonneesJson <- function(fichier, nom = c("SIRENE_SIREN", "SIRENE_SIRET")) {
  
  donnees <- do.call(c, lapply(fichier, function(x) jsonlite::read_json(x)[[2]]))
  
  if (nom == "SIRENE_SIREN") {
    
    unitesLegales <- lapply(donnees, function(x) data.frame(lapply(x[1:18], function(xx) ifelse(is.null(xx), NA, xx))))
    unitesLegales <- list(
      unitesExistantes = lapply(unitesLegales, function(x) if (is.null(x$unitePurgeeUniteLegale))
        return(x)),
      unitesPurgees = lapply(unitesLegales, function(x) if (!is.null(x$unitePurgeeUniteLegale))
        return(x))
    )
    unitesLegales <- lapply(unitesLegales, function(x) do.call(rbind, x))
    periodesUnitesLegales <- transformeListe(donnees, "siren", "periodesUniteLegale", 3)
    periodesUnitesLegales <- do.call(rbind, periodesUnitesLegales)
    
    c(unitesLegales, list(periodesUnitesLegales = periodesUnitesLegales))
    
  } else if (nom == "SIRENE_SIRET") {
    
    ## table etablissements
    etablissements <- lapply(donnees, function(x) data.frame(lapply(x[1:11], function(xx) ifelse(is.null(xx), NA, xx))))
    etablissements <- do.call(rbind, etablissements)
    ## table unitesLegales
    unitesLegales <- transformeListe(donnees, c("siret", "siren"), "uniteLegale", 2)
    unitesLegales <- list(
      unitesExistantes = lapply(unitesLegales, function(x) if (is.null(x$unitePurgeeUniteLegale))
        return(x)),
      unitesPurgees = lapply(unitesLegales, function(x) if (!is.null(x$unitePurgeeUniteLegale))
        return(x))
    )
    unitesLegales <- lapply(unitesLegales, function(x) do.call(rbind, x))
    ## table adresseEtablissement
    adresseEtablissement <- transformeListe(donnees, c("siret", "siren"), "adresseEtablissement", 2)
    adresseEtablissement <- do.call(rbind, adresseEtablissement)
    ## table adresse2Etablissement
    adresse2Etablissement <- transformeListe(donnees, c("siret", "siren"), "adresse2Etablissement", 2)
    adresse2Etablissement <- do.call(rbind, adresse2Etablissement)
    ## table periodesEtablissement
    periodesEtablissement <- transformeListe(donnees, c("siret", "siren"), "periodesEtablissement", 3)
    periodesEtablissement <- do.call(rbind, periodesEtablissement)

    list(
      etablissement         = etablissements,
      unitesExistantes      = unitesLegales$unitesExistantes,
      unitesPurgees         = unitesLegales$unitesPurgees,
      adresseEtablissement  = adresseEtablissement,
      adresse2Etablissement = adresse2Etablissement, 
      periodesEtablissement = periodesEtablissement
    )

  } else if (nom == "SIRENE_SIRET_LIENS") {
    
    # agrege sirets
    res <- do.call(
      rbind,
      lapply(donnees, as.data.frame, stringsAsFactors = FALSE)
    )
    
    # convertit date-time
    res$dateLienSuccession <- as.Date(res$dateLienSuccession)
    res$dateDernierTraitementLienSuccession <-
      as.POSIXct(
        res$dateDernierTraitementLienSuccession,
        format = "%Y-%m-%dT%H:%M:%S"
      )
    
    res
    
  }

}

## liste de liste en data.frame
transformeListe <- function(liste, identifiant, nomTable, niveau = 2:3) {
  if (niveau == 2) {
    don <- lapply(liste, function(x) return(list(id = x[identifiant], table = lapply(x[[nomTable]], function(xx) ifelse(is.null(xx), NA, xx)))))
    don <- lapply(don, function(x) data.frame(x$id, x$table))
  } else {
    don <- lapply(liste, function(x) return(list(id = x[identifiant], table = lapply(x[[nomTable]], function(x) lapply(x, function(xx) ifelse(is.null(xx), NA, xx))))))
    don <- lapply(don, function(x) do.call(rbind, lapply(x$table, function(xx) data.frame(x$id, xx))))
  }
  return(don)
}

