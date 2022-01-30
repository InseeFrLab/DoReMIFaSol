.onLoad <- function(libname, pkgname) {
  #data(liste_donnees)
  liste_url <- c("https://minio.lab.sspcloud.fr/donnees-insee/liste_donnees.json",
                 "https://raw.githubusercontent.com/InseeFrLab/DoReMIFaSol/master/data-raw/liste_donnees.json")
  
  res <- lapply(liste_url, httr::GET)
  if (any(sapply(res, function(x) x$status_code != 200))){
    writeBin(res[[which(sapply(res, function(x) x$status_code == 200))[1]]]$content, "liste_donnees.json")
    ld <- jsonlite::fromJSON("liste_donnees.json")
  }
  
}