# Guide du contributeur

## Ajout d'une source de données

Le référentiel des sources disponibles ne se met pas à jour automatiquement. Pour ajouter une nouvelle source, il faut :

-   modifier le fichier `data-raw/liste_donnees.json` avec :

    -   "nom" : l'identifiant des données

    -   "libelle" : le descriptif des données

    -   "date_ref" : éventuellement, la date de référence des données

    -   "collection" : la thématique ou la source

    -   "lien" : l'URL pour le téléchargement des données

    -   "type" : le format des données

    -   "zip" : les données sont-elles zippées ou non ? (booléen)

    -   "big_zip" : pour repérer les fichiers zippés dont la taille dépasse 4 Go et qui doivent alors faire l'objet d'une procédure particulière au moment de la décompression (booléen)

    -   "fichier_donnees" : le nom du fichier de données, dans le zip éventuel

    -   "fichier_meta" : le nom du fichier descriptif des données, dans le zip éventuel

    -   "onglet" : nom de l'onglet, si fichier tableur

    -   "premiere_ligne" : première ligne à lire pour charger dans R, si fichier tableur

    -   "derniere_ligne : dernière ligne à lire pour charger dans R, si fichier tableur

    -   "separateur" : séparateur de colonnes, si fichier texte

    -   "encoding" : encodage du fichier

    -   "valeurs_manquantes" : valeurs à remplacer par \`NA\` lors de l'import dans R

    -   "api_rest" : nécessité de passer par une API REST (booléen)

    -   "md5" : somme de contrôle du fichier à télécharger (32 caractères hexadécimaux). Sert à vérifier si un téléchargement doit être effectué dans le cas où un fichier au nom identique est présent dans le dossier.

    -   "size" : taille du fichier à télécharger (en octets)

-   exécuter le programme `data-raw/liste_donnees.R` pour générer les objets R associés.

-   modifier le nombre de lignes et de colonnes à la ligne 5 du fichier `R/liste_donnees.R`

Pour qu'un administrateur du package intègre lui-même la source ou en cas de doute sur la pertinence de l'ajout, il est aussi possible de la proposer via l'ouverture d'une [*issue*](https://github.com/InseeFrLab/DoReMIFaSol/issues/new/choose).
