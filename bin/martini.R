#!/usr/bin/env Rscript

library(martini)
data(minigwas)
# 2. Create the SNP network: GS (structural information), GM (GS + gene 
# annotation information) or GI (GM + protein-protein interaction information)
gs <- get_GS_network(minigwas)
# 3. Find connected, explanatory SNPs (cones)
cones <- search_cones(minigwas, gs)

# cones$selected informs about whether the SNP is selected as cones or not
head(cones)