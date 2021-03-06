% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/taxvec.R
\name{taxvec}
\alias{taxvec}
\title{taxvec}
\usage{
taxvec(similarity, row)
}
\arguments{
\item{similarity}{An object of class \code{similarity} (not containing a
similarity matrix).}

\item{row}{\code{integer} denoting which row of the similarity matrix is to
be calculated.}
}
\description{
Calculate the taxonomic similarity of a single species to all other species.
Used by \code{metacommunity()} to generate a similarity matrix line-by-line
when one was not precalculated by \code{tax2dist()}.
}
\examples{
\dontrun{
# Create Lookup table
Species <- c("tenuifolium", "asterolepis", "simplex var.grandiflora", "simplex var.ochnacea")
Genus <- c("Protium", "Quararibea", "Swartzia", "Swartzia")
Family <- c("Burseraceae", "Bombacaceae", "Fabaceae", "Fabaceae")
Subclass <- c("Sapindales", "Malvales", "Fabales", "Fabales")
lookup <- cbind.data.frame(Species, Genus, Family, Subclass)

# Assign values for each level (Shimatani's taxonomic distance)
tax_distance <- c(Species = 0, Genus = 1, Family = 2, Subclass = 3, Other = 4)

dist <- tax2dist(lookup, tax_distance, precompute_dist = FALSE)
similarity <- dist2sim(dist, "linear")
taxvec(similarity, 1)
}

}
