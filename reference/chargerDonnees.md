# Charger les données téléchargées dans R

Charger les données téléchargées dans R

## Usage

``` r
chargerDonnees(telechargementFichier, vars = NULL, ...)
```

## Arguments

- telechargementFichier:

  une liste contenant l'ensemble des informations nécessaires au
  chargement des données, créée en sortie de la fonction
  [`telechargerFichier`](https://InseeFrLab.github.io/DoReMIFaSol/reference/telechargerFichier.md).

- vars:

  un vecteur de variables à importer, afin d'utiliser les ressources
  computationnelles avec parcimonie. Par défaut NULL, ce qui signifie
  que l'ensemble des variables disponibles sont chargées.

- ...:

  des paramètres additionnels pour l'importation des données

## Value

un objet data.frame contenant les données téléchargées (sauf dans le cas
des données téléchargées depuis les API, pour lesquelles ce sont
généralement des listes contenant les différents objets data.fame).

## Details

Les données mises à disposition sont en général des tables de taille
raisonnable, qui peuvent être chargées sans problème en mémoire sur un
large spectre de machines. Néanmoins, pour certaines données (telles
celles du Recensement de Population ou encore SIRENE), les données sont
très volumineuses et exigent donc des machines très performantes.
L'utilisateur a donc la possibilité de choisir les variables qui
l'intéressent et de ne charger que ces dernières en mémoire, de manière
à être parcimonieux.

## Examples

``` r
if (FALSE) { # \dontrun{
dl_bpe <- telechargerFichier(donnees = "BPE_ENS")
bpe <- chargerDonnees(dl_bpe)} # }
```
