## test sur les sirets successeurs
test_that("Téléchargement des successeurs", {
  successeurs <- sirets_successeurs(c("30070230500040", "30137492200120", "30082187300019"))
  print(successeurs)
  expect_s3_class(successeurs, 
  c("insee_data_frame", "data.frame"))
})
## test erreur sur un siret sans successeur
test_that("Erreur sur un siret sans successeur", {
  successeur <- sirets_successeurs("32957439600019")
  expect_true(nrow(successeur) == 0)
})