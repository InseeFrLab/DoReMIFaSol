# Extracted from test_sirets_successeurs.R:5

# test -------------------------------------------------------------------------
skip_if_not_installed("vcr")
vcr::local_cassette("sirets_successeurs")
successeurs <- sirets_successeurs(c("30070230500040", "30137492200120", "30082187300019"))
