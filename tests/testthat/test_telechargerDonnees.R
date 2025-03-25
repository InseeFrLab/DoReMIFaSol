library(doremifasol)
## téléchargement de la BPE
test_that("Téléchargement de données sur le site de l'Insee", {
  expect_output(str(telechargerDonnees("BPE_ENS")), "data.frame")
})
## erreur - oubli de la date
test_that("Téléchargement de données sur le site de l'Insee", {
  expect_s3_class(
    telechargerDonnees("FILOSOFI_COM"), 
    "try-error")
})
## erreur - date non disponible
test_that("Téléchargement de données sur le site de l'Insee", {
  expect_s3_class(
    telechargerDonnees("FILOSOFI_COM", date = format(Sys.Date(), format = "%Y")),
    "try-error"
  )
})
## mauvais nom - pas disponible au téléchargement
test_that("Échec du téléchargement pour nom non existant", {
  expect_s3_class(
    telechargerDonnees("TEST"),
    "try-error"
  )
})
## test utilisation du cache
test_that("Utilisation du cache", {
  # note : ESTEL_T201 et ESTEL_T202 sont dans le même fichier
  temp <- telechargerDonnees("ESTEL_T201", date = "2016")
  expect_message(
    telechargerDonnees("ESTEL_T202", date = "2016"),
    "Données déjà présentes dans .+, pas de nouveau téléchargement."
  )
})
## test import de données CSV
test_that("Importation type CSV - output data.frame", {
  expect_s3_class(
    telechargerDonnees("COG_COMMUNE", date = "2019"),
    c("insee_data_frame", "data.frame"),
    exact = TRUE
  )
})
## test import de données XLS
test_that("Importation type XLS - output data.frame", {
  expect_s3_class(     
    telechargerDonnees("FILOSOFI_COM", date = "2014"),
    c("insee_data_frame", "data.frame"),
    exact = TRUE
  )
})
test_that("Importation type XLS - import de tous les onglets", {
  expect_s3_class(     
    telechargerDonnees("ESTEL_T201", date = "31/12/2016"),
    c("insee_data_frame", "data.frame"),
    exact = TRUE
  )
})
## test import de données XLSX
test_that("Importation type XLSX - output data.frame", {
  expect_s3_class(
    telechargerDonnees("TAG_COM", date = 2025),
    c("insee_data_frame", "data.frame"),
    exact = TRUE
  )
})
test_that("Importation type XLSX - output data.frame", {
  expect_type(
    telechargerDonnees("FILOSOFI_DISP_COM", date = 2017),
    "list"
  )
})
## test import de données parquet
test_that("Importation type parquet - output data.frame", {
  expect_s3_class(
    telechargerDonnees("RP_MOBSCO", date = 2021),
    c("insee_data_frame", "data.frame"),
    exact = TRUE
  )
})
## test import de qq variables parquet
test_that("Importation type parquet - sélection de variables", {
  expect_true(
    length(names(telechargerDonnees("RP_MOBSCO", date = 2021, vars = c("COMMUNE", "ARM")))) == 2
  )
})
## test sélection des variables
test_that("Sélection de variables dans la BPE", {
  expect_true(length(names(telechargerDonnees(donnees = "BPE_ENS", vars = c("GEO", "GEO_OBJECT", "FACILITY_TYPE", "OBS_VALUE")))) == 4)
})
## test dézip gros fichiers
test_that("Utilisation de unzip système", {
  expect_s3_class(
    telechargerDonnees("RP_MOBSCO", date = "2016", vars = c("COMMUNE", "ARM", "CSM")),
    c("insee_data_frame", "data.frame"),
    exact = TRUE
  )
})
## test import du dernier millésime
test_that("Importation dernier millésime - output data.frame", {
  expect_s3_class(
    telechargerDonnees("COG_COMMUNE", date = "dernier"),
    c("insee_data_frame", "data.frame"),
    exact = TRUE
  )
})
## test dl sur un lien mort
test_that("Importation d'un lien mort - retourne une erreur 404", {
  skip_if_no_app()
  check_configuration()
  expect_s3_class(telechargerDonnees("TEST_BPE_NEXIST"),
                  "try-error")
})
## test dl sur l'API Sirene avec une requête invalide
test_that("Télécharger des données sur l'API pour les entreprises créées un jour donné", {
  skip_if_no_app()
  check_configuration()
  expect_s3_class(telechargerDonnees("SIRENE_SIRET_LIENS", argsApi = list(q = "siretEtablissementPredecesseur:32957439600019")), 
                  "try-error")
})
## test dl sur l'API Sirene avec une requête sur les unités non diffusibles
test_that("Télécharger des données sur l'API pour les unités non diffusibles", {
  skip_if_no_app()
  check_configuration()
  expect_s3_class(telechargerDonnees("SIRENE_SIREN_NONDIFF", argsApi = list(q = 'dateDernierTraitementUniteLegale:"2018-11-01"')),
                  "try-error")
})
## test erreur de syntaxe dans la requête de l'API
test_that("Erreur de syntaxe dans la requête sur l'API Sirene", {
  skip_if_no_app()
  check_configuration()
  expect_s3_class(telechargerDonnees("SIRENE_SIREN_NONDIFF", 
                                     argsApi = list(q = 'dateDernierTraitementUniteLegale:"2018-11-01" TO "2018-11-15"')),
                  "try-error")
})
## test dl de données sur mélodi - csv zippé
test_that("Télécharger un produit csv zippé sur melodi", {
  expect_s3_class(telechargerDonnees("DS_ANTIPOL_CSV_FR"),
                  c("insee_data_frame", "data.frame"))
})
## test dl de données sur mélodi - XLSX
test_that("Télécharger un produit xlsx zippé sur melodi", {
  expect_type(telechargerDonnees("ANTIPOL_GLOBAL_T0_FR"),
                  "list")
})
