library(doremifasol)
## téléchargement de la BPE
test_that("Téléchargement de données sur le site de l'Insee", {
  expect_true(telechargerFichier("BPE_ENS")$result == 0)
})
## erreur - oubli de la date
test_that("Téléchargement de données sur le site de l'Insee", {
  expect_error(telechargerFichier("FILOSOFI_COM"), "Il faut spécifier une date de référence pour ces données")
})
## erreur - date non disponible
test_that("Téléchargement de données sur le site de l'Insee", {
  expect_error(telechargerFichier("FILOSOFI_COM", date = format(Sys.Date(), format = "%Y")), "La date spécifiée n'est pas disponible.")
})
## mauvais nom - pas disponible au téléchargement
test_that("Échec du téléchargement pour nom non existant", {
  expect_error(telechargerFichier("TEST"), "Le paramètre donnees est mal spécifié, la valeur n'est pas référencée")
})
## spécification du dossier de stockage
test_that("Spécification du dossier de stockage", {
  dir.create("test_dl")
  dl <- telechargerFichier("BPE_ENS", telDir = "test_dl")
  expect_true(file.exists("test_dl/bpe18_ensemble_csv.zip"))
  unlink("test_dl", recursive = TRUE)
})
## test utilisation du cache
test_that("Utilisation du cache", {
  temp <- telechargerFichier("ESTEL_T201", date = "2016")
  expect_message(telechargerFichier("ESTEL_T202", date = "2016"), "Utilisation du cache")
})
