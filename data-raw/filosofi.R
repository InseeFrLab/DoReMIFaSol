## Filosofi
##2015
# niveau communal
filosofi_com_2015 <- telechargerDonnees(donnees = "FILOSOFI_COM", date = as.Date("01/01/2015", format = "%d/%m/%Y"))
Encoding(filosofi_com_2015$LIBGEO) <- "UTF-8" ## Solves encoding issue
usethis::use_data(filosofi_com_2015, overwrite = TRUE)
# niveau EPCI
filosofi_epci_2015 <- telechargerDonnees(donnees = "FILOSOFI_EPCI", date = as.Date("01/01/2015", format = "%d/%m/%Y"))
Encoding(filosofi_epci_2015$LIBGEO) <- "UTF-8" ## Solves encoding issue
usethis::use_data(filosofi_epci_2015, overwrite = TRUE)
##2016
# niveau communal
filosofi_com_2016 <- telechargerDonnees(donnees = "FILOSOFI_COM", date = as.Date("01/01/2016", format = "%d/%m/%Y"))
Encoding(filosofi_com_2016$LIBGEO) <- "UTF-8" ## Solves encoding issue
usethis::use_data(filosofi_com_2016, overwrite = TRUE)
# niveau EPCI
filosofi_epci_2016 <- telechargerDonnees(donnees = "FILOSOFI_EPCI", date = as.Date("01/01/2016", format = "%d/%m/%Y"))
Encoding(filosofi_epci_2016$LIBGEO) <- "UTF-8" ## Solves encoding issue
usethis::use_data(filosofi_epci_2016, overwrite = TRUE)