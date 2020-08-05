# Récupérer et utiliser les données de l'Insee avec `R`/ Get and use Insee's data with `R`

<img src="https://github.com/pierre-lamarche/doremifasol/raw/master/inst/sticker/hex_logo_v2.png" width="150" height="150" align="right"/>

<!-- badges: start -->
[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Travis build status](https://travis-ci.com/pierre-lamarche/DoReMIFaSol.svg?branch=master)](https://travis-ci.com/pierre-lamarche/doremifasol)
[![License:MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Coverage Status](https://img.shields.io/codecov/c/github/pierre-lamarche/doremifasol/master)](https://codecov.io/gh/pierre-lamarche/DoReMIFaSol)
<!-- badges: end -->

## Français

### De quoi s'agit-il ?

`doremifasol` (Données en `R` Mises à disposition par l'Insee et Facilement Sollicitables) est un _package_ dont la vocation est d'agréger les données disponibles de l'Insee et d'en promouvoir l'utilité, en plaçant ces données sur le devant de la scène pour l'utilisateur, et de lui permettre d'en extraire facilement de l'information. Analyser, cartographier, dénombrer, sans payer le coût d'entrée pour trouver le bon lien ou importer les données en R. Idéal pour pratiquer son solfège en `R` sur données françaises.

Pour installer le package,

```r
devtools::install_github('pierre-lamarche/doremifasol')
```

### Exemples d'usages

#### Les données du recensement de population

Le premier exemple concerne les données du recensement librement accessibles sur le site de l'Insee. Ce sont des données très volumineuses, et sauf à disposer de capacités de calcul conséquentes, il n'est en général pas possible de charger l'ensemble des données en mémoire. Pour cela, le _package_ `doremifasol` permet de sélectionner les colonnes que l'on souhaite charger en mémoire, une fois le fichier téléchargé. Ainsi, un utilisateur qui voudrait connaître par commune le nombre de résidences principales aura besoin des variables `COMMUNE` - le code commune - et `CATL` - la catégorie d'occupation du logement - de la table `logement` :

```r
donnees_rp <- telechargerDonnees("RP_LOGEMENT", date = 2016, vars = c("COMMUNE", "IPONDL", "CATL"))
```

Il est alors possible de compter le nombre de résidences principales à partir de la table `donnees_rp` :

```r
comptage_rp <- with(donnees_rp, aggregate(as.numeric(CATL == '1')*IPONDL, list(COMMUNE), sum))
```

#### Filosofi

#### Estimations localisées d'emploi en France

#### Requêter une API REST : le répertoire d'entreprises Sirene

### Contribuer

Agent du Service Statistique Public, ou utilisateur des données mises à disposition sur le site de l'Insee, vous constatez qu'il manque dans la [liste des données](https://github.com/pierre-lamarche/DoReMIFaSol/blob/master/data-raw/liste_donnees.csv) référencées dans `doremifasol` une source de données que vous utilisez ? Vous pouvez contribuer à `doremifasol`, sans nécessairement coder en `R`. Pour plus de détais, vous pouvez consulter la [documentation à ce sujet](https://github.com/pierre-lamarche/DoReMIFaSol/blob/master/CONTRIBUTING.md).


## English

### What is it about?

`doremifasol` (data with `R` made available by Insee and easily retrievable in French) is a R package mainly aiming at showing off data available on Insee's website (Insee, for the French Institute for Statistics and Economic Studies), helping the user to put them on stage and extract the information they carry. So it is about analysing data, creating maps, quantifying phenomenons and in general using the data without the painful effort to retrieve them on the website, as well as import them into R's memory. The name of the _package_ stands for the five first notes of music, and pushing the metaphore, underlines its aim at helping the users to easily pratice their _solfège_ in `R`.

To install the package:

```r
devtools::install_github('pierre-lamarche/doremifasol')
```

### A few examples

#### Census data

#### Data on income distribution and poverty

#### Data on employment

#### Requesting an API REST on the firms' register _Sirene_


### Contributing

As non French-speaking user of Insee's website, you are using data that turn out not to be listed [there](https://github.com/pierre-lamarche/DoReMIFaSol/blob/master/data-raw/liste_donnees.csv) in the package `doremifasol`. You may notify the maintainer of this project and even more, could you code in `R` or not. Please report to the [dedicated documentation](https://github.com/pierre-lamarche/DoReMIFaSol/blob/master/CONTRIBUTING.md).
