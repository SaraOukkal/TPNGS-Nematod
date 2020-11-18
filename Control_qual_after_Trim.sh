#!/bin/bash
#Control the quality of the data (fastqc): 

##Create a folder for the files containing the time information: 
time_files="/home/rstudio/data/mydatalocal/data/time_files"
mkdir -p $time_files

##Create a variable with the data set: 
data_1="/home/rstudio/data/mydatalocal/data/paired_data"

## Create a folder for the fastqc
fastqc_data="/home/rstudio/data/mydatalocal/data/fastqc_data_trim"
mkdir -p $fastqc_data
cd $fastqc_data

##Loop to run fastqc:
for file in $data_1/*
do
start=$SECONDS
fastqc $file -o . -t 6
end=$SECONDS
Time=$(((end - start)/60))
echo "$file $Time" >> $time_files/time_fastqc_trim.txt
done

#Regroup quality controls (multiqc): 

##Create a variable with the data set and the time files directory: 
data_2="/home/rstudio/data/mydatalocal/data/fastqc_data_trim"
time_files="/home/rstudio/data/mydatalocal/data/time_files"

## Create a folder for the multiqc
multiqc_data="/home/rstudio/data/mydatalocal/data/multiqc_data_trim"
mkdir -p $multiqc_data
cd $multiqc_data

##Loop to run fastqc:
start=$SECONDS
multiqc $data_2/* -o . 
end=$SECONDS
Time=$(((end - start)/60))
echo "$file $Time" >> $time_files/time_multiqc_trim.txt
