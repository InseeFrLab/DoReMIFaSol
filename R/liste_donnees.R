#' Table des données disponible au téléchargement
#' 
#' Cette table est centrale au package ; elle recense l'ensemble des données disponibles et les liens associés permettant le téléchargement, ainsi que des éléments descriptifs de celles-ci.
#' 
#' @format Une table de 2 lignes et 8 variables
#' \describe{
#' \item{nom}{l'identifiant des données}
#' \item{libelle}{le descriptif des données}
#' \item{date_ref}{éventuellement, la date de référence des données}
#' \item{lien}{l'URL pour le téléchargement des données}
#' \item{type}{le format des données}
#' \item{zip}{les données sont-elles zippées ou non ?}
#' \item{fichier_donnees}{le nom du fichier de données, dans le zip éventuel}
#' \item{fichier_meta}{le nom du fichier descriptif des données, dans le zip éventuel}
#' }
#' 
"liste_donnees"