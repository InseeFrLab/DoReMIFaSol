## test sur les sirets successeurs
test_that("Téléchargement des successeurs", {
  successeurs <- sirets_successeurs(c("30070230500040", "30137492200120", "30082187300019"))
  print(successeurs)
  expect_true(class(successeurs)[1] == "insee_data_frame")
})