% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/consulter.R
\name{consulter}
\alias{consulter}
\title{Consulter le descriptif des données sur insee.fr}
\usage{
consulter(donnees, date = NULL, url_only = FALSE)
}
\arguments{
\item{donnees}{le nom des données dont on veut consulter la page sur le site de l'Insee. La description complète des données associées à ce nom figure dans la table (\link{liste_donnees}).}

\item{date}{optionnel : le millésime des données si nécessaire. Peut prendre le format YYYY ou encore DD/MM/YYYY ; dans le dernier cas, on prendra le premier jour de la période de référence. Spécifier \code{"dernier"} sélectionne automatiquement le millésime le plus récent.}

\item{url_only}{\code{TRUE} pour seulement récupérer l'URL de la page sans ouvrir le navigateur.}
}
\value{
Par défaut, la fonction ouvre le lien dans le navigateur. Elle retourne accessoirement le lien vers la page web, de manière invisible.
}
\description{
Consulter le descriptif des données sur insee.fr
}
\examples{
consulter(donnees = "BPE_ENS")
consulter("RP_LOGEMENT", date = "2016")
# Pour seulement obtenir l'URL de la page
consulter("RP_LOGEMENT", date = "2016", url_only = TRUE)
}
