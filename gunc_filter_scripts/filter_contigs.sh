#!/bin/sh

set -euo pipefail

gunc_in=$1
target_level=$2
target_taxon=$3
assembly=$4
tmpdir=$5

contig_list=$tmpdir/tmp-contig_list-$RANDOM.txt

Rscript create_contig_filter.R $gunc_in $target_level $target_taxon > $contig_list
./extract_contigs.sh $assembly $contig_list $tmpdir

