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
  expect_error(telechargerDonnees("FILOSOFI_COM", date = format(Sys.Date(), format = "%Y")), "La date spécifiée n'est pas disponible.")
})
## mauvais nom - pas disponible au téléchargement
test_that("Échec du téléchargement pour nom non existant", {
  expect_error(telechargerDonnees("TEST"), "Le paramètre donnees est mal spécifié, la valeur n'est pas référencée")
})
## test utilisation du cache
test_that("Utilisation du cache", {
  temp <- telechargerDonnees("ESTEL_T201", date = "2016")
  expect_message(telechargerDonnees("ESTEL_T202", date = "2016"), "Utilisation du cache")
})
## test import de données CSV
test_that("Importation type CSV - output data.frame", {
  expect_true(class(telechargerDonnees("COG_COMMUNE", date = "2019")) == "data.frame")
})
## test import de données XLS
test_that("Importation type XLS - output data.frame", {
  expect_true(class(telechargerDonnees("FILOSOFI_COM", date = "2014")) == "data.frame")
})
test_that("Importation type XLS - import de tous les onglets", {
  expect_true(class(telechargerDonnees("ESTEL_T201", date = "31/12/2016")) == "data.frame")
})
## test import de données XLSX
test_that("Importation type XLSX - output data.frame", {
  expect_true(class(telechargerDonnees("AIRE_URBAINE")) == "data.frame")
})
## test sélection des variables
test_that("Sélection de variables dans la BPE", {
  expect_true(length(names(telechargerDonnees(donnees = "BPE_ENS", vars = c("REG", "DEP", "DEPCOM", "NB_EQUIP")))) == 4)
})
## test dézip gros fichiers
test_that("Utilisation de unzip système", {
  expect_true(class(telechargerDonnees("RP_MOBSCO", date = "2016", vars = c("COMMUNE", "ARM", "CSM"))) == "data.frame")
})
