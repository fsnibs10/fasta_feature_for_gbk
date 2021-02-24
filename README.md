# File format toolkit

## fasta_feature_for_gbk
Given a fasta file and a feature table, it can output a simplified version of the genbank file.

### Prerequisite:
EMBOSS seqret http://www.bioinformatics.nl/cgi-bin/emboss/help/seqret

### Input files:
- 1. Only one-sequence fasta file
- 2. a feature table, tab seperated txt file

### Command:
parameter1: input fasta file
parameter2: feature file 
parameter3: output the gbk file
```bash
fa_feature_to_gbk.sh MT.fasta feature.txt MT.feature.gbk
```
### Output file
The output file is the simplified gbk file, with our defined features.

