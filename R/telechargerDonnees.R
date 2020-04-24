#' Téléchargement des données sur le site de l'Insee
#'
#' @param donnees le nom des données que l'on souhaite télécharger sur le site de l'Insee, que l'on peut retrouver dans la table `liste_donnees`
#' @param date optionnel : le millésime des données si nécessaire
#'
#' @return
#' @export
#'
#' @examples
telechargerDonnees <- function(donnees=c("BPE_ENS"), date=NULL) {
  caract <- liste_donnees[liste_donnees$nom == donnees, ]
  ## check whether date is needed
  if (nrow(caract) > 1) {
    if (is.null(date)) stop("Il faut spécifier une date de référence pour ces données.")
    caract <- caract[caract$date_ref == date]
  }
  
  if (caract$zip) {
    download.file(url = caract$lien, destfile = "donnees.zip")
    unzip("donnees.zip")
    res <- read.csv(caract$fichier_donnees, sep = ";", header = TRUE)
    file.remove("donnees.zip")
    file.remove(caract$fichier_donnees)
    if (!is.na(caract$fichier_meta)) file.remove(caract$fichier_meta)
  } else {
    download.file(url = caract$lien, destfile = paste0("donnees.", caract$type))
    res <- read.csv(paste0("donnees.", caract$type), sep = ";", header = TRUE)
    file.remove(paste0("donnees.", caract$type))
  }
  return(res)
}
