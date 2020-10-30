#!/usr/bin/env Rscript
library(XGR)
Haploid_regulators <- xRDataLoader('Haploid_regulators')
df <- Haploid_regulators[ind,c('Gene','MI','FDR')]
RData.location <- "http://galahad.well.ox.ac.uk/bigdata"

g <- xRDataLoader(RData.customised='ig.PCHiC',
RData.location=RData.location)
df <- do.call(cbind, igraph::edge_attr(g))

data <- df
data[data<5] <- NA
res <- xAggregate(data)


library(RCircos)
ImmunoBase <- xRDataLoader(RData.customised='ImmunoBase',
RData.location=RData.location)

