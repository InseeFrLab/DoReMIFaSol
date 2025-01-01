.onLoad <- function(libname, pkgname) {
  #data(liste_donnees)
  if (curl::has_internet())
    ld_melodi <- httr::GET("https://minio.lab.sspcloud.fr/pierrelamarche/melodi/liste_donnees.json")
    assign("ld", c(ld, jsonlite::fromJSON(httr::content(ld_melodi, as = "text", encoding = "utf-8"), 
                                          simplifyDataFrame = FALSE)),
           envir = asNamespace("doremifasol")
          )
}