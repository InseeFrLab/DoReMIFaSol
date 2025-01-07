.onLoad <- function(libname, pkgname) {
  #data(liste_donnees)
  if (curl::has_internet()) {
    ld_melodi <- tryCatch(recupererMelodi("https://minio.lab.sspcloud.fr/pierrelamarche/melodi/liste_donnees.json"),
                          error = function(e) packageStartupMessage("Le catalogue Melodi n'a pas pu \u00eatre t\u00e9l\u00e9charg\u00e9.\n", e$message))
    
    assign("ld", c(ld, ld_melodi),
           envir = asNamespace("doremifasol")
    )
  }
}