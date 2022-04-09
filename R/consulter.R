#' Consulter le descriptif des données sur insee.fr
#'
#' @inheritParams telechargerFichier
#' @param donnees le nom des données dont on veut consulter la page sur le site de l'Insee. La description complète des données associées à ce nom figure dans la table ([liste_donnees]).
#'
#' @return La fonction ouvre le lien dans le navigateur. Elle retourne accessoirement le lien vers la page web, de manière invisible.
#'
#' @export
#'
#' @examples
#' consulter(donnees = "BPE_ENS")
#' consulter("RP_LOGEMENT", date = "2016")

consulter <- function(donnees, date = NULL) {

  caract <- infosDonnees(donnees, date)

  # construit l'url web à partir de l'url du fichier
  url <- sub("fichier/([0-9]+)/.+$", "\\1", caract$lien)
  
  # des exceptions sur les url web pour la collection GEOGRAPHIE et le fichier des personnes décédées
  if (caract$collection == "GEOGRAPHIE" || substr(caract$nom, 1, 8) == "DECES_20") {
    url <- sub("/statistiques/", "/information/", url)
  }
  
  # ouvre dans navigateur
  utils::browseURL(url)
  
  invisible(url)

}
