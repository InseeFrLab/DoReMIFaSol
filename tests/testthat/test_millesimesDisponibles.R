library(doremifasol)
## mauvais nom - pas disponible au téléchargement
test_that("Échec pour nom non existant", {
  expect_error(millesimesDisponibles("TEST"), "Le paramètre donnees est mal spécifié, la valeur n'est pas référencée")
})
### différents millésimes disponibles
test_that("Plusieurs millésimes disponibles", {
  expect_true(length(millesimesDisponibles("RP_LOGEMENT")) > 1)
})