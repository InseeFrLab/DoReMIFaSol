liste_donnees <- read.csv("data-raw/liste_donnees.csv", header = TRUE, sep = ",", colClasses = c("character", "character", "character", "character", "character",
                                                                                                 "character", "logical", "logical", "character", "character",
                                                                                                 "character", "integer", "integer", "character", 
                                                                                                 "character", "character", "logical", "character", "integer"),
                          encoding = "UTF-8", fileEncoding = "UTF-8", na.strings = c("", " "))
liste_donnees <- within(liste_donnees, {
  #separateur <- gsub("\"", "", separateur)
  separateur <- ifelse(is.na(separateur), NA, paste0("quote(", separateur, ")"))
  date_ref <- as.Date(date_ref, format = "%d/%m/%Y")})
usethis::use_data(liste_donnees, overwrite = TRUE)

liste_var_ld <- names(liste_donnees)

## internal
#ld <- liste_donnees
#usethis::use_data(ld, internal = TRUE, overwrite = TRUE)

## json
write(jsonlite::toJSON(liste_donnees, pretty = TRUE), file = "data-raw/liste_donnees.json")

## internal
ld <- jsonlite::read_json("data-raw/liste_donnees.json")
ld <- lapply(ld, function(x) {
  within(x, {
    if (!is.null(x$date_ref))
      date_ref <- as.Date(date_ref, format = "%Y-%m-%d")
  })
})
## enrichissement du json
## au 2010
meta <- readxl::read_excel("data-raw/meta/AU2010 au 01-01-2020.xlsx", sheet = "Variables", skip = 5)
labels <- as.list(meta$VAR_LIB_LONG)
names(labels) <- meta$VAR_ID
ld[[which(with(liste_donnees, nom == "AIRE_URBAINE"))]]$label_col <- labels
ld[[which(with(liste_donnees, nom == "AIRE_URBAINE_COM"))]]$label_col <- labels
## bpe ensemble
meta <- readr::read_delim("data-raw/meta/varmod_bpe19_ensemble.csv", delim = ";")
var <- unique(meta[, c("COD_VAR", "LIB_VAR", "TYPE_VAR", "LONG_VAR")])
labels <- as.list(var$LIB_VAR)
names(labels) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "BPE_ENS"))]]$label_col <- labels
types <- as.list(ifelse(var$TYPE_VAR == "CHAR", "character",
                        ifelse(var$TYPE_VAR == "NUM", "number", "guess")))
names(types) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "BPE_ENS"))]]$type_col <- types
long <- as.list(var$LONG_VAR)
names(long) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "BPE_ENS"))]]$long_col <- long
values <- dplyr::filter(meta, !COD_VAR %in% c("DEPCOM", "DCIRIS", "REG", "DEP") & TYPE_VAR == "CHAR")
val <- with(values, lapply(unique(COD_VAR), function(x) {
  res <- as.list(LIB_MOD[COD_VAR == x])
  names(res) <- COD_MOD[COD_VAR == x]
  return(res)
}))
names(val) <- unique(values$COD_VAR)
ld[[which(with(liste_donnees, nom == "BPE_ENS"))]]$val_col <- val
## bpe xy
meta <- readr::read_delim("data-raw/meta/varmod_bpe19_ensemble_xy.csv", delim = ";")
var <- unique(meta[, c("COD_VAR", "LIB_VAR", "TYPE_VAR", "LONG_VAR")])
labels <- as.list(var$LIB_VAR)
names(labels) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "BPE_ENS_XY"))]]$label_col <- labels
ld[[which(with(liste_donnees, nom == "BPE_ENS_XY"))]]$type_col <- list(REG = "character",
                                                                       DEP = "character",
                                                                       DEPCOM = "character",
                                                                       DCIRIS = "character",
                                                                       AN = "integer",
                                                                       TYPEQU = "character",
                                                                       LAMBERT_X = "double",
                                                                       LAMBERT_Y = "double",
                                                                       QUALITE_XY = "character")
