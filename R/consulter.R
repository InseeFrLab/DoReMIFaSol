#' Consulter le descriptif des données sur insee.fr
#'
#' @inheritParams telechargerFichier
#' @param donnees le nom des données dont on veut consulter la page sur le site de l'Insee. La description complète des données associées à ce nom figure dans la table ([liste_donnees]).
#' @param consultation Booléen qui indique si on veut consulter directement consulter la page sur son navigateur (TRUE) ou seulement récupérer l'URL de la page (FALSE).
#'
#' @return La fonction ouvre le lien dans le navigateur. Elle retourne accessoirement le lien vers la page web, de manière invisible.
#'
#' @export
#'
#' @examples
#' consulter(donnees = "BPE_ENS")
#' consulter("RP_LOGEMENT", date = "2016")

consulter <- function(donnees, date = NULL, consultation = TRUE) {

  caract <- infosDonnees(donnees, date, consultation)

  # construit l'url web à partir de l'url du fichier
  url <- sub("fichier/([0-9]+)/.+$", "\\1", caract$lien)
  if (caract$collection == "GEOGRAPHIE") {
    url <- sub("/statistiques/", "/information/", url)
  }
  
  if (isTRUE(consultation)) {
    # ouvre dans navigateur
    utils::browseURL(url)
  } 
  
  invisible(url)

}
