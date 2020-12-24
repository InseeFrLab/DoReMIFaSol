liste_donnees <- jsonlite::read_json("data-raw/liste_donnees.json")
## mise en forme des données
liste_donnees <- lapply(liste_donnees, function(x) {
  if (!is.null(x$separateur))
    x$separateur <- paste0("quote(\"", x$separateur, "\")")
  if (!is.null(x$date_ref))
    x$date_ref <- as.Date(x$date_ref, format = "%Y-%m-%d")
  return(x)
})
liste_var_ld <- Reduce(intersect, lapply(liste_donnees, names))
ld <- liste_donnees
#liste_donnees <- do.call(rbind, lapply(liste_donnees, function(x) data.frame(x[liste_var_ld])))
liste_donnees <- data.frame(do.call(rbind, lapply(liste_donnees, `[`, liste_var_ld)))

usethis::use_data(liste_donnees, overwrite = TRUE)
usethis::use_data(ld, liste_var_ld, internal = TRUE, overwrite = TRUE)

ld <- lapply(ld, function(x) {
  if (!is.null(x$separateur))
    x$separateur <- sub("quote\\(\"(.*)\"\\)", "\\1", x$separateur)
  return(x)
})
write(jsonify::pretty_json(jsonify::to_json(ld, unbox = TRUE, numeric_dates = FALSE)), file = "data-raw/liste_donnees.json")