long <- as.list(var$LONG_VAR)
names(long) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "BPE_ENS_XY"))]]$long_col <- long
values <- dplyr::filter(meta, COD_VAR == "TYPEQU")
val <- with(values, lapply(unique(COD_VAR), function(x) {
  res <- as.list(LIB_MOD[COD_VAR == x])
  names(res) <- COD_MOD[COD_VAR == x]
  return(res)
}))
names(val) <- unique(values$COD_VAR)
ld[[which(with(liste_donnees, nom == "BPE_ENS_XY"))]]$val_col <- val
## typage des variables dans le COG
ld[[which(with(liste_donnees, nom == "COG_COMMUNE" & date_ref == as.Date("2018-01-01")))]]$type_col <- list(CDC = "integer",
                                                                                                            CHEFLIEU = "integer",
                                                                                                            REG = "character",
                                                                                                            DEP = "character",
                                                                                                            COM = "character",
                                                                                                            AR = "integer",
                                                                                                            CT = "character",
                                                                                                            TNCC = "integer",
                                                                                                            ARTMAJ = "character",
                                                                                                            NCC = "character",
                                                                                                            ARTMIN = "character",
                                                                                                            NCCENR = "character")
ld[[which(with(liste_donnees, nom == "COG_COMMUNE" & date_ref == as.Date("2019-01-01")))]]$type_col <- list(typecom = "character",
                                                                                                            com = "character",
                                                                                                            reg = "character",
                                                                                                            dep = "character",
                                                                                                            arr = "character",
                                                                                                            tncc = "integer",
                                                                                                            ncc = "character",
                                                                                                            nccenr = "character",
                                                                                                            libelle = "character",
                                                                                                            can = "character",
                                                                                                            comparent = "character")
ld[[which(with(liste_donnees, nom == "COG_COMMUNE" & date_ref == as.Date("2020-01-01")))]]$type_col <- list(typecom = "character",
                                                                                                            com = "character",
                                                                                                            reg = "character",
                                                                                                            dep = "character",
                                                                                                            arr = "character",
                                                                                                            tncc = "integer",
                                                                                                            ncc = "character",
                                                                                                            nccenr = "character",
                                                                                                            libelle = "character",
                                                                                                            can = "character",
                                                                                                            comparent = "character")
ld[[which(with(liste_donnees, nom == "COG_COMMUNE" & date_ref == as.Date("2021-01-01")))]]$type_col <- list(TYPECOM = "character",
                                                                                                            COM = "character",
                                                                                                            REG = "character",
                                                                                                            DEP = "character",
                                                                                                            ARR = "character",
                                                                                                            TNCC = "integer",
                                                                                                            NCC = "character",
                                                                                                            NCCENR = "character",
                                                                                                            LIBELLE = "character",
                                                                                                            CAN = "character",
                                                                                                            COMPARENT = "character")
ld[[which(with(liste_donnees, nom == "COG_COMMUNE" & date_ref == as.Date("2022-01-01")))]]$type_col <- list(TYPECOM = "character",
                                                                                                            COM = "character",
                                                                                                            REG = "character",
                                                                                                            DEP = "character",
                                                                                                            ARR = "character",
                                                                                                            TNCC = "integer",
                                                                                                            NCC = "character",
                                                                                                            NCCENR = "character",
                                                                                                            LIBELLE = "character",
                                                                                                            CAN = "character",
                                                                                                            COMPARENT = "character")
## ajout labels des variables de Filosofi

## ajout du type de variables dans le RP
## 2016
## logement
meta <- readr::read_delim("data-raw/meta/varmod_LOGEMT_2016.csv", delim = ";")
var <- unique(meta[, c("COD_VAR", "LIB_VAR", "TYPE_VAR", "LONG_VAR")])
labels <- as.list(var$LIB_VAR)
names(labels) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_LOGEMENT" & date_ref == as.Date("2016-01-01")))]]$label_col <- labels
types <- as.list(ifelse(var$TYPE_VAR == "CHAR", "character",
                        ifelse(var$TYPE_VAR == "NUM", "number", "guess")))
