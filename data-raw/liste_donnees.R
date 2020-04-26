liste_donnees <- read.csv("data/liste_donnees.csv", header = TRUE, sep = ",", colClasses = c("character", "character", "Date", "character",
                                                                                             "character", "logical", "character", "character"),
                          encoding = "UTF-8", fileEncoding = "UTF-8")
usethis::use_data(liste_donnees, overwrite = TRUE)
