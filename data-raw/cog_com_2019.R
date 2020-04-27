#' Code Officiel Géographique 2019
#' 
#' Liste des communes au 1er janvier 2019
#' 
#' @format Une table avec 37 930 lignes et 11 variables
#' \describe{
#' \item{TYPCOM}{Type de commune}
#' \item{COM}{Code commune}
#' \item{REG}{Code région}
#' \item{DEP}{Code département}
#' \item{ARR}{Code arrondissement}
#' \item{TNCC}{Type de nom en clair}
#' \item{NCC}{Nom en clair (majuscules)}
#' \item{NCCENR}{Nom en clair (typographie riche)}
#' \item{LIBELLE}{Nom en clair (typographie riche) avec article}
#' \item{CAN}{Code canton. Pour les communes « multi-cantonales » code décliné de 99 à 90 (pseudo-canton) ou de 89 à 80 (communes nouvelles) }
#' \item{COMPARENT}{Code de la commune parente pour les arrondissements municipaux et les communes associées ou déléguées. }
#' }
#' 
#' @source \url{https://www.insee.fr/fr/information/3720946}
cog_com_2019 <- telechargerDonnees(donnees = "COG_COMMUNE", date = as.Date("01/01/2019"), col_types = c("character", "character", "character", "character",
                                                                                                         "character", "character", "character", "character",
                                                                                                         "character", "character", "character"))
Encoding(cog_com_2019$ncc) <- "UTF-8"
Encoding(cog_com_2019$nccenr) <- "UTF-8"
Encoding(cog_com_2019$libelle) <- "UTF-8"
usethis::use_data(cog_com_2019, overwrite = TRUE)