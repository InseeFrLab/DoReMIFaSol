# Liens de succession d'une liste d'établissements

Télécharge sur l'API Sirene l'ensemble des successeurs d'une liste
d'établissements.

## Usage

``` r
sirets_successeurs(sirets, ...)
```

## Arguments

- sirets:

  établissements pour lesquels rechercher les successeurs (un vecteur
  caractère de numéros SIRET).

- ...:

  paramètres additionnels de la fonction `telechargerDonnees`

## Value

Un data.frame agrégeant les résultats pour chaque siret (vide si aucun
des établissements n'a de successeur).

## Details

Cette fonction appelle
[`telechargerDonnees`](https://InseeFrLab.github.io/DoReMIFaSol/reference/telechargerDonnees.md)
pour chacun des établissements passés en paramètre (de manière
optimisée).

Les données téléchargées au format "json" sont enregistrées dans un
dossier temporaire.

## Authentification API Sirene

Comme toutes les fonctions reposant sur l'[API](https://api.insee.fr)
Sirene, cette fonction nécessite une clé d'application et un secret
associé pour pouvoir générer un jeton d'accès. Ces informations sont à
passer sous forme de variables d'environnement.

Renseigner pour cela `INSEE_API_TOKEN` dans un fichier de configuration
`.Renviron`. Consulter [cette
page](https://github.com/InseeFrLab/DoReMIFaSol/tree/new-api#requ%C3%AAter-une-api-rest--le-r%C3%A9pertoire-dentreprises-sirene)
pour de l'aide sur comment obtenir de tels identifiants.

## Examples

``` r
if (FALSE) { # \dontrun{

sirets_successeurs(c("30070230500040", "30137492200120", "30082187300019"))
} # }
```
