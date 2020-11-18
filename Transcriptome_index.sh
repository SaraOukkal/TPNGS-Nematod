#!/bin/bash

##Path to data directory: 
data="/home/rstudio/data/mydatalocal/data"

##Download the reference transcriptome: 
wget ftp://ftp.ensembl.org/pub/release-101/fasta/caenorhabditis_elegans/cdna/Caenorhabditis_elegans.WBcel235.cdna.all.fa.gz -O $data/ref_transcriptome.fa.gz

##Create an index with the reference transcriptome: 
salmon index -t $data/ref_transcriptome.fa.gz -i $data/index_transcriptome
echo "index done"
