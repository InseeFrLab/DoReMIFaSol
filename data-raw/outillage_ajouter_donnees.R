# Moulinette d'ajout d'un fichier zip pour en extraire les info essentielles
# pour renseigner liste_donnees.json
url <- "https://www.insee.fr/fr/statistiques/fichier/7671844/table-appartenance-geo-communes-2025.zip"

# Téléchargement du fichier -----------------------------------------------
extdir <- tempdir()
nom_zip <- "telechargement.zip"
path_zip <- file.path(extdir, nom_zip)
  
utils::download.file(url = url,
                     destfile = path_zip,
                     mode="wb")

message("size")
message(file.info(path_zip)$size)
message("md5")
message(tools::md5sum(path_zip))

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

