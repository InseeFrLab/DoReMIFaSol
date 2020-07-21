#' Charger les données téléchargées dans R
#'
#' @param telechargementFichier une liste contenant l'ensemble des informations nécessaires au chargement des données, créée en sortie de la fonction `telechargerFichier`
#' @param vars un vecteur de variables à importer, afin d'utiliser les ressources computationnelles avec parcimonie. Par défaut NULL, ce qui signifie que l'ensemble des variables disponibles sont chargées.
#' @param ... des paramètres additionnels pour l'importation des données
#' 
#' @details 
#' Les données mises à disposition sont en général des tables de taille raisonnable, qui peuvent être chargées sans problème en mémoire sur un large spectre de machines. Néanmoins, pour certaines données (telles celles du Recensement de Population ou encore SIRENE), les données sont très volumineuses et exigent donc des machines très performantes. L'utilisateur a donc la possibilité de choisir les variables qui l'intéressent et de ne charger que ces dernières en mémoire, de manière à être parcimonieux.
#'
#' @return un objet data.frame contenant les données téléchargées.
#' @export
#'
#' @examples \dontrun{
#' dl_bpe <- telechargerFichier(donnees = "BPE_ENS")
#' bpe <- chargerDonnees(dl_bpe)}
chargerDonnees <- function(telechargementFichier, vars = NULL, ...) {
  ## check download has worked
  if (is.null(telechargementFichier$result))
    stop("Le t\u00e9l\u00e9chargement a rencontr\u00e9 un probl\u00e8me.")
  ## check the dl file exists
  
  ## unzip if necessary
  if (telechargementFichier$zip) {
    nomFichier <- telechargementFichier$fileArchive
    if (substr(nomFichier, nchar(nomFichier) - 2, nchar(nomFichier)) != "zip") {
      stop("Le fichier t\u00e9l\u00e9charg\u00e9 n'est pas une archive zip.")
    } else {
      if (!telechargementFichier$big_zip)
        unzip(nomFichier, exdir = dirname(nomFichier)) else {
          unz <- tryCatch(unzip(nomFichier, exdir = dirname(nomFichier), unzip = "unzip"))
          if (!is.null(unz))
            stop(unz$message)
        }
    }
  }
  ## warning on file extension
  fichierAImporter <- ifelse(telechargementFichier$type == "csv", telechargementFichier$argsImport$file, telechargementFichier$argsImport$path)
  if (stringi::stri_match_last_regex(fichierAImporter, "^*.(\\w*)$")[, 2] != telechargementFichier$type)
    warning("L'extension du fichier diff\u00e8re du type de fichier.")
  ## import data
  if (telechargementFichier$type == "csv") {
    if (!is.null(vars)) {
      listvar <- lapply(vars, function(x) readr::col_guess())
      names(listvar) <- vars
      colsOnly <- readr::cols_only()
      colsOnly$cols <- listvar
      telechargementFichier$argsImport[["col_types"]] <- colsOnly
    }
    res <- do.call(readr::read_delim, c(telechargementFichier$argsImport, ...)) 
  } else if (telechargementFichier$type == "xls") {
    if (!is.na(telechargementFichier$argsImport$sheet)) {
      res <- do.call(readxl::read_xls, c(telechargementFichier$argsImport, ...))
    } else {
      res_int <- lapply(readxl::excel_sheets(telechargementFichier$argsImport$path), function(x) {
        telechargementFichier$argsImport[["sheet"]] <- x
        table <- do.call(readxl::read_xls, c(telechargementFichier$argsImport, ...))
        table$onglet <- x
        return(table)
      })
      res <- do.call(rbind, res_int)
    }
  } else if (telechargementFichier$type == "xlsx")
    res <- do.call(readxl::read_xlsx, telechargementFichier$argsImport)
  else stop("Type de fichier inconnu")
  return(as.data.frame(res))
}