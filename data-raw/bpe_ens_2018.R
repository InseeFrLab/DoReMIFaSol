#' Base de données Base Permanentes des Équipements
#' 
#' La base permanente des équipements (BPE) est une source statistique qui fournit le niveau d'équipements et de services rendus à la population sur un territoire. Les résultats sont proposés sous forme de bases de données dans différents formats et pour deux niveaux géographiques : les communes et les Iris.
#'
#' @format Une table de 1 035 564 lignes et 7 variables
#' \describe{
#' \item{REG}{Région d’implantation de l’équipement}
#' \item{DEP}{DEP Département d’implantation de l’équipement}
#' \item{DEPCOM}{Département et commune d’implantation de l’équipement}
#' \item{DCIRIS}{Département, commune et IRIS d’implantation de l’équipement}
#' \item{AN}{Année}
#' \item{TYPEQU}{Type d'équipement}
#' \item{NB_EQUIP}{Nombre d’équipements}
#' }
#'
#' @source \url{https://www.insee.fr/fr/statistiques/fichier/3568629/bpe18_ensemble_csv.zip}
bpe_ens_2018 <- telechargerDonnees(donnees = "BPE_ENS", col_types = "ccccncn")
usethis::use_data(bpe_ens_2018, overwrite = TRUE)