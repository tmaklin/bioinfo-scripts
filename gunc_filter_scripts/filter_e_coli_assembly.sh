#!/bin/sh

## Filter the contigs in an Escherichia coli assembly according to gunc output

##set -euxo pipefail

gunc_assignments=$1
assembly=$2
tmpdir=$3

## Filter by kingdom == Bacteria
tmp_out=$tmpdir/tmp-assembly-filtered-kingdom-$RANDOM.fasta
./filter_contigs.sh $gunc_assignments kingdom Bacteria $assembly $tmpdir > $tmp_out
tmp_in=$tmp_out

## Filter by phylum == Proteobacteria
tmp_out=$tmpdir/tmp-assembly-filtered-phylum-$RANDOM.fasta
./filter_contigs.sh $gunc_assignments phylum Proteobacteria $tmp_in $tmpdir > $tmp_out
tmp_in=$tmp_out

## Filter by class == Gammaproteobacteria
tmp_out=$tmpdir/tmp-assembly-filtered-class-$RANDOM.fasta
./filter_contigs.sh $gunc_assignments class Gammaproteobacteria $tmp_in $tmpdir > $tmp_out
tmp_in=$tmp_out

## Filter by order == Enterobacterales
tmp_out=$tmpdir/tmp-assembly-filtered-order-$RANDOM.fasta
./filter_contigs.sh $gunc_assignments order Enterobacterales $tmp_in $tmpdir > $tmp_out
tmp_in=$tmp_out

## Filter by family == Enterobacteriaceae
tmp_out=$tmpdir/tmp-assembly-filtered-family-$RANDOM.fasta
./filter_contigs.sh $gunc_assignments family Enterobacteriaceae $tmp_in $tmpdir > $tmp_out
tmp_in=$tmp_out

## Filter by genus == Escherichia
## Note: script will assign Shigella to Escherichia before filtering
tmp_out=$tmpdir/tmp-assembly-filtered-genus-$RANDOM.fasta
./filter_contigs.sh $gunc_assignments genus Escherichia $tmp_in $tmpdir > $tmp_out
cat $tmp_out
