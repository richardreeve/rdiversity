% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/diversity-measures.R
\name{raw_meta_alpha}
\alias{raw_meta_alpha}
\title{Raw metacommunity alpha diversity}
\usage{
raw_meta_alpha(meta, qs)
}
\arguments{
\item{meta}{object of class \code{metacommunity}}

\item{qs}{\code{vector} of mode \code{numeric} containing \emph{q} values}
}
\value{
\code{raw_meta_alpha} returns a standard output of class \code{rdiv}
}
\description{
Calculates similarity-sensitive raw metacommunity alpha diversity (the
naive-community metacommunity diversity). This measure may be calculated
for a series of orders, represented as a vector of \code{qs}.
}
\examples{
pop <- data.frame(a = c(1,3), b = c(1,1))
row.names(pop) <- paste0("sp", 1:2)
pop <- pop/sum(pop)
meta <- metacommunity(pop)

# Calculate raw metacommunity alpha diversity
raw_meta_alpha(meta, 0:2)

}
\references{
R. Reeve, T. Leinster, C. Cobbold, J. Thompson, N. Brummitt,
S. Mitchell, and L. Matthews. 2016. How to partition diversity.
arXiv 1404.6520v3:1–9.
}
