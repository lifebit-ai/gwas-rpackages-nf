#!/usr/bin/env Rscript
library(GGPA)
data(simulation)
dim(simulation$pmat)
head(simulation$pmat)
adjmat <- simulation$true_G
diag(adjmat) <- 0
ggnet2( adjmat, label=TRUE, size=15 )


adjmat <- simulation$true_G
diag(adjmat) <- 0
plot( adjmat, size=15 )

fit <- GGPA( simulation$pmat, nBurnin=20, nMain=20 )

str(estimates(fit))
assoc.marg <- assoc( fit, FDR=0.10, fdrControl="global" )
dim(assoc.marg)
apply( assoc.marg, 2, table )
fdr.marg <- fdr(fit)
dim(fdr.marg)
head(fdr.marg)


assoc.joint <- assoc( fit, FDR=0.10, fdrControl="global", i=1, j=2 )
length(assoc.joint)
head(assoc.joint)
table(assoc.joint)

set.seed(12345)
plot(fit)

