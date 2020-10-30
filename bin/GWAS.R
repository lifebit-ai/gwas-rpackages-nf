#!/usr/bin/env Rscript
library(GWASTools)
library(GWASdata)
# Load the SNP annotation (simple data frame)
data(illumina_snp_annot)
# Create a SnpAnnotationDataFrame
snpAnnot <- SnpAnnotationDataFrame(illumina_snp_annot)
# names of columns
varLabels(snpAnnot)
# data
head(pData(snpAnnot))
# Add metadata to describe the columns
meta <- varMetadata(snpAnnot)
meta[c("snpID", "chromosome", "position", "rsID", "alleleA", "alleleB",
  "BeadSetID", "IntensityOnly", "tAA", "tAB", "tBB", "rAA", "rAB", "rBB"),
  "labelDescription"] <- c("unique integer ID for SNPs",
  paste("integer code for chromosome: 1:22=autosomes,",
   "23=X, 24=pseudoautosomal, 25=Y, 26=Mitochondrial, 27=Unknown"),
  "base pair position on chromosome (build 36)",
  "RS identifier",
  "alelleA", "alleleB",
  "BeadSet ID from Illumina",
  "1=no genotypes were attempted for this assay",
  "mean theta for AA cluster",
  "mean theta for AB cluster",
  "mean theta for BB cluster",
  "mean R for AA cluster",
  "mean R for AB cluster",
  "mean R for BB cluster")
varMetadata(snpAnnot) <- meta



snpID <- snpAnnot$snpID
snpID <- getSnpID(snpAnnot)
chrom <- snpAnnot[["chromosome"]]
chrom <- getChromosome(snpAnnot)
table(chrom)
chrom <- getChromosome(snpAnnot, char=TRUE)
table(chrom)
position <- getPosition(snpAnnot)
rsID <- getVariable(snpAnnot, "rsID")



tmp <- snpAnnot[,c("snpID", "chromosome", "position")]
snp <- getAnnotation(tmp)
snp$flag <- sample(c(TRUE, FALSE), nrow(snp), replace=TRUE)
pData(tmp) <- snp
meta <- getMetadata(tmp)
meta["flag", "labelDescription"] <- "flag"
varMetadata(tmp) <- meta
getVariableNames(tmp)
varLabels(tmp)[4] <- "FLAG"
rm(tmp)


# Load the scan annotation (simple data frame)
data(illumina_scan_annot)
# Create a ScanAnnotationDataFrame
scanAnnot <- ScanAnnotationDataFrame(illumina_scan_annot)
# names of columns
varLabels(scanAnnot)
# data
head(pData(scanAnnot))
# Add metadata to describe the columns
meta <- varMetadata(scanAnnot)
meta[c("scanID", "subjectID", "family", "father", "mother",
  "CoriellID", "race", "sex", "status", "genoRunID", "plate",
  "batch", "file"), "labelDescription"] <-
   c("unique ID for scans",
  "subject identifier (may have multiple scans)",
  "family identifier",
  "father identifier as subjectID",
  "mother identifier as subjectID",
  "Coriell subject identifier",
  "HapMap population group",
  "sex coded as M=male and F=female",
  "simulated case/control status" ,
  "genotyping instance identifier",
  "plate containing samples processed together for genotyping chemistry",
  "simulated genotyping batch",
  "raw data file")
varMetadata(scanAnnot) <- meta


scanID <- scanAnnot$scanID
scanID <- getScanID(scanAnnot)
sex <- scanAnnot[["sex"]]
sex <- getSex(scanAnnot)
subjectID <- getVariable(scanAnnot, "subjectID")




# Define a path to the raw data files
path <- system.file("extdata", "illumina_raw_data", package="GWASdata")

geno.file <- "tmp.geno.gds"

# first 3 samples only
scan.annotation <- illumina_scan_annot[1:3, c("scanID", "genoRunID", "file")]
names(scan.annotation)[2] <- "scanName"

snp.annotation <- illumina_snp_annot[,c("snpID", "rsID", "chromosome", "position")]
# indicate which column of SNP annotation is referenced in data files
names(snp.annotation)[2] <-  "snpName"

col.nums <- as.integer(c(1,2,12,13))
names(col.nums) <- c("snp", "sample", "a1", "a2")

diag.geno.file <- "diag.geno.RData"
diag.geno <- createDataFile(path = path,
  filename = geno.file,
  file.type = "gds",
  variables = "genotype",
  snp.annotation = snp.annotation,
  scan.annotation = scan.annotation,
  sep.type = ",",
  skip.num = 11,
  col.total = 21,
  col.nums = col.nums,
  scan.name.in.file = 1,
  diagnostics.filename = diag.geno.file,
  verbose = FALSE)
# Look at the values included in the "diag.geno" object which holds
#   all output from the function call
names(diag.geno)
# `read.file' is a vector indicating whether (1) or not (0) each file
#   specified in the `files' argument was read successfully
table(diag.geno$read.file)
# `row.num' is a vector of the number of rows read from each file
table(diag.geno$row.num)
# `sample.match' is a vector indicating whether (1) or not (0)
#   the sample name inside the raw text file matches that in the
#   sample annotation data.frame
table(diag.geno$sample.match)
# `snp.chk' is a vector indicating whether (1) or not (0)
#   the raw text file has the expected set of SNP names
table(diag.geno$snp.chk)
# `chk' is a vector indicating whether (1) or not (0) all previous
#   checks were successful and the data were written to the data file
table(diag.geno$chk)