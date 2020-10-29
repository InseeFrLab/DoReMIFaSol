liste_donnees <- read.csv("data-raw/liste_donnees.csv", header = TRUE, sep = ",", colClasses = c("character", "character", "character", "character", "character",
                                                                                                 "character", "logical", "logical", "character", "character",
                                                                                                 "character", "integer", "integer", "character", 
                                                                                                 "character", "character", "logical", "character", "integer"),
                          encoding = "UTF-8", fileEncoding = "UTF-8", na.strings = c("", " "))
liste_donnees <- within(liste_donnees, {
  #separateur <- gsub("\"", "", separateur)
  separateur <- ifelse(is.na(separateur), NA, paste0("quote(", separateur, ")"))
  date_ref <- as.Date(date_ref, format = "%d/%m/%Y")})
usethis::use_data(liste_donnees, overwrite = TRUE)

liste_var_ld <- names(liste_donnees)

## internal
#ld <- liste_donnees
#usethis::use_data(ld, internal = TRUE, overwrite = TRUE)

## json
write(jsonlite::toJSON(liste_donnees, pretty = TRUE), file = "data-raw/liste_donnees.json")

## internal
ld <- jsonlite::read_json("data-raw/liste_donnees.json")
ld <- lapply(ld, function(x) {
  within(x, {
    if (!is.null(x$date_ref))
      date_ref <- as.Date(date_ref, format = "%Y-%m-%d")
  })
})
## enrichissement du json
## typage des variables dans le COG
ld[[which(with(liste_donnees, nom == "COG_COMMUNE" & date_ref == as.Date("2018-01-01")))]]$type_col <- list(CDC = "integer",
                                                                                                            CHEFLIEU = "integer",
                                                                                                            REG = "character",
                                                                                                            DEP = "character",
                                                                                                            COM = "character",
                                                                                                            AR = "integer",
                                                                                                            CT = "character",
                                                                                                            TNCC = "integer",
                                                                                                            ARTMAJ = "character",
                                                                                                            NCC = "character",
                                                                                                            ARTMIN = "character",
                                                                                                            NCCENR = "character")
ld[[which(with(liste_donnees, nom == "COG_COMMUNE" & date_ref == as.Date("2019-01-01")))]]$type_col <- list(typecom = "character",
                                                                                                            com = "character",
                                                                                                            reg = "character",
                                                                                                            dep = "character",
                                                                                                            arr = "character",
                                                                                                            tncc = "integer",
                                                                                                            ncc = "character",
                                                                                                            nccenr = "character",
                                                                                                            libelle = "character",
                                                                                                            can = "character",
                                                                                                            comparent = "character")
## ajout labels des variables de Filosofi

## ajout du type de variables dans le RP

write(jsonify::pretty_json(jsonify::to_json(ld, unbox = TRUE, numeric_dates = FALSE)), file = "data-raw/liste_donnees.json")
usethis::use_data(ld, liste_var_ld, internal = TRUE, overwrite = TRUE)