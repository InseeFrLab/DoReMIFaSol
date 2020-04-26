#' Base de données Base Permanentes des Équipements
#' La base permanente des équipements (BPE) est une source statistique qui fournit le niveau d'équipements et de services rendus à la population sur un territoire. Les résultats sont proposés sous forme de bases de données dans différents formats et pour deux niveaux géographiques : les communes et les Iris.
#'
#' @source \url{https://www.insee.fr/fr/statistiques/fichier/3568629/bpe18_ensemble_csv.zip}

bpe_ens_2018 <- telechargerDonnees(donnees = "BPE_ENS", date = as.Date("01/01/2018"))
usethis::use_data(bpe_ens_2018, overwrite = TRUE)
