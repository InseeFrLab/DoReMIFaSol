liste_donnees <- read.csv("data/liste_donnees.csv", header = TRUE, sep = ",", colClasses = c("character", "character", "Date", "character",
                                                                                             "character", "logical", "character", "character"))

save(liste_donnees, file = "data/liste_donnees.rda")