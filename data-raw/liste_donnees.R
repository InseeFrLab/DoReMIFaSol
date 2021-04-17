## read json to ld and save it
ld <- jsonlite::read_json("data-raw/liste_donnees.json")
ld <- lapply(ld, function(x) {
  within(x, {
    if (!is.null(x$date_ref))
      date_ref <- as.Date(date_ref, format = "%Y-%m-%d")
    if(!is.null(x$separateur))
      separateur <- paste0("quote(\"", separateur, "\")")
  })
})
liste_var_ld <- names(doremifasol::liste_donnees)

usethis::use_data(ld, liste_var_ld, internal = TRUE, overwrite = TRUE)

## save liste_donnees

source("R/utile.R")
liste_donnees <- listToDf(liste = ld, vars = liste_var_ld)
usethis::use_data(liste_donnees, internal = FALSE, overwrite = TRUE)
