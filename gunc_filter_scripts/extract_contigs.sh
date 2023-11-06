#!/bin/sh

set -euo pipefail

assembly=$1
targets=$2
tmpdir=$3

contig_pos=$tmpdir/tmp-extract_contigs-$RANDOM
asm_in=$tmpdir/tmp-extract_contigs-$RANDOM".fasta"

gunzip -c --force $assembly > $asm_in
grep -n ">" $asm_in > $contig_pos
lines=$(wc -l $asm_in | cut -f1 -d' ')
lines=$(( lines + 1 ))
echo $lines":>end" >> $contig_pos

while read target; do
    ## Extract the target contig start and end lines in the assembly
    target_start=$(grep -n "$target" $contig_pos | cut -f1 -d':')
    target_end=$(( target_start + 1))
    start_pos=$(sed -n "$target_start p" $contig_pos | cut -f1 -d':')
    end_pos=$(sed -n "$target_end p" $contig_pos | cut -f1 -d':')
    end_pos=$(( end_pos - 1 ))

    ## Extract the contigs
    sed -n "$start_pos, $end_pos p" $asm_in
done < $targets


