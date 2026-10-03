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

## Integration gate: only run when DOREMI_INTEGRATION=true is set
## (set in the weekly schedule CI job). Skips fast-lane CI runs.
skip_unless_integration <- function() {
  if (identical(Sys.getenv("DOREMI_INTEGRATION"), "true")) {
    return(invisible(TRUE))
  }
  testthat::skip("Integration test: set DOREMI_INTEGRATION=true to run (weekly schedule).")
}
