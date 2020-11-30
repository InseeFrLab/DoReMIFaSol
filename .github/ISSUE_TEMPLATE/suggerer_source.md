---
name: Proposer une nouvelle source de données
about: Proposer l'ajout d'une nouvelle source afin que les administrateurs l'intègrent au package
---

Vous souhaitez proposer une une nouvelle source et ses caractéristiques, afin que les administrateurs l'intègrent au package ?

Inclure a minima l'url sur insee.fr à partir de laquelle on peut télécharger le fichier correspondant.

> Par exemple : https://www.insee.fr/fr/statistiques/2115011

**Autres informations**

Les informations suivantes étant également nécessaires, compléter la liste suivante faciletera la tâche des administrateurs du package (remplacer les valeurs exemples par les valeurs de la nouvelle source).

```json
"date_ref": "2019-01-01",
"lien": "https://www.insee.fr/fr/statistiques/fichier/3568638/bpe19_ensemble_xy_csv.zip",
"zip": true,
"type": "csv",
"fichier_donnees": "bpe19_ensemble_xy.csv",
"fichier_meta": "varmod_bpe19_ensemble_xy.csv"
```

Signification des champs :

- `date_ref` : la date (éventuelle) de référence des données
- `lien` : l'URL pour le téléchargement des données
- `zip` : les données sont-elles zippées ou non (`true` ou `false`)
- `type` : le format des données (csv, xls, xlsx), à l'intérieur de l'archive si `"zip": true`
- `fichier_donnees` : le nom du fichier de données, dans un éventuel zip
- `fichier_meta` : le nom du fichier descriptif des données, dans un éventuel zip
