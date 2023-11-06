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

## Filter out contigs that don't have any assignments to the target taxon
pass.filter <- unlist(by(gunc.contigs, gunc.contigs$contig, function(x) any(x$assignment == target.taxon)))

## Print results to stdout
cat(names(pass.filter)[pass.filter], sep='\n')
