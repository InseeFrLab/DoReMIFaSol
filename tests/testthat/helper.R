skip_if_no_app <- function() {
  if (nzchar(Sys.getenv("INSEE_API_TOKEN"))) {
    return(invisible(TRUE))
  }
  testthat::skip("Environment variable INSEE_API_TOKEN is not defined.")
}

app_maybe <- function() {
  skip_if_no_app()
  check_configuration()
}

check_configuration <- function() {
  skip_if_offline("api.insee.fr")
  skip_if_not_installed("httpuv")
}
