# Télécharger un fichier sur le site de l'Insee

Télécharger un fichier sur le site de l'Insee

## Usage

``` r
telechargerFichier(
  donnees,
  date = NULL,
  telDir = getOption("doremifasol.telDir"),
  argsApi = NULL,
  force = FALSE
)
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

- telDir:

  optionnel : le dossier dans lequel sont téléchargées les données
  brutes. Par défaut, la valeur définie par
  `options(doremifasol.telDir = ...)`. Si l'utilisateur n'a pas défini
  cette valeur au préalable, un dossier temporaire de cache.

- argsApi:

  optionnel : dans le cas où c'est une API REST qui est utilisée, il est
  possible de spécifier des paramètres spécifiques à cette API de
  manière à collecter l'information désirée. Cf. section *Details*.

- force:

  forcer le téléchargement, même si le fichier a déjà été téléchargé (et
  est identique).

## Value

Une liste contenant le résultat du téléchargement et les informations
pour l'importation des données en R (de manière invisible).

## Details

La fonction permet de télécharger les données disponibles sur le site de
l'Insee sous format csv, xls ou encore xlsx. Elle permet également, de
manière expérimentale, de requêter certaines API REST de l'Insee ; ces
services peuvent être repérés dans la table
[`liste_donnees`](https://InseeFrLab.github.io/DoReMIFaSol/reference/liste_donnees.md)
grâce à la variable `api_rest`.

## Examples

``` r
if (FALSE) { # \dontrun{
telechargerFichier(donnees = "BPE_ENS")

telechargerFichier("RP_LOGEMENT", date = "2016")
} # }
```
