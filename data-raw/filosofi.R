## Filosofi
##2015
# niveau communal
filosofi_com_2015 <- telechargerDonnees(donnees = "FILOSOFI_COM", date = "2015")
Encoding(filosofi_com_2015$LIBGEO) <- "UTF-8" ## Solves encoding issue
usethis::use_data(filosofi_com_2015, overwrite = TRUE)
# niveau EPCI
filosofi_epci_2015 <- telechargerDonnees(donnees = "FILOSOFI_EPCI", date = "2015")
Encoding(filosofi_epci_2015$LIBGEO) <- "UTF-8" ## Solves encoding issue
usethis::use_data(filosofi_epci_2015, overwrite = TRUE)
##2016
# niveau communal
filosofi_com_2016 <- telechargerDonnees(donnees = "FILOSOFI_COM", date = "2016")
Encoding(filosofi_com_2016$LIBGEO) <- "UTF-8" ## Solves encoding issue
usethis::use_data(filosofi_com_2016, overwrite = TRUE)
# niveau EPCI
filosofi_epci_2016 <- telechargerDonnees(donnees = "FILOSOFI_EPCI", date = "2016")
Encoding(filosofi_epci_2016$LIBGEO) <- "UTF-8" ## Solves encoding issue
usethis::use_data(filosofi_epci_2016, overwrite = TRUE)