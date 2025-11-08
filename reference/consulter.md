# Consulter le descriptif des données sur insee.fr

Consulter le descriptif des données sur insee.fr

## Usage

``` r
consulter(donnees, date = NULL, url_only = FALSE)
```

## Arguments

- donnees:

  le nom des données dont on veut consulter la page sur le site de
  l'Insee. La description complète des données associées à ce nom figure
  dans la table
  ([liste_donnees](https://InseeFrLab.github.io/DoReMIFaSol/reference/liste_donnees.md)).

- date:

  optionnel : le millésime des données si nécessaire. Peut prendre le
  format YYYY ou encore DD/MM/YYYY ; dans le dernier cas, on prendra le
  premier jour de la période de référence. Spécifier `"dernier"`
  sélectionne automatiquement le millésime le plus récent.

- url_only:

  `TRUE` pour seulement récupérer l'URL de la page sans ouvrir le
  navigateur.

## Value

Par défaut, la fonction ouvre le lien dans le navigateur. Elle retourne
accessoirement le lien vers la page web, de manière invisible.

## Examples

``` r
consulter(donnees = "BPE_ENS")
consulter("RP_LOGEMENT", date = "2016")
# Pour seulement obtenir l'URL de la page
consulter("RP_LOGEMENT", date = "2016", url_only = TRUE)
#> [1] "https://www.insee.fr/fr/statistiques/4229099"
```
