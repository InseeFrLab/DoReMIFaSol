## test sur les sirets successeurs
test_that("Téléchargement des successeurs", {
  skip_if_not_installed("vcr")
  vcr::local_cassette("sirets_successeurs")
  successeurs <- sirets_successeurs(c("30070230500040", "30137492200120", "30082187300019"))
  expect_s3_class(successeurs, c("insee_data_frame", "data.frame"))
})
## test erreur sur un siret sans successeur
test_that("Erreur sur un siret sans successeur", {
  skip_if_not_installed("vcr")
  vcr::local_cassette("sirets_successeurs_404")
  successeur <- sirets_successeurs("32957439600019")
  expect_true(nrow(successeur) == 0)
})
