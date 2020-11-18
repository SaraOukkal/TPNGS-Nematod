#!/bin/bash

##Path to data directory: 
data="/home/rstudio/data/mydatalocal/data"

##Create a variable with the experimental data: 
exp_data="$data/paired_data"

##Create an output directory: 
quants="$data/quantifications"
mkdir -p $quants

##Create a list of accession names: 
SRR="SRR5564855
SRR5564856
SRR5564857
SRR5564864
SRR5564865
SRR5564866
SRR5564867
SRR5564868
SRR5564869"

##Run salmon to quantify RNAseq data: 
for name in $SRR
do
echo "$name"
input_1="$exp_data/${name}_1.fastq.gz"
input_2="$exp_data/${name}_2.fastq.gz"
output="$exp_data/${name}_quant"

salmon quant -i $data/index_transcriptome -l A \
         -1 $input_1 \
         -2 $input_2 \
         -p 8 --validateMappings -o $quants/${name}_quant
echo "Sample done"
done 