names(types) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_LOGEMENT" & date_ref == as.Date("2016-01-01")))]]$type_col <- types
long <- as.list(var$LONG_VAR)
names(long) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_LOGEMENT" & date_ref == as.Date("2016-01-01")))]]$long_col <- long
values <- dplyr::filter(meta, !COD_VAR %in% c("COMMUNE", "ARM", "TRIRIS", "IRIS") & TYPE_VAR == "CHAR")
val <- with(values, lapply(unique(COD_VAR), function(x) {
  res <- as.list(LIB_MOD[COD_VAR == x])
  names(res) <- COD_MOD[COD_VAR == x]
  return(res)
}))
names(val) <- unique(values$COD_VAR)
ld[[which(with(liste_donnees, nom == "RP_LOGEMENT" & date_ref == as.Date("2016-01-01")))]]$val_col <- val
## indcvi
meta <- readr::read_delim("data-raw/meta/varmod_INDCVI_2016.csv", delim = ";")
var <- meta[!duplicated(meta$COD_VAR), c("COD_VAR", "LIB_VAR", "TYPE_VAR", "LONG_VAR")]
labels <- as.list(var$LIB_VAR)
names(labels) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_INDCVI" & date_ref == as.Date("2016-01-01")))]]$label_col <- labels
types <- as.list(ifelse(var$TYPE_VAR == "CHAR", "character",
                        ifelse(var$TYPE_VAR == "NUM", "number", "guess")))
names(types) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_INDCVI" & date_ref == as.Date("2016-01-01")))]]$type_col <- types
long <- as.list(var$LONG_VAR)
names(long) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_INDCVI" & date_ref == as.Date("2016-01-01")))]]$long_col <- long
values <- dplyr::filter(meta, !COD_VAR %in% c("CANTVILLE", "ARM", "DEPT", "DNAI", "IRIS", "TRIRIS") & TYPE_VAR == "CHAR")
val <- with(values, lapply(unique(COD_VAR), function(x) {
  res <- as.list(LIB_MOD[COD_VAR == x])
  names(res) <- COD_MOD[COD_VAR == x]
  return(res)
}))
names(val) <- unique(values$COD_VAR)
ld[[which(with(liste_donnees, nom == "RP_INDCVI" & date_ref == as.Date("2016-01-01")))]]$val_col <- val
## mobsco
meta <- readr::read_delim("data-raw/meta/Varmod_MOBSCO_2016.csv", delim = ";")
var <- unique(meta[, c("COD_VAR", "LIB_VAR", "TYPE_VAR", "LONG_VAR")])
labels <- as.list(var$LIB_VAR)
names(labels) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_MOBSCO" & date_ref == as.Date("2016-01-01")))]]$label_col <- labels
types <- as.list(ifelse(var$TYPE_VAR == "CHAR", "character",
                        ifelse(var$TYPE_VAR == "NUM", "number", "guess")))
names(types) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_MOBSCO" & date_ref == as.Date("2016-01-01")))]]$type_col <- types
long <- as.list(var$LONG_VAR)
names(long) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_MOBSCO" & date_ref == as.Date("2016-01-01")))]]$long_col <- long
values <- dplyr::filter(meta, !COD_VAR %in% c("COMMUNE", "ARM", "DCETUE", "DCETUF", "REGION", "REGETUD") & TYPE_VAR == "CHAR")
val <- with(values, lapply(unique(COD_VAR), function(x) {
  res <- as.list(LIB_MOD[COD_VAR == x])
  names(res) <- COD_MOD[COD_VAR == x]
  return(res)
}))
names(val) <- unique(values$COD_VAR)
ld[[which(with(liste_donnees, nom == "RP_MOBSCO" & date_ref == as.Date("2016-01-01")))]]$val_col <- val
## indreg
meta <- readr::read_delim("data-raw/meta/Varmod_INDREG_2016.csv", delim = ";")
var <- unique(meta[, c("COD_VAR", "LIB_VAR", "TYPE_VAR", "LONG_VAR")])
labels <- as.list(var$LIB_VAR)
names(labels) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_INDREG" & date_ref == as.Date("2016-01-01")))]]$label_col <- labels
types <- as.list(ifelse(var$TYPE_VAR == "CHAR", "character",
                        ifelse(var$TYPE_VAR == "NUM", "number", "guess")))
