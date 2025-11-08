# Table des données disponibles au téléchargement

Cette table est centrale au package ; elle recense l'ensemble des
données disponibles et les liens associés permettant le téléchargement,
ainsi que des éléments descriptifs de celles-ci.

## Usage

``` r
liste_donnees
```

## Format

Un data.frame de 19 variables

- nom:

  l'identifiant des données

- libelle:

  le descriptif des données

- date_ref:

  éventuellement, la date de référence des données

- collection:

  la thématique ou la source

- lien:

  l'URL pour le téléchargement des données

- type:

  le format des données

- zip:

  les données sont-elles zippées ou non ? (booléen)

- big_zip:

  pour repérer les fichiers zippés dont la taille dépasse 4 Go et qui
  doivent alors faire l'objet d'une procédure particulière au moment de
  la décompression (booléen)

- fichier_donnees:

  le nom du fichier de données, dans le zip éventuel

- fichier_meta:

  le nom du fichier descriptif des données, dans le zip éventuel

- onglet:

  nom de l'onglet, si fichier tableur

- premiere_ligne:

  première ligne à lire pour charger dans R, si fichier tableur

- dernire_ligne:

  dernière ligne à lire pour charger dans R, si fichier tableur

- separateur:

  séparateur de colonnes, si fichier texte

- encoding:

  encodage du fichier

- valeurs_manquantes:

  valeurs à remplacer par `NA` lors de l'import dans R

- api_rest:

  nécessité de passer par une API REST (booléen)

- md5:

  somme de contrôle du fichier à télécharger (32 caractères
  hexadécimaux). Sert à vérifier si un téléchargement doit être effectué
  dans le cas où un fichier au nom identique est présent dans le
  dossier.

- size:

  taille du fichier à télécharger (en octets)
