library(doremifasol)
## téléchargement échoué
test_that("Simulation d'un échec de téléchargement", {
  expect_error(chargerDonnees(list(result = NULL)))
})
## test erreur sur le fichier qui n'est pas une archive
test_that("Simulation erreur de spécification de l'archive", {
  expect_error(chargerDonnees((list(result = 0, zip = TRUE, fileArchive = "test.zap"))), "Le fichier téléchargé n'est pas une archive zip.")
})
## test erreur sur l'existence du fichier à importer
test_that("Erreur non-existence du fichier de données", {
  expect_error(chargerDonnees(list(result = 0, zip = FALSE, type = "csv", argsImport = list(file = "test.csv"))), "Le fichier de données est introuvable.")
})
## test chargement données JSON issues de l'API Sirene - partie UL
test_that("Chargement des données JSON de l'API Sirene - UL", {
  skip_if_no_app()
  check_configuration()
  dl <- telechargerFichier("SIRENE_SIREN", argsApi = list(nombre = 50))
  donnees <- chargerDonnees(dl)
  expect_true(length(donnees) == 3)
  expect_true(all(unlist(lapply(donnees, is.data.frame))))
  expect_warning(chargerDonnees(dl, vars = c("siren")), "Il n'est pas possible de filtrer les variables charg\u00e9es en m\u00e9moire sur le format JSON pour le moment.")
})

## test chargement données JSON issues de l'API Sirene - partie etablissement
test_that("Chargement des données JSON de l'API Sirene - etablissement", {
  skip_if_no_app()
  check_configuration()
  dl <- telechargerFichier("SIRENE_SIRET", argsApi = list(nombre = 50))
  donnees <- chargerDonnees(dl)
  expect_true(length(donnees) == 6)
  expect_true(all(unlist(lapply(donnees, is.data.frame))))
  expect_warning(chargerDonnees(dl, vars = c("siren")), "Il n'est pas possible de filtrer les variables charg\u00e9es en m\u00e9moire sur le format JSON pour le moment.")
})
