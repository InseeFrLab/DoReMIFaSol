# Tests sur la validité des paramètres, vérifier que la page web s'est bien
# créée étant impossible (?)

test_that("détecte paramètres incorrects", {
  
  expect_error(
    donnees_dispo(entrees = "dix"),
    "is.numeric.+entrees"
  )
  
  expect_error(
    donnees_dispo(pos_filtre = "top"),
    "haut.+bas.+aucun"
  )
  
  expect_warning(
    donnees_dispo(data = iris),
    "`data` pas modifiable"
  )
  
  expect_warning(
    donnees_dispo(colnames = LETTERS),
    "`colnames` pas modifiable"
  )
  
  expect_warning(
    donnees_dispo(rownames = TRUE),
    "`rownames` pas modifiable"
  ) 
  
})
