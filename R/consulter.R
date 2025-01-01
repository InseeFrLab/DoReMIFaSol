#' Consulter le descriptif des données sur insee.fr
#'
#' @inheritParams telechargerFichier
#' @param donnees le nom des données dont on veut consulter la page sur le site de l'Insee. La description complète des données associées à ce nom figure dans la table ([liste_donnees]).
#' @param url_only `TRUE` pour seulement récupérer l'URL de la page sans ouvrir le navigateur.
#'
#' @return Par défaut, la fonction ouvre le lien dans le navigateur. Elle retourne accessoirement le lien vers la page web, de manière invisible.
#'
#' @export
#'
#' @examples
#' consulter(donnees = "BPE_ENS")
#' consulter("RP_LOGEMENT", date = "2016")
#' # Pour seulement obtenir l'URL de la page
#' consulter("RP_LOGEMENT", date = "2016", url_only = TRUE)

consulter <- function(donnees, date = NULL, url_only = FALSE) {

  caract <- infosDonnees(donnees, date, silencieux = url_only)

  if (is.null(caract$url_documentation)) {
    # construit l'url web à partir de l'url du fichier
    url <- sub("fichier/([0-9]+)/.+$", "\\1", caract$lien)
    
    # des exceptions sur les url web pour la collection GEOGRAPHIE et le fichier des personnes décédées
    if (caract$collection == "GEOGRAPHIE" || substr(caract$nom, 1, 8) == "DECES_20") {
      url <- sub("/statistiques/", "/information/", url)
    }
  } else {
    url <- caract$url_documentation
  }

  if (url_only) return(url)

  # ouvre dans navigateur
  utils::browseURL(url)

  invisible(url)

}