names(types) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_INDREG" & date_ref == as.Date("2016-01-01")))]]$type_col <- types
long <- as.list(var$LONG_VAR)
names(long) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_INDREG" & date_ref == as.Date("2016-01-01")))]]$long_col <- long
values <- dplyr::filter(meta, !COD_VAR %in% c("DEPT", "REGION") & TYPE_VAR == "CHAR")
val <- with(values, lapply(unique(COD_VAR), function(x) {
  res <- as.list(LIB_MOD[COD_VAR == x])
  names(res) <- COD_MOD[COD_VAR == x]
  return(res)
}))
names(val) <- unique(values$COD_VAR)
ld[[which(with(liste_donnees, nom == "RP_INDREG" & date_ref == as.Date("2016-01-01")))]]$val_col <- val
## mobpro
meta <- readr::read_delim("data-raw/meta/Varmod_MOBPRO_2016.csv", delim = ";")
var <- unique(meta[, c("COD_VAR", "LIB_VAR", "TYPE_VAR", "LONG_VAR")])
labels <- as.list(var$LIB_VAR)
names(labels) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_MOBPRO" & date_ref == as.Date("2016-01-01")))]]$label_col <- labels
types <- as.list(ifelse(var$TYPE_VAR == "CHAR", "character",
                        ifelse(var$TYPE_VAR == "NUM", "number", "guess")))
names(types) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_MOBPRO" & date_ref == as.Date("2016-01-01")))]]$type_col <- types
long <- as.list(var$LONG_VAR)
names(long) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_MOBPRO" & date_ref == as.Date("2016-01-01")))]]$long_col <- long
values <- dplyr::filter(meta, !COD_VAR %in% c("COMMUNE", "ARM", "REGION", "DCFLT", "DCLT", "REGLT") & TYPE_VAR == "CHAR")
val <- with(values, lapply(unique(COD_VAR), function(x) {
  res <- as.list(LIB_MOD[COD_VAR == x])
  names(res) <- COD_MOD[COD_VAR == x]
  return(res)
}))
names(val) <- unique(values$COD_VAR)
ld[[which(with(liste_donnees, nom == "RP_MOBPRO" & date_ref == as.Date("2016-01-01")))]]$val_col <- val
## mobzelt
meta <- readr::read_delim("data-raw/meta/Varmod_MOBZELT_2016.csv", delim = ";")
var <- unique(meta[, c("COD_VAR", "LIB_VAR", "TYPE_VAR", "LONG_VAR")])
labels <- as.list(var$LIB_VAR)
names(labels) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_MOBZELT" & date_ref == as.Date("2016-01-01")))]]$label_col <- labels
types <- as.list(ifelse(var$TYPE_VAR == "CHAR", "character",
                        ifelse(var$TYPE_VAR == "NUM", "number", "guess")))
names(types) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_MOBZELT" & date_ref == as.Date("2016-01-01")))]]$type_col <- types
long <- as.list(var$LONG_VAR)
names(long) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_MOBZELT" & date_ref == as.Date("2016-01-01")))]]$long_col <- long
values <- dplyr::filter(meta, !COD_VAR %in% c("COMMUNE", "ARM", "REGION", "DCFLT", "DCLT", "REGLT") & TYPE_VAR == "CHAR")
val <- with(values, lapply(unique(COD_VAR), function(x) {
  res <- as.list(LIB_MOD[COD_VAR == x])
  names(res) <- COD_MOD[COD_VAR == x]
  return(res)
}))
names(val) <- unique(values$COD_VAR)
ld[[which(with(liste_donnees, nom == "RP_MOBZELT" & date_ref == as.Date("2016-01-01")))]]$val_col <- val
## migcom
meta <- readr::read_delim("data-raw/meta/Varmod_MIGCOM_2016.csv", delim = ";")
var <- unique(meta[, c("COD_VAR", "LIB_VAR", "TYPE_VAR", "LONG_VAR")])
labels <- as.list(var$LIB_VAR)
names(labels) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_MIGCOM" & date_ref == as.Date("2016-01-01")))]]$label_col <- labels
types <- as.list(ifelse(var$TYPE_VAR == "CHAR", "character",
                        ifelse(var$TYPE_VAR == "NUM", "number", "guess")))
