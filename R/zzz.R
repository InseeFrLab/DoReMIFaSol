.onLoad <- function(libname, pkgname) {
  #data(liste_donnees)
  assign("ld", listerDonnees(), envir = asNamespace("doremifasol"))
}