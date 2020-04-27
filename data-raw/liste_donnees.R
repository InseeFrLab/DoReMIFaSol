liste_donnees <- read.csv("data-raw/liste_donnees.csv", header = TRUE, sep = ",", colClasses = c("character", "character", "Date", "character",
                                                                                             "character", "logical", "character", "character",
                                                                                             "character", "integer"),
                          encoding = "UTF-8", fileEncoding = "UTF-8", na.strings = c("", " "))
usethis::use_data(liste_donnees, overwrite = TRUE)

## internal
ld <- liste_donnees
usethis::use_data(ld, internal = TRUE, overwrite = TRUE)
