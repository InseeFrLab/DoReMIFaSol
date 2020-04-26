#' Base de données Base Permanentes des Équipements Géolocalisés
#' 
#' La base permanente des équipements (BPE) est une source statistique qui fournit le niveau d'équipements et de services rendus à la population sur un territoire. Les résultats sont proposés sous forme de bases de données dans différents formats et pour deux niveaux géographiques : les communes et les Iris.
#'
#' @format Une table de 2 504 782 lignes et 9 variables
#' \describe{
#' \item{REG}{Région d’implantation de l’équipement}
#' \item{DEP}{Département d’implantation de l’équipement}
#' \item{DEPCOM}{Département et commune d’implantation de l’équipement}
#' \item{DCIRIS}{Département, commune et IRIS d’implantation de l’équipement}
#' \item{AN}{Année}
#' \item{TYPEQU}{Type d'équipement}
#' \item{LAMBERT_X}{Coordonnée X de l’équipement (Lambert 93 (RGF93) pour la France métropolitaine, UTM40S pour La Réunion, UTM20N pour la Martinique et la Guadeloupe, UTM22N pour la Guyane)}
#' \item{LAMBERT_Y}{Coordonnée Y de l’équipement (Lambert 93 (RGF93) pour la France métropolitaine, UTM40S pour La Réunion, UTM20N pour la Martinique et la Guadeloupe, UTM22N pour la Guyane)}
#' \item{QUALITE_XY}{Qualité d’attribution pour un équipement de ses coordonnées XY}
#' }
#'
#' @encoding UTF-8
#' @source \url{https://www.insee.fr/fr/statistiques/3568638?sommaire=3568656#consulter}
"bpe_ens_xy_2018"