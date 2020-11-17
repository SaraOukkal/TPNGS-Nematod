#!/bin/bash

##Create variables for the data set and the adapters: 
data="/home/rstudio/data/mydatalocal/data/sra_data_test"
adapter="/home/rstudio/data/mydatalocal/TPNGS-Nematod/Adapter_sequences.fa"

##Create directories for the output files (separate paired and unpaired):
paired_data="/home/rstudio/data/mydatalocal/data/paired_data"
mkdir -p $paired_data
unpaired_data="/home/rstudio/data/mydatalocal/data/unpaired_data"
mkdir -p $unpaired_data

##Create a variable of trimmomatic: 
TRIMMOMATIC_JAR="/softwares/Trimmomatic-0.39/trimmomatic-0.39.jar"
time_files="/home/rstudio/data/mydatalocal/data/time_files"

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

##Form file names
for name in $SRR
do
input_1="$data/${name}_1.fastq.gz"
input_2="$data/${name}_2.fastq.gz"

output_1_paired="$paired_data/${name}_1.fastq.gz"
output_1_unpaired="$unpaired_data/${name}_1.fastq.gz"
output_2_paired="$paired_data/${name}_2.fastq.gz"
output_2_unpaired="$unpaired_data/${name}_2.fastq.gz"

##Run trimmomatic and calculate the time it takes for each file:
start=$SECONDS
java -jar $TRIMMOMATIC_JAR PE -phred33 $input_1 $input_2 $output_1_paired \
  $output_1_unpaired $output_2_paired $output_2_unpaired ILLUMINACLIP:$adapter:2:30:10\
  LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 
end=$SECONDS
Time=$(((end - start)/60))
echo "$file $Time" >> $time_files/time_trimmomatic_test.txt
done