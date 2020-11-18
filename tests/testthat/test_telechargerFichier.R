library(doremifasol)
## téléchargement de la BPE
test_that("Téléchargement de données sur le site de l'Insee", {
  vcr::use_cassette("data_insee", {
    expect_true(telechargerFichier("BPE_ENS")$result == 0)},
    record = "new_episodes"
  )
})
## erreur - oubli de la date
test_that("Téléchargement de données sur le site de l'Insee", {
  vcr::use_cassette("data_insee", {
    expect_error(telechargerFichier("FILOSOFI_COM"), "Il faut spécifier une date de référence pour ces données")},
    record = "new_episodes"
  )
})
## erreur - date non disponible
test_that("Téléchargement de données sur le site de l'Insee", {
  vcr::use_cassette("data_insee", {
    expect_error(telechargerFichier("FILOSOFI_COM", date = format(Sys.Date(), format = "%Y")), "La date spécifiée n'est pas disponible.")},
    record = "new_episodes"
  )
})
## date correctement spécifiée
test_that("Téléchargement de données sur le site de l'Insee - date spécifiée", {
  vcr::use_cassette("data_insee", {
    expect_true(telechargerFichier("FILOSOFI_COM", date = "2015")$result == 0)
    expect_true(telechargerFichier("FILOSOFI_COM", date = "01/01/2015")$result == 0)
  },
  record = "new_episodes"
  )
})
## pas de dézippage
test_that("Téléchargement de données sur le site de l'Insee - données non zippées", {
  vcr::use_cassette("data_insee", {
    expect_true(telechargerFichier("FILOSOFI_DEC_IRIS")$result == 0)},
    record = "new_episodes"
  )
})
## mauvais nom - pas disponible au téléchargement
test_that("Échec du téléchargement pour nom non existant", {
  vcr::use_cassette("data_insee", {
    expect_error(telechargerFichier("TEST"), "Le paramètre donnees est mal spécifié, la valeur n'est pas référencée")},
    record = "new_episodes"
  )
})
## spécification du dossier de stockage
test_that("Spécification du dossier de stockage", {
  vcr::use_cassette("data_insee", {
    dl <- telechargerFichier("BPE_ENS", telDir = "test_dl")
    expect_true(file.exists("test_dl/bpe19_ensemble_csv.zip"))
    unlink("test_dl", recursive = TRUE)}, 
    record = "new_episodes"
  )
})
## test utilisation du cache
test_that("Données déjà téléchargées", {
  vcr::use_cassette("data_insee", {
    telechargerFichier("ESTEL_T201", date = "2016")
    expect_message(
      telechargerFichier("ESTEL_T202", date = "2016"),
      "Données déjà présentes dans .+, pas de nouveau téléchargement."
    )
  },
  record = "new_episodes"
  )
})
## test hash non cohérent
test_that("Hash non cohérent", {
  vcr::use_cassette("data_insee", {
    file.create(z <- file.path(tempdir(), "comsimp2018-txt.zip"))
    expect_message(telechargerFichier("COG_COMMUNE", date = "2018"), "Les données doivent être mises à jour.")
    file.remove(z)
  },
  record = "new_episodes"
  )
})
## test dl de données CSV
test_that("Télécharger type CSV - output correct", {
  vcr::use_cassette("data_insee", {
    expect_true(telechargerFichier("COG_COMMUNE", date = "2019")$result == 0)},
    record = "new_episodes"
  )
})
## test dl de données XLS
test_that("Télécharger type XLS - output correct", {
  vcr::use_cassette("data_insee", {
    expect_true(telechargerFichier("FILOSOFI_COM", date = "2014")$result == 0)},
    record = "new_episodes"
  )
})
## test dl de données XLSX
test_that("Télécharger type XLSX - output correct", {
  vcr::use_cassette("data_insee", {
    expect_true(telechargerFichier("AIRE_URBAINE")$result == 0)},
    record = "new_episodes"
  )
})
## test spécification de l'encodage
test_that("Télécharger des données avec un encodage spécifique", {
  vcr::use_cassette("data_insee", {
    expect_true(!is.null(telechargerFichier("COG_COMMUNE", date = "2018")$argsImport$locale))},
    record = "new_episodes"
  )
})
## test spécification des valeurs manquantes
test_that("Télécharger des données avec des valeurs manquantes spécifiques", {
  vcr::use_cassette("data_insee", {
    expect_true(!is.null(telechargerFichier("ESTEL_T201", date = "2015")$argsImport$na))},
    record = "new_episodes"
  )
})
## test dl sur l'API Sirene avec une date spécifiée
test_that("Télécharger des données sur l'API à la date du jour", {
  vcr::use_cassette("data_insee", {
    skip_if_no_app()
    check_configuration()
    expect_true(telechargerFichier("SIRENE_SIRET", date = Sys.Date(), argsApi = list(nombre = 3000))$result == 0)},
    record = "new_episodes"
  )
})
## test dl sur l'API Sirene avec une condition
test_that("Télécharger des données sur l'API pour les entreprises créées un jour donné", {
  vcr::use_cassette("data_insee", {
    skip_if_no_app()
    check_configuration()
    expect_true(telechargerFichier("SIRENE_SIRET", argsApi = list(q = "dateCreationUniteLegale:1983-03-04"))$result == 0)},
    record = "new_episodes"
  )
})
## test dl sur l'API Sirene d'un gros volume respectant la contrainte du nombre de requêtes par minute
test_that("Télécharger des données sur l'API pour les entreprises créées un jour donné", {
  vcr::use_cassette("data_insee", {
    skip_if_no_app()
    check_configuration()
    expect_true(telechargerFichier("SIRENE_SIREN", argsApi = list(nombre = 60000))$result == 0)},
    record = "new_episodes"
  )
})