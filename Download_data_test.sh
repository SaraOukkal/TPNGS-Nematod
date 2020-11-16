#! /bin/bash
##Download SRA Data (5 strains/3 replicates):

### Create a directory:
data="/home/rstudio/data/mydatalocal/data"
mkdir -p $data
cd $data
mkdir -p sra_data_test
cd sra_data_test

### Create a list of SRR accessions:
SRR="SRR5564855
SRR5564856
SRR5564857
SRR5564864
SRR5564865
SRR5564866
SRR5564867
SRR5564868
SRR5564869"

###For loop to download data from each SRR: 
for i in $SRR
do 
fastq-dump --split-3 --gzip -X 100000 --defline-seq '@$ac_$si/$ri' --defline-qual "+" $i 
done