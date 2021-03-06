% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/powermean.R
\name{powermean}
\alias{powermean}
\alias{show,powermean-method}
\title{Calculate power mean}
\usage{
powermean(results, meta, tag)

\S4method{show}{powermean}(object)
}
\arguments{
\item{results}{\code{data.frame} containing rdiversity outputs associated
with \code{norm_alpha()}, \code{raw_alpha()}, \code{raw_rho()},
\code{norm_rho()}, and/or \code{raw_gamma()}}

\item{meta}{object of class \code{metacommunity} containing the proportional
abundance of types, pair-wise similarity, and other associated variables}

\item{tag}{object of class \code{character} naming the diversity measure
being calculated}

\item{object}{object of class \code{powermean}}
}
\value{
\code{powermean(x)} returns an object of class \code{powermean}.

\code{print(x)} prints an object object of class \code{powermean}
}
\description{
Functions to coerce an object into a \code{powermean} (\code{raw_alpha()},
\code{norm_alpha()}, \code{raw_rho()}, \code{norm_rho()}, and/or
\code{raw_gamma()}).
}
\section{Fields}{

\describe{
\item{\code{results}}{\code{data.frame} containing rdiversity outputs associated
with \code{norm_alpha()}, \code{raw_alpha()}, \code{raw_rho()},
\code{norm_rho()}, and/or \code{raw_gamma()}}

\item{\code{measure}}{object of class \code{character} naming the diversity
measure being calculated}

\item{\code{type_abundance}}{two-dimensional \code{matrix} of mode \code{numeric}
with rows as types (species), columns as subcommunities, and each
element containing the relative abundance of types in each subcommunity
relative to the metacommunity as a whole. In the phylogenetic case, this
corresponds to the proportional abundance of historical species, which is
calculated from the proportional abundance of terminal taxa}

\item{\code{ordinariness}}{two-dimensional \code{matrix} of mode \code{numeric}
with rows as types, columns as subcommunities, and elements containing the
ordinariness of types within subcommunities}

\item{\code{subcommunity_weights}}{\code{vector} of mode \code{numeric} containing
subcommunity weights}

\item{\code{type_weights}}{two-dimensional \code{matrix} of mode \code{numeric},
with rows as types, columns as subcommunities, and elements containing
weights of types within a subcommunity}

\item{\code{dat_id}}{object of class \code{character} describing the class of
distance / similarity being used, e.g. "naive", "taxonomic", and so on}

\item{\code{similarity_components}}{list containing the components necessary to
calculate similarity. This list is empty when \code{precompute_dist = TRUE}
when calculating distance. When a pairwise distance matrix is too large and
\code{precompute_dist = FALSE}, this list contains all the information
required to calculate pairwise distance between types}

\item{\code{similarity_parameters}}{list containing parameters associated with
converting pairwise distances to similarities (the \code{dist2sim()}
arguments)}
}}

\examples{
pop <- data.frame(a = c(1,3), b = c(1,1))
row.names(pop) <- paste0("sp", 1:2)
pop <- pop/sum(pop)
meta <- metacommunity(pop)

# Calculate subcommunity raw alpha diversity (takes the powermean)
a <- raw_alpha(meta)
class(a)

}
