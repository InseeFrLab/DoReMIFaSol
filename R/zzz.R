.onLoad <- function(libname, pkgname) {
  #data(liste_donnees)
  liste_url <- c("https://minio.lab.sspcloud.fr/donnees-insee/liste_donnees.json",
                 "https://raw.githubusercontent.com/InseeFrLab/DoReMIFaSol/master/data-raw/liste_donnees.json")
  
  res <- lapply(liste_url, httr::GET)
  if (any(sapply(res, function(x) x$status_code != 200))){
    idx <- which(sapply(res, function(x) x$status_code == 200))[1]
    writeBin(res[[which(sapply(res, function(x) x$status_code == 200))[1]]]$content, "liste_donnees.json")
    liste_donnees <- ld <- jsonlite::fromJSON("liste_donnees.json")
    cat("Au d\u00e9marrage, chargement de la liste de donn\u00e9es depuis :\n", liste_url[2])
  } else {
    cat("Pas de mise \u00e0 jour disponible, liste de donn\u00e9es issue du package.")
  }
  
}