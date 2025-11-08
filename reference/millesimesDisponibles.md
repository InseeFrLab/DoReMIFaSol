# Lister les différents millésimes pour une source donnée

Lister les différents millésimes pour une source donnée

## Usage

``` r
millesimesDisponibles(donnees)
```

## Arguments

- donnees:

  le nom court des données que l'on souhaite télécharger sur le site de
  l'Insee. La description complète des données associés à ce nom figure
  dans la table
  [`liste_donnees`](https://InseeFrLab.github.io/DoReMIFaSol/reference/liste_donnees.md).
  Insensible à la casse.

## Value

un vecteur contenant l'ensemble des millésimes disponibles pour une
source de données.

## Examples

``` r
millesimesDisponibles("RP_LOGEMENT")
#>  [1] "2010" "2011" "2012" "2013" "2014" "2015" "2016" "2017" "2018" "2019"
#> [11] "2020" "2021"
```
