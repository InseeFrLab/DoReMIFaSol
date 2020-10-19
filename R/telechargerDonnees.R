#' Téléchargement des données sur le site de l'Insee
#'
#' @inheritParams telechargerFichier
#' @param donnees le nom des données que l'on souhaite télécharger sur le site de l'Insee, que l'on peut retrouver dans la table [`liste_donnees`].
#' @param argsApi optionnel : dans le cas où c'est une API REST qui est utilisée, il est possible de spécifier des paramètres spécifiques à cette API de manière à collecter l'information désirée.
#' @param vars optionnel : un vecteur pour spécifier les variables à importer. Utile pour les données massives difficiles à charger en mémoire, voir section _Details_.
#' @param ... paramètres additionnels relatifs à l'importation des données
#' 
#' @details 
#' La fonction permet de télécharger les données disponibles sur le site de l'Insee sous format csv, xls ou encore xlsx. Les données mises à disposition sont en général des tables de taille raisonnable, qui peuvent être chargées sans problème en mémoire sur un large spectre de machines. Néanmoins, pour certaines données (telles celles du Recensement de Population ou encore SIRENE), les données sont très volumineuses et exigent donc des machines très performantes. L'utilisateur a donc la possibilité de choisir les variables qui l'intéressent et de ne charger que ces dernières en mémoire, de manière à être parcimonieux.
#'
#' @return un objet tibble contenant les données téléchargées sur le site de l'Insee.
#' @export
#'
#' @examples \dontrun{
#' bpe_ens_2018 <- telechargerDonnees(donnees = "BPE_ENS")
#' 
#' rp_log <- telechargerDonnees("RP_LOGEMENT", date = "2016", vars = c("COMMUNE", "IPONDL", "CATL"))
#' }
#' @importFrom utils download.file unzip read.csv tail
#' @export
telechargerDonnees <- function(donnees, date=NULL, telDir=getOption("doremifasol.telDir"), argsApi=NULL, vars=NULL, force=FALSE, ...) {
  chargerDonnees(
    telechargerFichier(donnees, date, telDir, argsApi, force),
    vars,
    ...
  )
}
