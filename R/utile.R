# FONCTIONS AUXILIAIRES NON EXPORTÉES

# infoDonnees -------------------------------------------------------------

#' Recherche ligne d'informations dans liste_donnees
#'
#' À partir de l'identifiant et d'une éventuelle date, isole la ligne de
#' [`liste_donnees`] correspondante.
#' 
#' La fonction retourne une erreur si aucune ligne ne correspond. Elle suggère
#' dans ce cas des noms d'identifiants proches et les millésimes disponibles si
#' l'année doit être spécifiée.
#'
#' @inheritParams telechargerFichier
#'
#' @return Une unique ligne de `liste_donnees` (sous forme de list).
#' 
#' @keywords internal

infosDonnees <- function(donnees, date = NULL) {
  
  donnees <- toupper(donnees) # pour rendre insensible à la casse
  liste_nom <- unlist(lapply(ld, function(x) return(x$nom)))
  res <- ld[which(liste_nom == donnees)]

  # 1 - identifiant introuvable

  if (!length(res)) {

    # cherche des identifiants proches (distance de Levenshtein)
    dist <- utils::adist(liste_nom, donnees)[ , 1]
    suggestions <- liste_nom[dist < 4] # 3 fautes de frappe max
    suggestions_quote <- paste0('"', unique(suggestions), '"')

    stop(
      "Le param\u00e8tre donnees est mal sp\u00e9cifi\u00e9, la valeur n'est pas r\u00e9f\u00e9renc\u00e9e.",
      "\n  Nom(s) proche(s) : ", if (length(suggestions)) toString(suggestions_quote) else "aucun"
    )

  }

  # 2 - gestion millésimes

  possible <- millesimesDisponibles(donnees)

  if (!is.null(date) && tolower(date) == "dernier") {
    date <- sort(possible, decreasing = TRUE)[1]
    message(
      "S\u00e9lection automatique des donn\u00e9es les plus r\u00e9centes ",
      "(date = ", date, ")."
    )
  }

  if (length(possible) > 1) {

    if (is.null(date)) {
      stop(
        "Il faut sp\u00e9cifier une date de r\u00e9f\u00e9rence pour ces donn\u00e9es.\n",
        "  Valeurs possibles : ", toString(sort(possible))
      )
    }
    
    dates_possibles <- as.Date(unlist(lapply(res, function(x) return(x$date_ref))), origin = "1970-01-01")
    if (nchar(date) == 4) {
      select <- which(format(dates_possibles, "%Y") == as.character(date))
    } else {
      select <- which(dates_possibles == as.Date(date, format = "%d/%m/%Y"))
    }
  
    if (!length(select)) stop("La date sp\u00e9cifi\u00e9e n'est pas disponible.")
    if (length(select) > 1) stop("Donn\u00e9es infra-annuelles a priori. Mieux sp\u00e9cifier la date de r\u00e9f\u00e9rence.")
    
    res <- res[select]

  }

  res[[1]]

}

# listToDf -------------------------------------------------------------
#' 
#' Transforme une liste (typiquement `ld`) en data.frame
#' 
#' Objectif : ne pas créer une dépendance à `dplyr` et la fonction `bind_rows`, bien que du point de vue computationel, la fonction créée ici soit bien moins performante.
#'
#' @param liste un objet list à convertir en data.frame
#' @param vars optionnel, un vecteur de variables à récupérer
#'
#' @return Une data.frame
#' 
#' @keywords internal

listToDf <- function(liste, vars = NULL) {

  if (is.null(vars)) {
    vars_atom <- lapply(liste, function(x) names(x)[sapply(x, is.atomic)])
    vars <- unique(unlist(vars_atom))
  }
  
  vars_date <- lapply(liste, function(x) names(x)[sapply(x, inherits, "Date")])
  vars_date <-
    intersect(
      vars,
      unique(unlist(vars_date))
    )

  do.call(
    rbind,
    lapply(
      liste,
      function(x) {
        vars_manquantes <- setdiff(vars, names(x))
        x[vars_manquantes] <- NA
        x[vars_date] <- lapply(x[vars_date], as.Date)
        data.frame(
          x[vars],
          stringsAsFactors = FALSE
        )
      }
    )
  )

}
