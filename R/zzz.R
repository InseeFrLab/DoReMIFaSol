.onLoad <- function(libname, pkgname) {
  #data(liste_donnees)
  if (curl::has_internet()) {
    requete_melodi <- httr::GET("https://minio.lab.sspcloud.fr/pierrelamarche/melodi/liste_donnees.json")
    ld_melodi <- jsonlite::fromJSON(httr::content(requete_melodi, as = "text", encoding = "utf-8"), 
                                    simplifyDataFrame = FALSE)
    ld_melodi <- lapply(ld_melodi, function(x) {
      within(x, {
        if (!is.null(x$date_ref))
          date_ref <- as.Date(date_ref, format = "%Y-%m-%d")
        if(!is.null(x$separateur))
          separateur <- paste0("quote(\"", separateur, "\")")
      })
    }
    )
    assign("ld", c(ld, ld_melodi),
           envir = asNamespace("doremifasol")
    )
  }
}