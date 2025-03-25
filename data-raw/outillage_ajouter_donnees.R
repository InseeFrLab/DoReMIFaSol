# Moulinette d'aide à l'ajout de fichiers dans liste_donnees.json
url <- "https://www.insee.fr/fr/statistiques/fichier/4803954/AAV2020_au_01-01-2025.zip"

# Téléchargement du fichier, taille et md5 ---------------------------------
extdir <- tempdir()
nom_zip <- "telechargement.zip"
path_zip <- file.path(extdir, nom_zip)
  
utils::download.file(url = url,
                     destfile = path_zip,
                     mode="wb")

# Ouverture/découverte du contenu du zip -----------------------------------
utils::unzip(zipfile = path_zip,
               exdir=extdir)

liste_fichiers <- utils::unzip(
  zipfile = path_zip,
  list = TRUE
  )

utils::unzip(
  zipfile = path_zip,
  exdir = extdir
)

for(fichier in liste_fichiers){
  message("Fichier")
  message(fichier)
  utils::browseURL(file.path(extdir, fichier))
}

message("url: ", url)
message("size: ", file.info(path_zip)$size)
message("md5: ", tools::md5sum(path_zip))

# Compléter ensuite liste_donnees.json
# lancer liste_donnees.R
# Lancer pkgdown::build_site() permet de vérifier que tout est OK via l'onglet Données dispo
