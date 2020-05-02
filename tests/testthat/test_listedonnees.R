library(doremifasol)
## test que toutes les url de la table ld fonctionnent
test_that("Teste l'ensemble des URL de la liste", {
  expect_true(all(sapply(unique(ld$lien), url.exists)))
})