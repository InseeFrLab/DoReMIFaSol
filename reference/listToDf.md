# Transforme une liste (typiquement `ld`) en data.frame

Objectif : ne pas créer une dépendance à `dplyr` et la fonction
`bind_rows`, bien que du point de vue computationel, la fonction créée
ici soit bien moins performante.

## Usage

``` r
listToDf(liste, vars = NULL)
```

## Arguments

- liste:

  un objet list à convertir en data.frame

- vars:

  optionnel, un vecteur de variables à récupérer

## Value

Une data.frame
