#' Télécharger des données sur le site de l'Insee
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
#' @return
#' - un data.frame contenant les données téléchargées sur le site de l'Insee
#' - une liste de data.frames si recherche de Siren ou Siret via l'API
#' @export
#'
#' @examples \dontrun{
#' 
#' # fichiers sur insee.fr
#' bpe_ens_2019 <- telechargerDonnees(donnees = "BPE_ENS")
#' rp_log <- telechargerDonnees("RP_LOGEMENT", date = "2016", vars = c("COMMUNE", "IPONDL", "CATL"))
#' 
#' # utilisation de l'API Sirene
#' telechargerDonnees("SIRENE_SIREN",         
#'                    argsApi = list(q = "dateCreationUniteLegale:2021-03-01", nombre = 100))
#' telechargerDonnees("SIRENE_SIRET",         
#'                    argsApi = list(q = "codeCommuneEtablissement:92046 
#'                                        AND categorieJuridiqueUniteLegale:9220"))
#' telechargerDonnees("SIRENE_SIRET_LIENS",   
#'                    argsApi = list(q = "siretEtablissementPredecesseur:31300257800042"))
#' telechargerDonnees("SIRENE_SIREN_NONDIFF", 
#'                    argsApi = list(q = "dateDernierTraitementUniteLegale:2019-04-15"))
#' telechargerDonnees("SIRENE_SIRET_NONDIFF", argsApi = list(q = "siren:480419449"))
#' }
#' @export

telechargerDonnees <- function(donnees, date=NULL, telDir=getOption("doremifasol.telDir"), argsApi=NULL, vars=NULL, force=FALSE, ...) {
  try(chargerDonnees(
    telechargerFichier(donnees, date, telDir, argsApi, force),
    vars,
    ...
  ))
}
