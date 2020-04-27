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
telechargerDonnees <- function(donnees, date=NULL, telDir=NULL, ...) {
  ## check the parameter donnees takes a valid value
  if (!donnees %in% ld$nom)
    stop("Le param\u00e8tre donnees est mal sp\u00e9cifi\u00e9, la valeur n'est pas r\u00e9f\u00e9renc\u00e9e")
  caract <- ld[ld$nom == donnees, ]
  ## check whether date is needed
  if (nrow(caract) > 1) {
    if (is.null(date)) stop("Il faut sp\u00e9cifier une date de r\u00e9f\u00e9rence pour ces donn\u00e9es.")
    caract <- caract[caract$date_ref == date]
  }

  #dossier de téléchargement
  if (is.null(telDir)) {
    if (is.null(getOption("insee.cache"))) {
      telDir <- gsub("//", "/", tempdir())
      options(insee.cache = telDir)
      print(telDir)
    } else {
      telDir <- gsub("//", "/", getOption("insee.cache"))
    }
  }
  nomFichierTemp <- tail(unlist(strsplit(caract$lien, "/")), n=1L)
  print(nomFichierTemp)
  nomFichier <- paste0(telDir, "/", nomFichierTemp)
  print(nomFichier)
  #stringr::str_extract(url, "^*([^/]*)$")
  if (!file.exists(nomFichier))
    download.file(url = caract$lien, destfile = nomFichier) else
      message("utilisation du cache")
  
  if (caract$zip) {
    print("zip")
    if (substr(nomFichier, nchar(nomFichier) - 3, nchar(nomFichier)) != ".zip") {
      stop("Le fichier t\u00e9l\u00e9charg\u00e9 n'est pas une archive zip.")
    } else {
      print("rezip0")
      unzip(nomFichier, files = caract$fichier_donnees, exdir = )
      fichierAImporter <- paste0(substr(nomFichier, 1, nchar(nomFichier) - 4), "/", caract$fichier_donnees)
      print(fichierAImporter)
      print("rezip")    
    }
  } else {
    if (substr(nomFichier, nchar(nomFichier) - 4, nchar(nomFichier)) != paste0(".", caract$type)) 
      stop("le fichier t\u00e9l\u00e9charg\u00e9 n'est pas du type attendu.")
    fichierAImporter <- nomFichier
  }
  print(fichierAImporter)
  
  # importation donnees
  if (caract$type == "csv")
    res <- readr::read_delim(fichierAImporter, delim = caract$separateur, col_names = TRUE, ...)
  if (caract$type == "xls")
    res <- readxl::read_xls(fichierAImporter, sheet = caract$onglet, skip = caract$premiere_ligne - 1)
  file.remove(fichierAImporter)
  if (!is.na(caract$fichier_meta))
    file.remove(paste0(telDir, "/", caract$fichier_meta))
  return(res)
}
