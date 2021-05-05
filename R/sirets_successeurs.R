#' Liens de succession d'une liste d'établissements
#' 
#' Télécharge sur l'API Sirene l'ensemble des successeurs d'une liste
#' d'établissements.
#' 
#' Cette fonction appelle [`telechargerDonnees`] pour chacun des établissements
#' passés en paramètre (de manière optimisée).
#' 
#' Les données téléchargées au format "json" sont enregistrées dans un dossier
#' temporaire.
#' 
#' @section Authentification API Sirene:
#' Comme toutes les fonctions reposant sur l'[API](https://api.insee.fr) Sirene,
#' cette fonction nécessite une clé d'application et un secret associé pour 
#' pouvoir générer un jeton d'accès. Ces informations sont à passer sous forme
#' de variables d'envionnement.
#' 
#' Renseigner pour cela `INSEE_APP_KEY` et `INSEE_APP_SECRET` dans un fichier
#' de configuration `.Renviron`.
#' Consulter [cette page](https://api.insee.fr/catalogue/site/themes/wso2/subthemes/insee/pages/help.jag)
#' pour de l'aide sur comment obtenir de tels identifiants.
#'
#' @param sirets sirets pour lesquel rechercher les successeurs (un vecteur caractère)
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
