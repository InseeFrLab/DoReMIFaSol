#' Visualiser les données disponibles
#'
#' Ouvre une page web permettant de consulter de manière interactive les données
#' disponibles (recherche, filtres, tri...), en particulier pour trouver les
#' noms courts à passer en paramètre de [telechargerDonnees].
#'
#' @param recherche_init recherche initiale d'un terme dans les colonnes de la
#'   table (modifiable interactivement par la suite). Insensible à la casse.
#' @param entrees nombre de lignes affichées à l'écran au lancement de la page
#'   (modifiable interactivement par la suite).
#' @param pos_filtre emplacement des filtres spécifiques à chaque colonne
#'   (`"haut"` (défaut), `"bas"` ou `"aucun"`).
#' @param ... arguments supplémentaires pour [`DT::datatable`].
#'
#' @export
#'
#' @examples
#' donnees_dispo()
#' donnees_dispo("commune")

donnees_dispo <- function(recherche_init = NULL,
                          entrees = 10,
                          pos_filtre = c("haut", "bas", "aucun"),
                          ...) {

  # 0 - vérifications
  stopifnot(is.numeric(entrees))
  pos_filtre <-
    switch(
      match.arg(pos_filtre),
      "haut"  = "top",
      "bas"   = "bottom",
      "aucun" = "none"
    )
  if (is.null(recherche_init)) recherche_init <- ""

  # 1 - construit table à afficher
  affich <- listToDf(liste = ld, vars = c("collection", "libelle", "nom", "date_ref", "size"))
  affich$size <- round(as.numeric(affich$size) / 1048576, 1) # conversion Mo
  affich <- affich[order(affich$collection, -rank(affich$date_ref), affich$nom), ]

  # 2 - paramètres additionnels pour DT::datatable
  params <- list(...)

  # 2.1 - paramètres non modifiables
  if (any(names(params) == "data"))     warning("`data` pas modifiable")
  if (any(names(params) == "rownames")) warning("`rownames` pas modifiable")
  if (any(names(params) == "colnames")) warning("`colnames` pas modifiable")
  params$data     <- affich
  params$rownames <- FALSE
  params$colnames <- c("Collection", "Description", "Nom court",
                       "Date de r\u00e9f\u00e9rence", "Taille (Mo)")
  params$extensions <- c("Buttons")

  # 2.2 - paramètres modifiables,
  #       mais avec valeurs défaut différentes de celles de DT::data.table
  if (!any(names(params) == "class"))   params$class  <- "cell-border stripe"
  if (!any(names(params) == "filter"))  params$filter <- pos_filtre
  
  if (!any(names(params) == "options")) {
    params$options <- list(pageLength = entrees)
  }
  
  params$options <- c(
    params$options,
    list(
      dom = 'Blfrtip',
      buttons = c('csv','excel', 'pdf'),
      searching  = TRUE,
      search     = list(search = recherche_init),
      language   = list(
        search       = "Recherche :",
        zeroRecords  = "Aucun r\u00e9esultat.",
        lengthMenu   = "Afficher _MENU_ lignes",
        info         = "Lignes _START_-_END_ sur _TOTAL_",
        infoEmpty    = "Aucun r\u00e9esultat",
        infoFiltered = "(filtre actif)",
        thousands    = "",
        paginate =
          list(
            previous = "Pr\u00e9c\u00e9dent",
            `next`   = "Suivant"
          )
      )
    )
  )

  # 3 - génération table
  do.call(DT::datatable, params)

}
