#' Téléchargement des données sur le site de l'Insee
#'
#' @param donnees le nom des données que l'on souhaite télécharger sur le site de l'Insee, que l'on peut retrouver dans la table [liste_donnees]
#' @param date optionnel : le millésime des données si nécessaire
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
    if (!date %in% caract$date_ref) stop("La date sp\u00e9cifi\u00e9e n'est pas disponible.")
    caract <- caract[caract$date_ref == date, ]
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
    if (substr(nomFichier, nchar(nomFichier) - 4, nchar(nomFichier)) != paste0(".", caract$type)) 
      stop("le fichier t\u00e9l\u00e9charg\u00e9 n'est pas du type attendu.")
    fichierAImporter <- nomFichier
  }

  # importation donnees
  if (caract$type == "csv")
    res <- readr::read_delim(fichierAImporter, delim = caract$separateur, col_names = TRUE, ...)
  else if (caract$type == "xls")
    res <- readxl::read_xls(fichierAImporter, sheet = caract$onglet, skip = caract$premiere_ligne - 1)
  else if (caract$type == "xlsx")
    res <- readxl::read_xlsx(fichierAImporter, sheet = caract$onglet, skip = caract$premiere_ligne - 1)
  else stop("Type de fichier inconnu")
  file.remove(fichierAImporter)
  if (!is.na(caract$fichier_meta))
    file.remove(paste0(telDir, "/", caract$fichier_meta))
  return(res)
}
