# Recherche ligne d'informations dans liste_donnees

À partir de l'identifiant et d'une éventuelle date, isole la ligne de
[`liste_donnees`](https://InseeFrLab.github.io/DoReMIFaSol/reference/liste_donnees.md)
correspondante.

## Usage

``` r
infosDonnees(donnees, date = NULL, silencieux = FALSE)
```

## Arguments

- donnees:

  le nom court des données que l'on souhaite télécharger sur le site de
  l'Insee. La description complète des données associés à ce nom figure
  dans la table
  [`liste_donnees`](https://InseeFrLab.github.io/DoReMIFaSol/reference/liste_donnees.md).
  Insensible à la casse.

- date:

  optionnel : le millésime des données si nécessaire. Peut prendre le
  format YYYY ou encore DD/MM/YYYY ; dans le dernier cas, on prendra le
  premier jour de la période de référence. Spécifier `"dernier"`
  sélectionne automatiquement le millésime le plus récent.

- silencieux:

  mettre à `TRUE` pour ne pas afficher les messages.

## Value

Une unique ligne de `liste_donnees` (sous forme de list).

## Details

La fonction retourne une erreur si aucune ligne ne correspond. Elle
suggère dans ce cas des noms d'identifiants proches et les millésimes
disponibles si l'année doit être spécifiée.
