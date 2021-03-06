# rdiversity: diversity measurement in R 
[![Build Status](https://travis-ci.org/boydorr/rdiversity.svg?branch=master)](https://travis-ci.org/boydorr/rdiversity)
[![Build status](https://ci.appveyor.com/api/projects/status/463vspjivh08o9x1?svg=true)](https://ci.appveyor.com/project/mysteryduck/rdiversity)
[![Coverage Status](https://coveralls.io/repos/github/boydorr/rdiversity/badge.svg?branch=master)](https://coveralls.io/github/boydorr/rdiversity?branch=master)
[![codecov](https://codecov.io/gh/boydorr/rdiversity/branch/master/graph/badge.svg)](https://codecov.io/gh/boydorr/rdiversity)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.597470.svg)](https://doi.org/10.5281/zenodo.597470)
[![Total downloads](http://cranlogs.r-pkg.org/badges/grand-total/rdiversity?color=yellow)](http://cranlogs.r-pkg.org/badges/grand-total/rdiversity)


Note that the following documentation applies only to the development version of the package, which can be installed using: `devtools::install_github("boydorr/rdiversity")`.

`rdiversity` is a package for R based around a framework for measuring biodiversity using similarity-sensitive diversity measures. It provides functionality for measuring alpha, beta and gamma diversity of metacommunities (*e.g.* ecosystems) and their constituent subcommunities, where similarity may be defined as taxonomic, phenotypic, genetic, phylogenetic, functional, and so on. It uses the diversity framework described in the arXiv paper [arXiv:1404.6520 (q-bio.QM)](https://arxiv.org/abs/1404.6520), "How to partition diversity". 

This package has now reached a stable release and is cross-validated against our Julia package [Diversity.jl](https://github.com/richardreeve/Diversity.jl), which is developed independently. Please [raise an issue](https://github.com/boydorr/rdiversity/issues) if you find any problems.


## Contents

Getting started:

* [Installation](#installation)
* [Generating a metacommunity](#generating-a-metacommunity)
* [Calculating diversity](#calculating-diversity)


Special cases:

* [Taxonomic diversity](#taxonomic-diversity)
* [Phylogenetic diversity](#phylogenetic-diversity)
* [User defined distance](#user-defined-distance)
* [User defined similarity](#user-defined-similarity)


Miscellaneous:

* [Additional tools](#additional-tools)


## Installation

To install rdiversity from CRAN, simply run the following from an R console:

```{r}
install.packages("rdiversity")
```

## Generating a metacommunity 

Before calculating diversity a `metacommunity` object must be created. This object contains all the information needed to calculate diversity. In the following example, we generate a metacommunity (`partition`) comprising two species ("cows" and "sheep"), and partitioned across three subcommunities (a, b, and c).

```{r}
# Load the package into R
library(rdiversity)

# Initialise data
partition <- data.frame(a=c(1,1),b=c(2,0),c=c(3,1))
row.names(partition) <- c("cows", "sheep")
```
The `metacommunity()` function takes two arguments, `partition` and `similarity`. When species are considered completely distinct, an identity matrix is required, which is generated automatically if the `similarity` argument is missing, as below:

```{r}
# Generate metacommunity object
meta <- metacommunity(partition = partition)
```

Note that a warning is displayed when abundances (rather than relative abundances) are entered into the `partition` argument. Both are acceptable inputs.

When species share some similarity and a similarity matrix is available, then a similarity object (and the metacommunity object) is generated in the following way:

```{r}
# Initialise similarity matrix
s <- matrix(c(1, 0.5, 0.5, 1), nrow = 2)
row.names(s) <- c("cows", "sheep")
colnames(s) <- c("cows", "sheep")

# Generate similarity object 
s <- similarity(similarity = s, dat_id = "my_taxonomic")

# Generate metacommunity object
meta <- metacommunity(partition = partition, similarity = s)
```

Alternatively, if a distance matrix is available, then a distance object is generated in the following way: 

```{r}
# Initialise distance matrix
d <- matrix(c(0, 0.7, 0.7, 0), nrow = 2)
row.names(d) <- c("cows", "sheep")
colnames(d) <- c("cows", "sheep")

# Generate distance object
d <- distance(distance = d, dat_id = "my_taxonomic")

# Convert the distance object to similarity object (by means of a linear or exponential transform)
s <- dist2sim(dist = d, transform = "linear")

# Generate metacommunity object
meta <- metacommunity(partition = partition, similarity = s)
```

Each `metacommunity` object contains the following slots:

* `@type_abundance` : the abundance of types within a metacommunity,  
* `@similarity` : the pair-wise similarity of types within a metacommunity,  
* `@ordinariness` : the ordinariness of types within a metacommunity,  
* `@subcommunity_weights` :  the relative weights of subcommunities within a metacommunity, and
* `@type_weights` : the relative weights of types within a metacommunity.


## Calculating diversity
### Method 1
This method uses a wrapper function to simplify the pipeline and is recommended if only a few measures are being calculated.

A complete list of these functions is shown below:

* `raw_sub_alpha()` : estimate of naive-community metacommunity diversity  
* `norm_sub_alpha()` : similarity-sensitive diversity of subcommunity *j* in isolation  
* `raw_sub_rho()` : redundancy of subcommunity *j*  
* `norm_sub_rho()` : representativeness of subcommunity *j*  
* `raw_sub_beta()` : distinctiveness of subcommunity *j*  
* `norm_sub_beta()` : estimate of effective number of distinct subcommunities  
* `sub_gamma()` : contribution per individual toward metacommunity diversity  
* `raw_meta_alpha()` : naive-community metacommunity diversity  
* `norm_meta_alpha()` : average similarity-sensitive diversity of subcommunities  
* `raw_meta_rho()` : average redundancy of subcommunities  
* `norm_meta_rho()` : average representativeness of subcommunities  
* `raw_meta_beta()` : average distinctiveness of subcommunities  
* `norm_meta_beta()` : effective number of distinct subcommunities  
* `meta_gamma()` : metacommunity similarity-sensitive diversity  

Each of these functions take two arguments, `meta` (a `metacommunity` object) and `qs` (a vector of q values), and output results as a `rdiv` object. For example, to calculate normalised subcommunity alpha diversity for *q=0*, *q=1*, and *q=2*:

```{r}
# Initialise data
partition <- data.frame(a=c(1,1),b=c(2,0),c=c(3,1))
row.names(partition) <- c("cows", "sheep")

# Generate a metacommunity object
meta <- metacommunity(partition)

# Calculate diversity
norm_sub_alpha(meta, 0:2)
```

However, if multiple measures are required and computational efficiency is an issue, then the following method is recommended (the same results are obtained).


### Method 2
This method requires that we first calculate the species-level components, by passing a `metacommunity` object to the appropriate function; `raw_alpha()`, `norm_alpha()`, `raw_beta()`, `norm_beta()`, `raw_rho()`, `norm_rho()`, or `raw_gamma()`. Subcommunity- and metacommunity-level diversities are calculated using the functions `subdiv()` and `metadiv()`. Since both subcommunity and metacommunity diversity measures are transformations of the same species-level component, this method is computationally more efficient.

```{r}
# Initialise data
partition <- data.frame(a=c(1,1),b=c(2,0),c=c(3,1))
row.names(partition) <- c("cows", "sheep")

# Generate a metacommunity object
meta <- metacommunity(partition)

# Calculate the species-level component for normalised alpha
component <- norm_alpha(meta)

# Calculate normalised alpha at the subcommunity-level 
subdiv(component, 0:2)

# Likewise, calculate normalised alpha at the metacommunity-level 
metadiv(component, 0:2)
```

In some instances, it may be useful to calculate **all** subcommunity (or metacommunity) measures. In which case, a `metacommunity` object may be passed directly to `subdiv()` or `metadiv()`:

```{r}
# Calculate all subcommunity diversity measures
subdiv(meta, 0:2)

# Calculate all metacommunity diversity measures
metadiv(meta, 0:2)
```




## Taxonomic diversity
1. Initialise data:
```{r}
# Taxonomic lookup table
Species <- c("tenuifolium", "asterolepis", "simplex var.grandiflora", "simplex var.ochnacea")
Genus <- c("Protium", "Quararibea", "Swartzia", "Swartzia")
Family <- c("Burseraceae", "Bombacaceae", "Fabaceae", "Fabaceae")
Subclass <- c("Sapindales", "Malvales", "Fabales", "Fabales")
lookup <- cbind.data.frame(Species, Genus, Family, Subclass)

# Partition matrix
partition <- matrix(rep(1, 8), nrow = 4)
colnames(partition) <- LETTERS[1:2]
rownames(partition) <- lookup$Species

```
and assign values for each taxonomic level:
```{r}
values <- c(Species = 0, Genus = 1, Family = 2, Subclass = 3, Other = 4)
```

2. Generate a distance object from a lookup table using the `tax2dist()` 
function:
```{r}
d <- tax2dist(lookup, values)
```
By default the `tax2dist()` argument `precompute_dist` is TRUE, such that a pairwise distance matrix is calculated automatically and is stored in `d@distance`. If the taxonomy is too large, `precompute_dist` can be set to FALSE, which enables pairwise taxonomic similarity to be calculated on the fly, in step 4. 

3. Convert the distance object to similarity object (by means of a linear or exponential transform) using the `dist2sim()` function:
```{r}
s <- dist2sim(d, "linear")
```

4. Generate a metacommunity object using the `metacommunity()` function:
```{r}
meta <- metacommunity(partition, s)
```

5. Calculate diversity:
```{r}
meta_gamma(meta, 0:2)
```

## Phylogenetic diversity
Phylogenetic diversity measures can be broadly split into two categories – those that look at the phylogeny as a whole, such as Faith’s (1992) phylogenetic diversity (Faith’s PD), and those that look at pairwise tip distances, such as mean pairwise distance (MPD; Webb, 2000). The framework of measures presented in this package is able to quantify phylogenetic diversity using both of these methods.


### Distance-based phylogenetic diversity

1. Initialise data:
```{r}
# Example data
tree <- ape::rtree(4)
partition <- matrix(1:12, ncol=3)
partition <- partition/sum(partition)
```

2. Generate a distance matrix using the `phy2dist()` function: 
```{r}
d <- phy2dist(tree)
```
By default the `phy2dist()` argument `precompute_dist` is TRUE, such that a pairwise distance matrix is calculated automatically and is stored in `d@distance`. If the taxonomy is too large, `precompute_dist` can be set to FALSE, which enables pairwise taxonomic similarity to be calculated on the fly, in step 4. 

3. Convert the distance object to similarity object (by means of a linear or exponential transform) using the `dist2sim()` function:
```{r}
s <- dist2sim(d, "linear")
```

4. Generate a metacommunity object using the `metacommunity()` function
```{r}
meta <- metacommunity(partition, s)
```

5. Calculate diversity
```{r}
meta_gamma(meta, 0:2)
```

### Branch-based phylogenetic diversity
1. Initialise data:
```{r}
tree <- ape::rtree(4)
partition <- matrix(1:12, ncol=3)
partition <- partition/sum(partition)
colnames(partition) <- letters[1:3]
row.names(partition) <- paste0("sp",1:4)
tree$tip.label <- row.names(partition)
```

2. Generate a similarity object using the `phy2branch()` function
```{r}
s <- phy2branch(tree, partition)
```

3. Generate a metacommunity object using the `metacommunity()` function
```{r}
meta <- metacommunity(partition, s)
```

4. Calculate diversity
```{r}
meta_gamma(meta, 0:2)
```


**Note that**: a metacommunity that was generated using this approach will contain three additional slots:

* `@raw_abundance` : the relative abundance of terminal species (where types are then considered to be historical species),
* `@raw_structure` : the length of evolutionary history of each historical species
* `@parameters` : parameters associated with historical species


### User defined distance
```{r}
partition <- matrix(sample(6), nrow = 3)
rownames(partition) <- paste0("sp", 1:3)
partition <- partition / sum(partition)

d <- matrix(c(0,.75,1,.75,0,.3,1,.3,0), nrow = 3)
rownames(d) <- paste0("sp", 1:3)
colnames(d) <- paste0("sp", 1:3)
d <- distance(d, "my_taxonomy")
s <- dist2sim(d, "linear")

meta <- metacommunity(partition, s)
```


### User defined similarity
```{r}
partition <- matrix(sample(6), nrow = 3)
rownames(partition) <- paste0("sp", 1:3)
partition <- partition / sum(partition)

s <- matrix(c(1,.8,0,.8,1,.1,0,.1,1), nrow = 3)
rownames(s) <- paste0("sp", 1:3)
colnames(s) <- paste0("sp", 1:3)
s <- similarity(s, "my_functional")

meta <- metacommunity(partition, s)
```




## Additional tools

### `repartition()`

```{r}
tree <- ape::rtree(5)
tree$tip.label <- paste0("sp", 1:5)

partition <- matrix(rep(1,10), nrow = 5)
row.names(partition) <- paste0("sp", 1:5)
partition <- partition / sum(partition)
s <- phy2branch(tree, partition)
meta <- metacommunity(partition, s)

new_partition <- matrix(sample(10), nrow = 5)
row.names(new_partition) <- paste0("sp", 1:5)
new_partition <- new_partition / sum(new_partition)

new_meta <- repartition(meta, new_partition)
```

