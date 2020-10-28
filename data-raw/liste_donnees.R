liste_donnees <- read.csv("data-raw/liste_donnees.csv", header = TRUE, sep = ",", colClasses = c("character", "character", "character", "character", "character",
                                                                                                 "character", "logical", "logical", "character", "character",
                                                                                                 "character", "integer", "integer", "character", 
                                                                                                 "character", "character", "logical", "character", "integer"),
                          encoding = "UTF-8", fileEncoding = "UTF-8", na.strings = c("", " "))
liste_donnees <- within(liste_donnees, {
  #separateur <- gsub("\"", "", separateur)
  separateur <- ifelse(is.na(separateur), NA, paste0("quote(", separateur, ")"))
  date_ref <- as.Date(date_ref, format = "%d/%m/%Y")})
usethis::use_data(liste_donnees, overwrite = TRUE)

liste_var_ld <- names(liste_donnees)

## internal
#ld <- liste_donnees
#usethis::use_data(ld, internal = TRUE, overwrite = TRUE)

## json
write(jsonlite::toJSON(liste_donnees, pretty = TRUE), file = "data-raw/liste_donnees.json")

## internal
ld <- jsonlite::read_json("data-raw/liste_donnees.json")
ld <- lapply(ld, function(x) {
  within(x, {
    if (!is.null(x$date_ref))
      date_ref <- as.Date(date_ref, format = "%Y-%m-%d")
  })
})
usethis::use_data(ld, liste_var_ld, internal = TRUE, overwrite = TRUE)