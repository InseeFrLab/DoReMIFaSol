#' Code Officiel Géographique
#' Le Code Officiel Géographique est une source statistique de référence publiée par l’Insee, 
#' qui rassemble les codifications (numérotations et libellés) officielles des communes, 
#' des cantons, des arrondissements, des départements, des régions, des collectivités d'outre-mer, des pays et territoires étrangers.
#'
#'
#' @source \url{https://www.insee.fr/fr/statistiques/fichier/3720946/cog_ensemble_2019_csv.zip}

COG_communes_2019 <- telechargerDonnees(donnees = "COG_COMMUNE_2019", date = as.Date("01/01/2019"))
usethis::use_data(cog_communes_2019, overwrite = TRUE)
