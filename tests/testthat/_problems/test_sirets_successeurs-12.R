# Extracted from test_sirets_successeurs.R:12

# test -------------------------------------------------------------------------
skip_if_not_installed("vcr")
vcr::local_cassette("sirets_successeurs_404")
successeur <- sirets_successeurs("32957439600019")
