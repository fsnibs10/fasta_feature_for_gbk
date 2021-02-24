#!/usr/bin/sh

input=$1   # first parameter: fasta file
feature=$2  # second file : feature table
out=$3    # output feature gbk file

sample=${input%.*}
fa2gbk=${sample}".gbk"

echo "fasta => gbk"
seqret -osformat genbank -outseq $fa2gbk $input

echo "write feature to sequence gbk"
write_feature_for_gbk.pl $fa2gbk $feature $out

echo "Done! Got the feature gbk."


