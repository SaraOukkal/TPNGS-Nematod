#!/bin/bash

#Regroup quality controls (multiqc) after salmon: 

##Create a variable with the data set and the time files directory: 
data="/home/rstudio/data/mydatalocal/data/quantifications"
time_files="/home/rstudio/data/mydatalocal/data/time_files"

## Create a folder for the multiqc
multiqc_data="/home/rstudio/data/mydatalocal/data/multiqc_after_salmon"
mkdir -p $multiqc_data
cd $multiqc_data

##Loop to run fastqc:
start=$SECONDS
multiqc $data/* -o . 
end=$SECONDS
Time=$(((end - start)/60))
echo "$file $Time" >> $time_files/time_multiqc_salmon.txt
