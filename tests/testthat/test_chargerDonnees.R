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
  fix <- list.files("fixtures", pattern = "sirene_siren", full.names = TRUE)
  expect_length(fix, 1)
  fake_dl <- list(
    result = 0, zip = FALSE, type = "json",
    argsImport = list(fichier = fix, nom = "SIRENE_SIREN"),
    lien = "https://www.insee.fr/statistiques/fichier/12345/x",
    collection = "SIRENE", nom = "SIRENE_SIREN"
  )
  donnees <- chargerDonnees(fake_dl)
  expect_length(donnees, 3)
  expect_true(all(unlist(lapply(Filter(Negate(is.null), donnees), is.data.frame))))
  expect_warning(chargerDonnees(fake_dl, vars = c("siren")),
                 "Il n'est pas possible de filtrer les variables chargées en mémoire sur le format JSON pour le moment.")
})

## test chargement données JSON issues de l'API Sirene - partie etablissement
test_that("Chargement des données JSON de l'API Sirene - etablissement", {
  fix <- list.files("fixtures", pattern = "sirene_siret", full.names = TRUE)
  expect_length(fix, 1)
  fake_dl <- list(
    result = 0, zip = FALSE, type = "json",
    argsImport = list(fichier = fix, nom = "SIRENE_SIRET"),
    lien = "https://www.insee.fr/statistiques/fichier/12345/x",
    collection = "SIRENE", nom = "SIRENE_SIRET"
  )
  donnees <- chargerDonnees(fake_dl)
  expect_length(donnees, 6)
  expect_true(all(unlist(lapply(Filter(Negate(is.null), donnees), is.data.frame))))
  expect_warning(chargerDonnees(fake_dl, vars = c("siren")),
                 "Il n'est pas possible de filtrer les variables charg\u00e9es en m\u00e9moire sur le format JSON pour le moment.")
})
