library(doremifasol)
## téléchargement échoué
test_that("Simulation d'un échec de téléchargement", {
  expect_error(chargerDonnees(list(result = NULL)), "Le téléchargement a rencontré un problème.")
})
## test erreur sur le fichier qui n'est pas une archive
test_that("Simulation erreur de spécification de l'archive", {
  expect_error(chargerDonnees((list(result = 0, zip = TRUE, fileArchive = "test.zap"))), "Le fichier téléchargé n'est pas une archive zip.")
})
## test avertissement sur la nature du fichier
test_that("Avertissement sur l'extension du fichier à importer", {
  expect_warning(chargerDonnees(telechargerFichier("COG_COMMUNE", date = "2018")), "L'extension du fichier diffère du type de fichier.")
})
## test erreur sur l'existence du fichier à importer
test_that("Erreur non-existence du fichier de données", {
  expect_error(chargerDonnees(list(result = 0, zip = FALSE, type = "csv", argsImport = list(file = "test.csv"))), "Le fichier de données est introuvable.")
})
## test chargement données JSON issues de l'API Sirene
test_that("Chargement des données JSON de l'API Sirene", {
  dl <- telechargerFichier("SIRENE_SIREN", argsApi = list(nombre = 50))
  donnees <- chargerDonnees(dl)
  expect_true(length(donnees) == 3)
  expect_true(all(unlist(lapply(donnees, is.data.frame))))
  expect_warning(chargerDonnees(dl, vars = c("siren")), "Il n'est pas possible de filtrer les variables charg\u00e9es en m\u00e9moire sur le format JSON pour le moment.")
})
