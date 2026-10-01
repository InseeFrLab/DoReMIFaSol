.onLoad <- function(libname, pkgname) {
  # Le catalogue Melodi est chargé de manière lazy (cf. ld_complet dans utile.R)
  # pour ne pas ralentir le chargement du package ni faire de requête réseau
  # au moment de library().
}