names(types) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_MIGCOM" & date_ref == as.Date("2016-01-01")))]]$type_col <- types
long <- as.list(var$LONG_VAR)
names(long) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_MIGCOM" & date_ref == as.Date("2016-01-01")))]]$long_col <- long
values <- dplyr::filter(meta, !COD_VAR %in% c("COMMUNE", "ARM", "REGION", "DCRAN", "DNAI", "REGLT") & TYPE_VAR == "CHAR")
val <- with(values, lapply(unique(COD_VAR), function(x) {
  res <- as.list(LIB_MOD[COD_VAR == x])
  names(res) <- COD_MOD[COD_VAR == x]
  return(res)
}))
names(val) <- unique(values$COD_VAR)
ld[[which(with(liste_donnees, nom == "RP_MIGCOM" & date_ref == as.Date("2016-01-01")))]]$val_col <- val
## migdep
meta <- readr::read_delim("data-raw/meta/Varmod_MIGDEP_2016.csv", delim = ";")
var <- unique(meta[, c("COD_VAR", "LIB_VAR", "TYPE_VAR", "LONG_VAR")])
labels <- as.list(var$LIB_VAR)
names(labels) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_MIGDEP" & date_ref == as.Date("2016-01-01")))]]$label_col <- labels
types <- as.list(ifelse(var$TYPE_VAR == "CHAR", "character",
                        ifelse(var$TYPE_VAR == "NUM", "number", "guess")))
names(types) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_MIGDEP" & date_ref == as.Date("2016-01-01")))]]$type_col <- types
long <- as.list(var$LONG_VAR)
names(long) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_MIGDEP" & date_ref == as.Date("2016-01-01")))]]$long_col <- long
values <- dplyr::filter(meta, !COD_VAR %in% c("DEPT", "DNAI") & TYPE_VAR == "CHAR")
val <- with(values, lapply(unique(COD_VAR), function(x) {
  res <- as.list(LIB_MOD[COD_VAR == x])
  names(res) <- COD_MOD[COD_VAR == x]
  return(res)
}))
names(val) <- unique(values$COD_VAR)
ld[[which(with(liste_donnees, nom == "RP_MIGDEP" & date_ref == as.Date("2016-01-01")))]]$val_col <- val
## miggco
meta <- readr::read_delim("data-raw/meta/Varmod_MIGGCO_2016.csv", delim = ";")
var <- unique(meta[, c("COD_VAR", "LIB_VAR", "TYPE_VAR", "LONG_VAR")])
labels <- as.list(var$LIB_VAR)
names(labels) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_MIGGCO" & date_ref == as.Date("2016-01-01")))]]$label_col <- labels
types <- as.list(ifelse(var$TYPE_VAR == "CHAR", "character",
                        ifelse(var$TYPE_VAR == "NUM", "number", "guess")))
names(types) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_MIGGCO" & date_ref == as.Date("2016-01-01")))]]$type_col <- types
long <- as.list(var$LONG_VAR)
names(long) <- var$COD_VAR
ld[[which(with(liste_donnees, nom == "RP_MIGGCO" & date_ref == as.Date("2016-01-01")))]]$long_col <- long
values <- dplyr::filter(meta, !COD_VAR %in% c("COMMUNE", "ARM", "DNAI", "DRAN") & TYPE_VAR == "CHAR")
val <- with(values, lapply(unique(COD_VAR), function(x) {
  res <- as.list(LIB_MOD[COD_VAR == x])
  names(res) <- COD_MOD[COD_VAR == x]
  return(res)
}))
names(val) <- unique(values$COD_VAR)
ld[[which(with(liste_donnees, nom == "RP_MIGGCO" & date_ref == as.Date("2016-01-01")))]]$val_col <- val


usethis::use_data(ld, liste_var_ld, internal = TRUE, overwrite = TRUE)
ld <- lapply(ld, function(x) {
  if (!is.null(x$separateur))
      x$separateur <- sub("quote\\(\"(.*)\"\\)", "\\1", x$separateur)
  return(x)
})
write(jsonify::pretty_json(jsonify::to_json(ld, unbox = TRUE, numeric_dates = FALSE)), file = "data-raw/liste_donnees.json")
