# hubfindr

<img src="https://github.com/gzahn/hubfindr/blob/main/media/sticker.png" alt="drawing" width="200"/>



### R helper functions for finding and using hub taxa from igraph objects

These functions make identifying and working with network hubs easier.

This package is under active development. *caveat emptor*

Depends on: 

  - *igraph* v >= 1.5.1
  - *SpiecEasi* v >= 1.1.3
  - *phyloseq* v >= 1.46.0

### Installation

```
if (!requireNamespace("devtools", quietly = TRUE))
    install.packages("devtools")
devtools::install_github("gzahn/hubfindr")
```

### Build Info

	- R version 4.3.1 (2023-06-16)
	- Platform: x86_64-pc-linux-gnu (64-bit)
	- Running under: Ubuntu 22.04.3 LTS

___

### Example use:

```
library(hubfindr)

# build SpiecEasi network from phyloseq object
se.params <- list(rep.num=20, ncores=(parallel::detectCores()-1))
se <- SpiecEasi::spiec.easi(data = hubfindr::ps,
                            method='mb',
                            sel.criterion = "bstars",
                            pulsar.params=se.params)

# convert to igraph format
ig <- adj2igraph(getRefit(se))

# find hub taxa
hubs <- find_hubs(ig,ps,"midpoint")

```

<img src="https://github.com/gzahn/hubfindr/blob/main/media/hub_table.png" alt="results table" width="800"/>

### Citation:

Please cite this package if you find it useful.

[![DOI](https://zenodo.org/badge/733999306.svg)](https://zenodo.org/doi/10.5281/zenodo.12741088)

Geoffrey Zahn. (2024). gzahn/hubfindr: v0.1.0 (v0.1.0). Zenodo. https://doi.org/10.5281/zenodo.12741089



