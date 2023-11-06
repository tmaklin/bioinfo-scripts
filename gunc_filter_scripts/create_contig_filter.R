#!/bin/Rscript

args <- commandArgs(trailingOnly=TRUE)

if (length(args) < 3) {
    stop("Supply 3 arguments")
}

infile <- args[1]
target.level <- args[2]
target.taxon <- args[3]

gunc.contigs <- read.table(infile, sep='\t', header=TRUE)
gunc.contigs <- gunc.contigs[gunc.contigs$tax_level == target.level, ]

if (target.level == "genus") {
    ## Gunc reports Shigella as a separate genus which is not always correct genetically
    gunc.contigs$assignment <- gsub("620 Shigella", "561 Escherichia", gunc.contigs$assignment)
}

## For each contig pick the taxon with the most genes assigned to it.
## Break ties by selecting the taxon that matches `target.taxon`.
contig.assignments <- by(gunc.contigs, gunc.contigs$contig, function(x) tail(x$assignment[order(x$count_of_genes_assigned, gsub("[0-9]*[[:space:]]", "", x$assignment) == target.taxon)], 1))

## Contig passes filter if the taxa with the highest number of genes
## assigned to it matches `target.taxon`.
pass.filter <- unlist(lapply(contig.assignments, function(x) gsub("^[0-9]*[[:space:]]", "", x) == target.taxon))

## Print results to stdout
cat(names(pass.filter)[pass.filter], sep='\n')
