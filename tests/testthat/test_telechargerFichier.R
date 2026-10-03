library(doremifasol)
## téléchargement du COG
test_that("Téléchargement de données sur le site de l'Insee", {
  skip_unless_integration()
  expect_true(telechargerFichier("COG_COMMUNE", date = 2022)$result == 0)
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
  skip_unless_integration()
  expect_true(telechargerFichier("FILOSOFI_COM", date = "2015")$result == 0)
  expect_true(telechargerFichier("FILOSOFI_COM", date = "01/01/2015")$result == 0)
})
## pas de dézippage
test_that("Téléchargement de données sur le site de l'Insee - données non zippées", {
  skip_unless_integration()
  expect_true(telechargerFichier("FILOSOFI_DEC_IRIS")$result == 0)
})
## mauvais nom - pas disponible au téléchargement
test_that("Échec du téléchargement pour nom non existant", {
  expect_error(telechargerFichier("TEST"), "Le paramètre donnees est mal spécifié, la valeur n'est pas référencée")
})
## fichier non existant, marqué non disponible
test_that("Échec du téléchargement car fichier marqué non disponible", {
  expect_error(telechargerFichier("TEST_BPE_NEXIST", "Fichier non disponible au téléchargement."))
})
## spécification du dossier de stockage
test_that("Spécification du dossier de stockage", {
  skip_unless_integration()
  dl <- telechargerFichier("COG_COMMUNE", date = 2022, telDir = "test_dl")
  expect_true(file.exists("test_dl/cog_ensemble_2022_csv.zip"))
  unlink("test_dl", recursive = TRUE)
})
## test utilisation du cache
test_that("Données déjà téléchargées", {
  skip_unless_integration()
  telechargerFichier("ESTEL_T201", date = "2016")
  expect_message(
    telechargerFichier("ESTEL_T202", date = "2016"),
    "Données déjà présentes dans .+, pas de nouveau téléchargement."
  )
})
## test hash non cohérent
test_that("Hash non cohérent", {
  skip_unless_integration()
  file.create(z <- file.path(tempdir(), "comsimp2018-txt.zip"))
  expect_message(telechargerFichier("COG_COMMUNE", date = "2018", telDir = tempdir()), "Les données doivent être mises à jour.")
  file.remove(z)
})
## test dl de données CSV
test_that("Télécharger type CSV - output correct", {
  skip_unless_integration()
  expect_true(telechargerFichier("COG_COMMUNE", date = "2019")$result == 0)
})
## test dl de données XLS
test_that("Télécharger type XLS - output correct", {
  skip_unless_integration()
  expect_true(telechargerFichier("FILOSOFI_COM", date = "2014")$result == 0)
})
## test dl de données XLSX
test_that("Télécharger type XLSX - output correct", {
  skip_unless_integration()
  expect_true(telechargerFichier("TAG_COM", date = "2025")$result == 0)
})
## test dl de données parquet
test_that("Télécharger type parquet - output correct", {
  skip_unless_integration()
  expect_true(telechargerFichier("RP_MOBSCO", 2021)$result == 0)
})
## test spécification de l'encodage
test_that("Télécharger des données avec un encodage spécifique", {
  skip_unless_integration()
  expect_true(!is.null(telechargerFichier("COG_COMMUNE", date = "2018")$argsImport$locale))
})
## test spécification des valeurs manquantes
test_that("Télécharger des données avec des valeurs manquantes spécifiques", {
  skip_unless_integration()
  expect_true(!is.null(telechargerFichier("ESTEL_T201", date = "2015")$argsImport$na))
})
## test dl sur l'API Sirene avec une date spécifiée (VCR cassette — offline)
test_that("Télécharger des données sur l'API à la date du jour", {
  skip_if_not_installed("vcr")
  vcr::local_cassette("sirene_siret_date")
  expect_true(telechargerFichier("SIRENE_SIRET", date = "2024-01-15", argsApi = list(nombre = 50))$result == 0)
})
## test dl sur l'API Sirene avec une condition (VCR cassette — offline)
test_that("Télécharger des données sur l'API pour les entreprises créées un jour donné", {
  skip_if_not_installed("vcr")
  vcr::local_cassette("sirene_siret_condition")
  expect_true(telechargerFichier("SIRENE_SIRET", argsApi = list(q = "dateCreationUniteLegale:1983-03-04"))$result == 0)
})
## test dl sur l'API Sirene d'un gros volume respectant la contrainte du nombre de requêtes par minute
## (live only — exercises real 429 rate-limit back-off)
test_that("Télécharger des données sur l'API pour un gros volume", {
  skip_unless_integration()
  skip_if_no_app()
  check_configuration()
  expect_true(telechargerFichier("SIRENE_SIREN", argsApi = list(nombre = 6000))$result == 0)
})
