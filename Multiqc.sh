#!/bin/bash
#Regroup quality controls (multiqc): 

##Create a variable with the data set and the time files directory: 
data="/home/rstudio/data/mydatalocal/data/fastqc_data"
time_files="/home/rstudio/data/mydatalocal/data/time_files"

## Create a folder for the multiqc
multiqc_data="/home/rstudio/data/mydatalocal/data/multiqc_data"
mkdir -p $multiqc_data
cd $multiqc_data

##Loop to run fastqc:
start=$SECONDS
multiqc $data/* -o . 
end=$SECONDS
Time=$(((end - start)/60))
echo "$file $Time" >> $time_files/time_multiqc.txt
