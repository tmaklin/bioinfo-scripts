#!/bin/sh
#
#  Description
## Extracts recombination sites detected by gubbins from the
## input alignment and prints the sites to stdout.
#
# License
## BSD 3-Clause License
##
## Copyright (c) 2023, Tommi Mäklin
## All rights reserved.
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions are met:
##
## 1. Redistributions of source code must retain the above copyright notice, this
##    list of conditions and the following disclaimer.
##
## 2. Redistributions in binary form must reproduce the above copyright notice,
##    this list of conditions and the following disclaimer in the documentation
##    and/or other materials provided with the distribution.
##
## 3. Neither the name of the copyright holder nor the names of its
##    contributors may be used to endorse or promote products derived from
##    this software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
## AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
## IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
## DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
## FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
## DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
## SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
## CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
## OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
## OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
##
# Args
##  $1: `recombination_predictions.gff` file from gubbins.
##  $2: sequence alignment given as input to gubbins.
##
##  Note: this script can be pretty slow if there are many sites.

set -euo pipefail

in_no_header=tmp-dump-gubbins-$RANDOM.gff
grep -v "^#" $1 > $in_no_header

seq_positions=tmp-dump-gubbins-$RANDOM.txt
grep -n ">" $2 | sed 's/[#]/_/g' > $seq_positions
nlines=$(wc -l $2 | cut -f1 -d' ')
echo $((nlines + 1))":>end" >> $seq_positions

i=1
while read line; do
    seqs=$(echo $line | grep -o "taxa=.*[;]" | sed 's/^taxa="//g' | sed 's/".*$//g')
    taxa=$(echo $seqs | cut -f1 -d' ')
    start_pos=$(grep -n $taxa $seq_positions | cut -f1 -d':')
    end_pos=$((start_pos + 1))
    start_pos=$(sed -n "$start_pos p" $seq_positions | cut -f1 -d':')
    end_pos=$(sed -n "$end_pos p" $seq_positions | cut -f1 -d':')
    end_pos=$((end_pos - 1))
    fasta_sequence=$(sed -n "$start_pos,$end_pos p" $2 | grep -v ">" | tr -d '\n')
    cds_start=$(echo $line | cut -f4 -d' ')
    cds_end=$(echo $line | cut -f5 -d' ')
    echo ">$i"
    echo $fasta_sequence | cut -c$cds_start-$cds_end
    let "i++"
done < $in_no_header

rm $in_no_header
rm $seq_positions
