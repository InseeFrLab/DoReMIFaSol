#' Liens de succession d'une liste d'établissements
#' 
#' Télécharge les successeurs d'une liste d'établissements sur l'API Sirene.
#' 
#' Nécessite :
#' - les informations de connexion à l'api Sirene sous la forme de variables
#'   d'environnement (INSEE_APP_KEY = ... et INSEE_APP_SECRET = ... dans un
#'   fichier .Renviron)
#'   
#' Géré automatiquement par doremifasol :
#' - création du jeton (via le package apinsee)
#' - requêtes max par minute
#'
#' @param sirets sirets à rechercher (un vecteur caractère)
#'
#' @return Un data.frame agrégeant les résultats pour chaque siret (vide si
#'   aucun des établissements n'a de successeur).
#'
#' @export
#' 
#' @examples \dontrun{
#' 
#' sirets_successeurs(c("30070230500040", "30137492200120", "30082187300019"))
#' }

sirets_successeurs <- function(sirets) {
  
  stopifnot(
    is.character(sirets),
    length(sirets) > 0
  )

  sirets <- unique(sirets)

  # si l'url de la requete est trop longue (plus de 3400 caracteres, limite
  # max estimee empiriquement), une erreur survient
  # -> on fait des groupes de 68 sirets
  grp_sirets <- split(sirets, (seq_along(sirets) - 1) %/% 68)

  sortie_tot <- lapply(unname(grp_sirets), sucesseurs_no_404)

  # agrege
  sortie_tot <- do.call(rbind, sortie_tot)

  unique(sortie_tot)

}

# Fonction auxiliaire

sucesseurs_no_404 <- function(sirets) {
  # telecharge successeurs avec gestion des requêtes sans résultat

  # construit requete
  query <-
    paste(
      paste("siretEtablissementPredecesseur", sirets, sep = ":"),
      collapse = " OR "
    )

  # appel API via doremifasol (si 404 -> data.frame vide)
  tryCatch(

    telechargerDonnees(
      "SIRENE_SIRET_LIENS",
      argsApi = list(q = query),
      telDir = tempdir()
    ),

    error = function(cnd) {
      if (grepl("^Erreur 404 : Aucun lien", cnd$message)) {
        data.frame()
      } else {
        stop("Erreur :", cnd$message)
      }
    }

  )

}
