# VCR configuration for offline replay of SIRENE API responses.
# Cassettes live in tests/testthat/fixtures/cassettes/.
#
# Record new cassettes locally with a real token:
#   vcr::vcr_configure(dir = "fixtures/cassettes", record = "once",
#                      filter_request_headers = list(`X-INSEE-Api-Key-Integration` = "REDACTED"))
#   then run the relevant test.
#
# In CI (fast lane) and locally, record = "none" replays committed cassettes.

skip_if_not_installed("vcr")

# telechargerFichier checks for INSEE_API_TOKEN before making any HTTP call.
# VCR intercepts at the HTTP layer, so a dummy token satisfies the guard
# without any real credential being needed.
if (!nzchar(Sys.getenv("INSEE_API_TOKEN"))) {
  Sys.setenv(INSEE_API_TOKEN = "vcr-test-token")
}

vcr::vcr_configure(
  dir                    = "fixtures/cassettes",
  record                 = "none",
  filter_request_headers = list(`X-INSEE-Api-Key-Integration` = "REDACTED")
)
