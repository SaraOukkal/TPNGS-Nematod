#!/bin/bash
#Control the quality of the data (fastqc): 

##Create a folder for the files containing the time information: 
time_files="/home/rstudio/data/mydatalocal/data/time_files"
mkdir -p $time_files

##Create a variable with the data set: 
data="/home/rstudio/data/mydatalocal/data/sra_data_test"

## Create a folder for the fastqc
fastqc_data="/home/rstudio/data/mydatalocal/data/fastqc_data_test"
mkdir -p $fastqc_data
cd $fastqc_data

##Loop to run fastqc:
for file in $data/*
do
start=$SECONDS
fastqc $file -o . -t 6
end=$SECONDS
Time=$(((end - start)/60))
echo "$file $Time" >> $time_files/time_fastqc_test.txt
done