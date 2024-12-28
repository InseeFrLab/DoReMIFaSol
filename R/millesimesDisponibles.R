#' Lister les différents millésimes pour une source donnée
#'
#' @inheritParams telechargerFichier
#'
#' @return un vecteur contenant l'ensemble des millésimes disponibles pour une source de données.
#' @export
#'
#' @examples
#' millesimesDisponibles("RP_LOGEMENT")
millesimesDisponibles <- function(donnees) {
  ## check the parameter donnees takes a valid value
  donnees <- toupper(donnees)
  liste_nom <- unlist(lapply(listerDonnees(), function(x) return(x$nom)))
  if (!donnees %in% liste_nom)
    stop("Le param\u00e8tre donnees est mal sp\u00e9cifi\u00e9, la valeur n'est pas r\u00e9f\u00e9renc\u00e9e")
  liste_possible <- ld[which(liste_nom == donnees)]
  liste <- lapply(liste_possible, function(x) return(x$date_ref))
  if (!any(duplicated(unlist(lapply(liste, function(x) format(x, "%Y"))))))
    return(unlist(lapply(liste, function(x) format(x, "%Y")))) else
      return(unlist(lapply(liste, function(x) format(x, "%Y-%m-%d"))))
}