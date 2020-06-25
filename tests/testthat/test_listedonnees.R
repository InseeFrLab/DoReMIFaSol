library(doremifasol)
## test que toutes les url de la table ld fonctionnent
test_that("Teste l'ensemble des URL de la liste", {
  expect_true(all(sapply(unique(ld$lien), url.exists)))
})
## test unicité du couple nom - date_ref
test_that("Teste l'unicité du couple nom - millésime", {
  expect_true(all(!duplicated(ld[, c("nom", "date_ref")])))
})
## test bonne spécification du fichier Excel
test_that("Teste l'existence de l'onglet", {
  expect_true(all(with(ld, type %in% c("xls", "xlsx") & !is.na(onglet) | !type %in% c("xls", "xlsx"))))
})
test_that("Teste l'existence de l'onglet", {
  expect_true(all(with(ld, type %in% c("xls", "xlsx") & !is.na(premiere_ligne) | !type %in% c("xls", "xlsx"))))
})