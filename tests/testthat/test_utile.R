library(doremifasol)
## test listToDf
test_that("Transformation liste données en data.frame", {
  expect_output(str(listToDf(ld)), "data.frame")
})
