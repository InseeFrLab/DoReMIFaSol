library(doremifasol)

context("consulter")

test_that("url web correctes", {
  
  expect_equal(
    consulter(donnees = "BPE_ENS"),
    "https://www.insee.fr/fr/statistiques/8217527"
  )
  
  expect_equal(
    consulter("RP_LOGEMENT", date = "2016"),
    "https://www.insee.fr/fr/statistiques/4229099"
  )  
  
})
