# Récupérer et utiliser les données de l'Insee avec R / Get and use Insee's data with R

<img src="https://github.com/inseeFrLab/doremifasol/raw/master/inst/sticker/hex_logo_v2.png" width="150" height="150" align="right" alt="DoReMIFaSol logo" />

<!-- badges: start -->
[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![build-artifacts](https://github.com/InseeFrLab/DoReMIFaSol/actions/workflows/build-artifacts.yml/badge.svg)](https://github.com/InseeFrLab/DoReMIFaSol/actions/workflows/build-artifacts.yml)
[![R-CMD-check](https://github.com/InseeFrLab/DoReMIFaSol/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/InseeFrLab/DoReMIFaSol/actions/workflows/R-CMD-check.yaml)
[![License:MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Coverage status](https://codecov.io/gh/InseeFrLab/DoReMIFaSol/branch/master/graph/badge.svg?token=FM7HW4DSW5)](https://codecov.io/gh/InseeFrLab/DoReMIFaSol)
[![CRAN status](https://www.r-pkg.org/badges/version/doremifasol)](https://cran.r-project.org/package=doremifasol)
<!-- badges: end -->

## Français

### 🚀 Nouvelle fonctionnalité

Le catalogue de données intègre désormais les données mises à disposition dans [l'API Melodi](https://portail-api.insee.fr/catalog/all). Outre la [liste de données](https://raw.githubusercontent.com/InseeFrLab/DoReMIFaSol/refs/heads/master/data-raw/liste_donnees.json) disponible dans le _package_, les données listées dans le catalogue de Melodi sont intégrées _via_ [ce fichier](https://minio.lab.sspcloud.fr/pierrelamarche/melodi/liste_donnees.json) qui est mis quotidiennement à jour.

### De quoi s'agit-il ?

Le _package_ `doremifasol` (_Données en R Mises à disposition par l’Insee et Facilement Sollicitables_) permet d'importer facilement dans R des données mises à disposition sur le site de l'Insee.

Il offre deux fonctionnalités principales :

* télécharger et importer dans R des fichiers disponibles sur insee.fr (Base Permanente des Équipements, Recensement de Population, Filosofi...), **y compris les données mises à disposition _via_ Melodi** ;
* requêter l'[API](https://api.insee.fr/catalogue) Sirene et recupérer les résultats dans R.

L'objectif du _package_ est de rendre transparentes les différentes tâches à réaliser avant de pouvoir traiter les données : recherche sur le site, téléchargement, décompression, import dans R...

Idéal pour pratiquer son solfège en R sur des données françaises !

Pour installer le package :

```r
# install.packages("remotes")
remotes::install_github("InseeFrLab/doremifasol", build_vignettes = TRUE)
```

### Quelles données sont disponibles ?

Pour trouver quelles données le package peut aller récupérer sur le site de l'Insee, on peut commencer par explorer interactivement les [données disponibles](https://inseefrlab.github.io/DoReMIFaSol/articles/donnees_dispo.html).

Cela permet notamment de connaître les identifiants (noms courts) et millésimes qui seront à spécifier aux fonctions de téléchargement.

_Le package a vocation à intégrer de nouveaux jeux de données dès qu'ils sont mis en ligne. Ce processus n'est toutefois pas automatisé. Voir la section **<a href=#contribuer>Contribuer</a>** pour suggérer l'ajout de nouvelles données._

### Exemples d'usages

#### Les données du recensement de population

Le premier exemple concerne les données du recensement librement accessibles sur le site de l'Insee. Ce sont des données très volumineuses, et sauf à disposer de capacités de calcul conséquentes, il n'est en général pas possible de charger l'ensemble des données en mémoire. Pour cela, le _package_ `doremifasol` permet de sélectionner les colonnes que l'on souhaite charger en mémoire, une fois le fichier téléchargé. Ainsi, un utilisateur qui voudrait connaître par commune le nombre de résidences principales en 2016 aura besoin des variables `COMMUNE` - le code commune - et `CATL` - la catégorie d'occupation du logement - de la table `logement` :

```r
donnees_rp <- telechargerDonnees("RP_LOGEMENT", date = 2016, vars = c("COMMUNE", "IPONDL", "CATL"))
```

#### Filosofi

L'Insee met également à disposition un certain nombre d'indicateurs relatifs à la distribution des revenus et à la pauvreté au niveau communal, voire infra-communal. Ces données sont mises à jour chaque année à partir des sources fiscales ; il s'agit de la source "Filosofi". Ainsi, il est possible de télécharger ces indicateurs au niveau de la commune, pour l'ensemble des ménages par exemple, grâce à la syntaxe suivante :

```r
donnees_filosofi <- telechargerDonnees("FILOSOFI_DISP_COM_ENS", date = 2017)
```

Ces données sont déclinées pour différentes catégories de ménages, et de la même manière peuvent être téléchargées grâce au _package_ `doremifasol`.

#### Estimations localisées d'emploi en France

De la même manière que les données fiscales permettent de fournir des statistiques à un niveau géographique fin, d'autres sources administratives permettent de construire des estimations du nombre d'emplois présents dans les différentes communes du territoire français. Il s'agit des Estimations d'Emploi Localisées, qu'il est possible de récupérer en `R` grâce à la syntaxe suivante :

```r
donnees_estel <- telechargerDonnees("ESTEL_T201", date = 2018)
```

#### Requêter une API REST : le répertoire d'entreprises Sirene

Supposons que l'on cherche maintenant à récupérer l'ensemble des établissements rattachés à une unité légale créée le 1er janvier 2020 ; pour cela, on peut par exemple envoyer une requête sur l'API REST Sirene de l'Insee. Pour cela, il faut au préalable avoir configuré un accès à l'API REST de l'Insee et passer en variables d'environnement les données d'identification. La procédure est expliquée par exemple [ici](https://github.com/InseeFrLab/apinsee#exemple). Une fois cela réalisé, la requête peut se faire facilement au travers de `doremifasol` de la manière suivante :

```r
etablissements <- telechargerDonnees("SIRENE_SIRET", 
                                     argsApi = list(q = "dateCreationUniteLegale:2020-01-01"))
```

On fait alors face à une liste contenant plusieurs `data.frame` (6 au total) :
* une table contenant l'ensemble des informations sur les établissements en question ;
* deux tables contenant l'ensemble des informations sur les unités légales de ces établissements, en distinguant les unités dites purgées des autres ;
* deux tables contenant les informations sur l'adresse de ces établissements ;
* une table détaillant les informations historisées de ces établissements - c'est-à-dire les différentes modifications qu'ont connues les établissements entre leur création et la date de référence - ici par défaut la date de téléchargement.

### Contribuer

Agent du Service Statistique Public, ou utilisateur des données mises à disposition sur le site de l'Insee, vous constatez qu'il manque dans la [liste des données](https://inseefrlab.github.io/DoReMIFaSol/articles/donnees_dispo.html) référencées dans `doremifasol` une source de données que vous utilisez ? Vous pouvez contribuer à `doremifasol`, sans nécessairement coder en `R`. Pour plus de détais, vous pouvez consulter la [documentation à ce sujet](https://github.com/InseeFrLab/DoReMIFaSol/blob/master/CONTRIBUTING.md).


## English

### 🚀 New Feature

The data catalog now includes data made available in the [Melodi API](https://portail-api.insee.fr/catalog/all). In addition to the [list of data](https://raw.githubusercontent.com/InseeFrLab/DoReMIFaSol/refs/heads/master/data-raw/liste_donnees.json) available in the package, the data listed in the Melodi catalog is integrated via [this file](https://minio.lab.sspcloud.fr/pierrelamarche/melodi/liste_donnees.json) which is updated on a daily basis.

### What is it about?

`doremifasol` (data with R made available by Insee and easily retrievable in French) is a R package mainly aiming at showing off data available on Insee's website (Insee, for the French Institute for Statistics and Economic Studies), helping the user to put them on stage and extract the information they carry. So it is about analysing data, creating maps, quantifying phenomenons and in general using the data without the painful effort to retrieve them on the website, as well as import them into R's memory. The name of the _package_ stands for the five first notes of music, and pushing the metaphore, underlines its aim at helping the users to easily pratice their _solfège_ in R.

To install the package:

```r
# install.packages("remotes")
remotes::install_github("InseeFrLab/doremifasol", build_vignettes = TRUE)
```

### Which data is available?

You may begin by exploring interactively [which data](https://inseefrlab.github.io/DoReMIFaSol/articles/donnees_dispo.html) the package can fetch on Insee website with.

This is also a way to find out the identifiers (short names) and years to be passed as parameters to the downloading functions.

_New data sources can be added to the package as soon as they are available online. However, this process is not automated. See the **<a href=#contributing>Contributing</a>** section for suggesting package administrators to add new sources._

### A few examples

#### Census data

A first example of use of the package is related to the rolling Census implemented in France on a yearly basis. It concerns voluminous data that prove to be hard to load into R's memory on most of the machines. To adress the data size issue, the package `doremifasol` makes it possible to resize the data and only imports columns that are of interest for the user. Assume that one is interested in knowing the number of main residences for each municipality on the French territory in 2016, that one will only need three variables from the table `logement` (dwelling in French), `COMMUNE` the zip code, `IPONDL` the weight of the dwelling and `CATL` indicating the status of occupation:

```r
donnees_rp <- telechargerDonnees("RP_LOGEMENT", date = 2016, vars = c("COMMUNE", "IPONDL", "CATL"))
```

#### Data on income distribution and poverty

Should you now be interested in data on income distribution, you may download information on income percentiles and poverty rate at the municipality level based on tax data, also knwow as 'Filosofi'. Those data are update every year. You may fetch these data for year 2017 for instance thanks to the following command:

```r
donnees_filosofi <- telechargerDonnees("FILOSOFI_DISP_COM_ENS", date = 2017)
```

#### Data on employment

Tax data are very convenient to carry out information on income distribution at municipality level, so are data coming from registers on employment.

#### Requesting an API REST on the firms' register _Sirene_


### Contributing

As non French-speaking user of Insee's website, you are using data that turn out not to be listed [there](https://github.com/InseeFrLab/DoReMIFaSol/blob/master/data-raw/liste_donnees.csv) in the package `doremifasol`. You may notify the maintainer of this project and even more, could you code in `R` or not. Please report to the [dedicated documentation](https://github.com/InseeFrLab/DoReMIFaSol/blob/master/CONTRIBUTING.md).
