liste_donnees <- read.csv("data-raw/liste_donnees.csv", header = TRUE, sep = ",", colClasses = c("character", "character", "character", "character",
                                                                                                 "character", "logical", "logical", "character", "character",
                                                                                                 "character", "integer", "integer", "character", 
                                                                                                 "character"),
                          encoding = "UTF-8", fileEncoding = "UTF-8", na.strings = c("", " "))
liste_donnees <- within(liste_donnees, {
  #separateur <- gsub("\"", "", separateur)
  separateur <- ifelse(is.na(separateur), NA, paste0("quote(", separateur, ")"))
  date_ref = as.Date(date_ref, format = "%d/%m/%Y")})
usethis::use_data(liste_donnees, overwrite = TRUE)

## internal
ld <- liste_donnees
usethis::use_data(ld, internal = TRUE, overwrite = TRUE)
