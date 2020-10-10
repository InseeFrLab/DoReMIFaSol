library(doremifasol)
## test que toutes les url de la table ld fonctionnent
# test_that("Teste l'ensemble des URL de la liste", {
#   expect_true(all(sapply(unique(ld$lien), url.exists)))
# })
## test unicité du couple nom - date_ref
test_that("Teste l'unicité du couple nom - millésime", {
  expect_true(all(!duplicated(ld[, c("nom", "date_ref")])))
})
## test bonne spécification du fichier Excel
test_that("Teste l'existence de l'onglet", {
  expect_true(all(with(ld, type %in% c("xls", "xlsx") & !is.na(premiere_ligne) | !type %in% c("xls", "xlsx"))))
})

test_that("pas de valeurs incongrues", {

  # date_ref (présence de NA normale ?)
  expect_true(
    all(grepl("\\d{4}-[0-1]\\d-[0-3]\\d", na.omit(ld$date_ref)))
  )

  # lien (motif, pas existence)
  url_pattern <- "^https://www.insee.fr/fr/statistiques/fichier/\\d{5,}/.+\\.(zip|xls)$"
  api_url_pattern <- "^https://api.insee.fr/entreprises/sirene/sire[nt]$"
  expect_true(
    all(grepl(paste0(url_pattern, "|", api_url_pattern), ld$lien))
  )

  # type
  expect_true(
    all(ld$type[ld$api_rest] == "json")
  )
  expect_true(
    all(ld$type[!ld$api_rest] %in% c("csv", "xls", "xlsx"))
  )

  # zip
  expect_true(
    all(ld$zip %in% c(TRUE, FALSE))
  )

  # big_zip
  expect_true(
    all(ld$big_zip[ld$zip] %in% c(TRUE, FALSE))
  )

  # premiere_ligne / derniere_ligne
  expect_true(
    is.integer(ld$premiere_ligne)
  )
  expect_true(
    is.integer(ld$derniere_ligne)
  )
  pas_na <- with(ld, !is.na(premiere_ligne) & !is.na(derniere_ligne))
  expect_true(
    all(ld$premiere_ligne[pas_na] < ld$derniere_ligne[pas_na])
  )

  # api_rest
  expect_true(
    all(ld$api_rest %in% c(TRUE, FALSE))
  )

})
