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
