#' Téléchargement des données sur le site de l'Insee
#'
#' @param donnees le nom des données que l'on souhaite télécharger sur le site de l'Insee, que l'on peut retrouver dans la table `liste_donnees``
#' @param date optionnel : le millésime des données si nécessaire
#' @param telDir optionnel : le dossier dans lequel sont téléchargées les données brutes. Par déaut, un dossier temporaire de cache.
#' @param ... paramètres additionnels relatifs à l'importation des données
#'
#' @return un objet `data.frame` contenant les données téléchargées sur le site de l'Insee.
#' @export
#'
#' @examples \dontrun{
#' bpe_ens_2018 <- telechargerDonnees(donnees = "BPE_ENS", date = as.Date("01/01/2018"))
#' }
#' @importFrom utils download.file unzip read.csv
#' @export
telechargerDonnees <- function(donnees=ld$nom, date=NULL, telDir=NULL, ...) {
  caract <- ld[ld$nom == donnees, ]
  ## check whether date is needed
  if (nrow(caract) > 1) {
    if (is.null(date)) stop("Il faut sp\u00e9cifier une date de r\u00e9f\u00e9rence pour ces donn\u00e9es.")
    caract <- caract[caract$date_ref == date]
  }
  
  #dossier de téléchargement
  if (is.null(telDir)) {
    if (is.null(getOption("insee.cache"))) {
      telDir <- tempdir()
      options(insee.cache = telDir)
    } else {
      telDir <- getOption("insee.cache")
    }
  }
  
  nomFichier <- paste0(telDir, "/", tail(unlist(strsplit(caract$lien, "/")), n=1L))
  #stringr::str_extract(url, "^*([^/]*)$")
  if (!file.exists(nomFichier))
    download.file(url = caract$lien, destfile = nomFichier)
  
  if (caract$zip) {
    if (substr(nomFichier, nchar(nomFichier) - 3, nchar(nomFichier)) != ".zip") 
      stop("Le fichier t\u00e9l\u00e9charg\u00e9 n'est pas une archive zip.")
  } else {
    if (substr(nomFichier, nchar(nomFichier) - 4, nchar(nomFichier)) != paste0(".", caract$type))
      stop("le fichier t\u00e9l\u00e9charg\u00e9 n'est pas du type attendu.")
    fichierAImporter <- nomFichier
  }
  # importation donnees
  if (caract$type == "csv")
    res <- read.csv(fichierAImporter, sep = ";", header = TRUE, ...)
  if (caract$type == "xls")
    res <- readxl::read_xls(fichierAImporter, sheet = caract$onglet, skip = caract$premiere_ligne - 1)
    file.remove(fichierAImporter)
  if (!is.na(caract$fichier_meta))
    file.remove(paste0(telDir, "/", caract$fichier_meta))
  return(res)
}
