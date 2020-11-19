library(doremifasol)

## test listToDf

test_that("Transformation liste données en data.frame", {
  
  expect_s3_class(
    listToDf(ld[1:100]),
    "data.frame"
  )

})

test_that("listToDf sur un exemple réduit", {
  
  mini_ld <-
    list(
      list(
        nom = "A",
        md5 = "xxxxx",
        size = 10L, 
        zip = FALSE,                                   # pas présent dans [[2]]
        label_col = list(V1 = "Lib v1", V2 = "Lib v2") # pas présent dans [[2]]
      ),
      list(
        nom = "B",
        date_ref = structure(17897, class = "Date"), # pas présent dans [[1]]
        api_rest = FALSE,                            # pas présent dans [[1]]
        md5 = "yyyyy", 
        size = 5L
      )
    )

  expect_identical(
    listToDf(mini_ld),
    data.frame(
      nom = c("A", "B"),
      md5 = c("xxxxx", "yyyyy"),
      size = c(10L, 5L),
      zip = c(FALSE, NA),
      date_ref = structure(c(NA, 17897), class = "Date"),
      api_rest = c(NA, FALSE), 
      stringsAsFactors = FALSE
    )
  )

})
