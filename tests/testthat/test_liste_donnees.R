library(doremifasol)
## test que toutes les url de la table ld fonctionnent
# test_that("Teste l'ensemble des URL de la liste", {
#   expect_true(all(sapply(unique(ld$lien), url.exists)))
# })
df_ld <- listToDf(list = ld, vars = liste_var_ld)
df_ld$date_ref <- as.Date(df_ld$date_ref, origin = "1970-01-01")
## test unicité du couple nom - date_ref
test_that("Teste l'unicité du couple nom - millésime", {
  expect_true(all(!duplicated(df_ld[, c("nom", "date_ref")])))
})
## test bonne spécification du fichier Excel
test_that("Teste l'existence de l'onglet", {
  expect_true(all(with(df_ld, type %in% c("xls", "xlsx") & !is.na(premiere_ligne) | !type %in% c("xls", "xlsx"))))
})

test_that("pas de valeurs incongrues", {

  # date_ref (présence de NA normale ?)
  expect_true(
    all(grepl("\\d{4}-[0-1]\\d-[0-3]\\d", na.omit(df_ld$date_ref)))
  )

  # lien (motif, pas existence)
  url_pattern <- "^https://www.insee.fr/fr/statistiques/fichier/\\d{5,}/.+\\.(zip|xls|xlsx)$"
  api_url_pattern <- "^https://api.insee.fr/entreprises/sirene/sire[nt]$"
  expect_true(
    all(grepl(paste0(url_pattern, "|", api_url_pattern), df_ld$lien))
  )

  # type
  expect_true(
    all(df_ld$type[df_ld$api_rest] == "json")
  )
  expect_true(
    all(df_ld$type[!df_ld$api_rest] %in% c("csv", "xls", "xlsx"))
  )

  # zip
  expect_true(
    all(df_ld$zip %in% c(TRUE, FALSE))
  )

  # big_zip
  expect_true(
    all(df_ld$big_zip[df_ld$zip] %in% c(TRUE, FALSE))
  )

  # premiere_ligne / derniere_ligne
  expect_true(
    is.integer(df_ld$premiere_ligne)
  )
  expect_true(
    is.integer(df_ld$derniere_ligne)
  )
  pas_na <- with(df_ld, !is.na(premiere_ligne) & !is.na(derniere_ligne))
  expect_true(
    all(df_ld$premiere_ligne[pas_na] < df_ld$derniere_ligne[pas_na])
  )

  # api_rest
  expect_true(
    all(df_ld$api_rest %in% c(TRUE, FALSE))
  )

})
