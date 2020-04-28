library(DoReMIFaSol)
## téléchargement de la BPE
test_that("Téléchargement de données sur le site de l'Insee", {
  expect_output(str(telechargerDonnees("BPE_ENS")), "data.frame")
})
## erreur - oubli de la date
test_that("Téléchargement de données sur le site de l'Insee", {
 expect_error(telechargerDonnees("FILOSOFI_COM"))
})
## mauvais nom - pas disponible au téléchargement
test_that("Échec du téléchargement pour nom non existant", {
  expect_error((telechargerDonnees("TEST")))
})