#' Lister les différents millésimes pour une source donnée
#'
#' @param donnees une chaîne de caractères qui identifie la source de données
#'
#' @return un vecteur contenant l'ensemble des millésimes disponibles pour une source de données.
#' @export
#'
#' @examples
#' millesimesDisponibles("RP_LOGEMENT")
millesimesDisponibles <- function(donnees) {
  ## check the parameter donnees takes a valid value
  if (!donnees %in% ld$nom)
    stop("Le param\u00e8tre donnees est mal sp\u00e9cifi\u00e9, la valeur n'est pas r\u00e9f\u00e9renc\u00e9e")
  liste <- with(ld, date_ref[nom == donnees])
  return(ifelse(!any(duplicated(format(liste, "%Y"))), format(liste, "%Y"), liste))
}