#' Title
#'
#' @param tableau 
#' @param annee 
#'
#' @return
#' @export
#'
#' @examples
estelCube <- function(tableau = c("T201", "T202"), annee) {
  tab <- telechargerDonnees(paste0("ESTEL_", tableau), date = annee)
  names(tab)[1] <- "geo"
  tab <- subset(tab, geo != "Niveau géographique")
  tab <- tidyr::pivot_longer(tab, -c(geo, onglet))
  tab <- within(tab, {
    annee <- as.numeric(substr(name, 1, 4))
    flag <- stringi::stri_match_last_regex(name, "\\(([a-z]*)\\)")[, 2]
    dep <- stringi::stri_match_last_regex(geo, "(^[0-9AB]{2,3})-")[, 2]
  })
  
  region <- telechargerDonnees("COG_REGION", "2019")
  tab <- merge(tab, region[, c("reg", "libelle")], by.x = "geo", by.y = "libelle", all.x = TRUE, sort = FALSE)
  
  tab <- within(tab,
                 niveau <- ifelse(!is.na(reg), "region", NA))
  
  departement <- telechargerDonnees("COG_DEPARTEMENT", "2019")
  tab <- merge(tab, departement[, c("dep", "reg")], by = "dep")
  tab <- within(tab, {
    reg <- ifelse(!is.na(reg.x), reg.x, reg.y)
    niveau <- ifelse(!is.na(reg.y), "departement", niveau)
  })
  tab <- tab[with(tab, order(reg, dep, onglet, annee)), ]
  return(tab[, c("geo", "dep", "reg", "onglet", "annee", "value", "flag")])
}