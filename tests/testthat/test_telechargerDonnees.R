library(doremifasol)
## téléchargement de la BPE
test_that("Téléchargement de données sur le site de l'Insee", {
  expect_output(str(telechargerDonnees("BPE_ENS")), "data.frame")
})
## erreur - oubli de la date
test_that("Téléchargement de données sur le site de l'Insee", {
 expect_error(telechargerDonnees("FILOSOFI_COM"))
})
## erreur - date non disponible
test_that("Téléchargement de données sur le site de l'Insee", {
  expect_error(telechargerDonnees("FILOSOFI_COM", date = Sys.Date()), "La date spécifiée n'est pas disponible.")
})
## mauvais nom - pas disponible au téléchargement
test_that("Échec du téléchargement pour nom non existant", {
  expect_error(telechargerDonnees("TEST"), "Le paramètre donnees est mal spécifié, la valeur n'est pas référencée")
})
## spécification du dossier de stockage
test_that("Spécification du dossier de stockage", {
  dir.create("test_dl")
  telechargerDonnees("BPE_ENS", telDir = "test_dl")
  expect_true(file.exists("test_dl/bpe18_ensemble_csv.zip"))
  unlink("test_dl", recursive = TRUE)
})
## test import de données CSV
test_that("Importation type CSV - output data.frame", {
  expect_true(class(telechargerDonnees("COG_COMMUNE", date = as.Date("01/01/2019", format = "%d/%m/%Y"))) == "data.frame")
})
## test import de données XLS
test_that("Importation type XLS - output data.frame", {
  expect_true(class(telechargerDonnees("FILOSIFI_COM", date = as.Date("01/01/2014", format = "%d/%m/%Y"))) == "data.frame")
})
## test import de données XLSX
test_that("Importation type XLSX - output data.frame", {
  expect_true(class(telechargerDonnees("AIRE_URBAINE")) == "data.frame")
})