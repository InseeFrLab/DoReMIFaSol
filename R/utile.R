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
#' @return Une unique ligne de `liste_donnees` (sous forme de data.frame).

infosDonnees <- function(donnees, date = NULL) {
  
  donnees <- toupper(donnees) # pour rendre insensible à la casse
  res <- ld[ld$nom == donnees, ]

  # 1 - identifiant introuvable

  if (!nrow(res)) {

    # cherche des identifiants proches (distance de Levenshtein)
    dist <- utils::adist(ld$nom, donnees)[ , 1]
    suggestions <- ld$nom[dist < 4] # 3 fautes de frappe max
    suggestions_quote <- paste0('"', unique(suggestions), '"')

    stop(
      "Le param\u00e8tre donnees est mal sp\u00e9cifi\u00e9, la valeur n'est pas r\u00e9f\u00e9renc\u00e9e.",
      "\n  Nom(s) proche(s) : ", if (length(suggestions)) toString(suggestions_quote) else "aucun"
    )

  }

  # 2 - gestion millésimes

  possible <- millesimesDisponibles(donnees)

  if (length(possible) > 1) {

    if (is.null(date)) {
      stop(
        "Il faut sp\u00e9cifier une date de r\u00e9f\u00e9rence pour ces donn\u00e9es.\n",
        "  Valeurs possibles : ", toString(sort(possible))
      )
    }

    if (nchar(date) == 4) {
      select <- format(res$date_ref, "%Y") == as.character(date)
    } else {
      select <- res$date_ref == as.Date(date, format = "%d/%m/%Y")
    }
  
    if (!any(select)) stop("La date sp\u00e9cifi\u00e9e n'est pas disponible.")
    if (sum(select, na.rm = TRUE) > 1) stop("Donn\u00e9es infra-annuelles a priori. Mieux sp\u00e9cifier la date de r\u00e9f\u00e9rence.")
    
    res <- res[select, ]

  }

  res

}
