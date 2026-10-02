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
  ld_c <- ld_complet()
  liste_nom <- toupper(vapply(ld_c, `[[`, "nom", FUN.VALUE = character(1)))
  if (!donnees %in% liste_nom)
    stop("Le paramètre donnees est mal spécifié, la valeur n'est pas référencée")
  liste_possible <- ld_c[which(liste_nom == donnees)]
  # c() préserve la classe Date et gère les entrées sans date_ref (NULL)
  dates <- do.call(c, lapply(liste_possible, `[[`, "date_ref"))
  if (length(dates) == 0)
    return(character(0))
  annees <- format(dates, "%Y")
  if (!any(duplicated(annees)))
    annees
  else
    format(dates, "%Y-%m-%d")
}