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
## date correctement spécifiée
test_that("Téléchargement de données sur le site de l'Insee - date spécifiée", {
  expect_true(telechargerFichier("FILOSOFI_COM", date = "2015")$result == 0)
  expect_true(telechargerFichier("FILOSOFI_COM", date = "01/01/2015")$result == 0)
})
## pas de dézippage
test_that("Téléchargement de données sur le site de l'Insee - données non zippées", {
  expect_true(telechargerFichier("FILOSOFI_DEC_IRIS")$result == 0)
})
## mauvais nom - pas disponible au téléchargement
test_that("Échec du téléchargement pour nom non existant", {
  expect_error(telechargerFichier("TEST"), "Le paramètre donnees est mal spécifié, la valeur n'est pas référencée")
})
## spécification du dossier de stockage
test_that("Spécification du dossier de stockage", {
  dl <- telechargerFichier("BPE_ENS", telDir = "test_dl")
  expect_true(file.exists("test_dl/DS_BPE_CSV_FR.zip"))
  unlink("test_dl", recursive = TRUE)
})
## test utilisation du cache
test_that("Données déjà téléchargées", {
  telechargerFichier("ESTEL_T201", date = "2016")
  expect_message(
    telechargerFichier("ESTEL_T202", date = "2016"),
    "Données déjà présentes dans .+, pas de nouveau téléchargement."
  )
})
## test hash non cohérent
test_that("Hash non cohérent", {
  file.create(z <- file.path(tempdir(), "comsimp2018-txt.zip"))
  expect_message(telechargerFichier("COG_COMMUNE", date = "2018", telDir = tempdir()), "Les données doivent être mises à jour.")
  file.remove(z)
})
## test dl de données CSV
test_that("Télécharger type CSV - output correct", {
  expect_true(telechargerFichier("COG_COMMUNE", date = "2019")$result == 0)
})
## test dl de données XLS
test_that("Télécharger type XLS - output correct", {
  expect_true(telechargerFichier("FILOSOFI_COM", date = "2014")$result == 0)
})
## test dl de données XLSX
test_that("Télécharger type XLSX - output correct", {
  expect_true(telechargerFichier("AIRE_URBAINE")$result == 0)
})
## test dl de données parquet
test_that("Télécharger type parquet - output correct", {
  expect_true(telechargerFichier("RP_MOBSCO", 2021)$result == 0)
})
## test spécification de l'encodage
test_that("Télécharger des données avec un encodage spécifique", {
  expect_true(!is.null(telechargerFichier("COG_COMMUNE", date = "2018")$argsImport$locale))
})
## test spécification des valeurs manquantes
test_that("Télécharger des données avec des valeurs manquantes spécifiques", {
  expect_true(!is.null(telechargerFichier("ESTEL_T201", date = "2015")$argsImport$na))
})
## test dl sur l'API Sirene avec une date spécifiée
test_that("Télécharger des données sur l'API à la date du jour", {
  skip_if_no_app()
  check_configuration()
  expect_true(telechargerFichier("SIRENE_SIRET", date = Sys.Date(), argsApi = list(nombre = 3000))$result == 0)
})
## test dl sur l'API Sirene avec une condition
test_that("Télécharger des données sur l'API pour les entreprises créées un jour donné", {
  skip_if_no_app()
  check_configuration()
  expect_true(telechargerFichier("SIRENE_SIRET", argsApi = list(q = "dateCreationUniteLegale:1983-03-04"))$result == 0)
})
## test dl sur l'API Sirene d'un gros volume respectant la contrainte du nombre de requêtes par minute
test_that("Télécharger des données sur l'API pour les entreprises créées un jour donné", {
  skip_if_no_app()
  check_configuration()
  expect_true(telechargerFichier("SIRENE_SIREN", argsApi = list(nombre = 60000))$result == 0)
})
