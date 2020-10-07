#' Table des données disponible au téléchargement
#' 
#' Cette table est centrale au package ; elle recense l'ensemble des données disponibles et les liens associés permettant le téléchargement, ainsi que des éléments descriptifs de celles-ci.
#' 
#' @format Une table de 1315 lignes et 17 variables
#' \describe{
#' \item{nom}{l'identifiant des données}
#' \item{libelle}{le descriptif des données}
#' \item{date_ref}{éventuellement, la date de référence des données}
#' \item{collection}{la thématique ou la source}
#' \item{lien}{l'URL pour le téléchargement des données}
#' \item{type}{le format des données}
#' \item{zip}{les données sont-elles zippées ou non ?}
#' \item{big_zip}{?? (booléen)}
#' \item{fichier_donnees}{le nom du fichier de données, dans le zip éventuel}
#' \item{fichier_meta}{le nom du fichier descriptif des données, dans le zip éventuel}
#' \item{onglet}{nom de l'onglet, si fichier tableur}
#' \item{premiere_ligne}{première ligne à lire pour charger dans R, si fichier tableur}
#' \item{dernire_ligne}{dernière ligne à lire pour charger dans R, si fichier tableur}
#' \item{separateur}{séparateur de colonnes, si fichier texte}
#' \item{encoding}{encodage du fichier}
#' \item{valeurs_manquantes}{valeurs à remplacer par `NA` lors de l'import dans R}
#' \item{api_rest}{nécessité de passer par une API REST (booléen)}
#' }
#' 
"liste_donnees"