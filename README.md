---
title: "TP NGS"
author: "Sara Oukkal"
output:
  html_document: default
---

README NGS project.

## RNA-seq data download: 

### Find the data: 
Link to the data: `https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE98935`

### Choose the strains I will work on: 
Strains (Subset of the article's data): WT, alg-2(ok304) II (Argonaute 2 mutant) and alg-5(ram2) I (Argonaute 5 mutant). 
There are 3 replicates of each strain. 

### Get the RNAseq data: 
Download the data using the **Download_data.sh** script.

```{bash, eval=FALSE}
fastq-dump --split-3 --gzip --defline-seq '@$ac_$si/$ri' --defline-qual "+" $i
```

## Control the reads quality: 

### Fastqc analysis:
Use **Fastqc.sh** (one report per sample). Principal command: 

```{bash, eval=FALSE}
fastqc $file -o . -t 6
```

### Multiqc analysis:
Use **Multiqc.sh** (use on Fastqc directory output, one report for all samples). Principal command: 

```{bash, eval=FALSE}
multiqc $data/* -o . 
```
##Results: 
*Ajouter captures du rapport multiqc*

## Remove adapters from reads: 

### Find adapters sequences: 
Adapters were found in the supplementary data of Brown *et al*, 2017.

### Generate reverse complement sequences and put them in a fasta file: 
Online tool: `http://reverse-complement.com/`
Fasta file: **Adapter_sequences.fa**

### Use Trimmomatic to remove adapters:
Use Trimmomatic.sh 
```{bash, eval=FALSE}
multiqc $data/* -o . 
```

Trimmomatic generate two types of outputs, paired sequences (R1+R2) and unpaired sequences (R1 or R2 alone). For the rest of the analysis we only keep paired sequences.

## Control the reads quality after trimming:
I combined the two scripts of **Fastqc.sh** and **Multiqc.sh** to form the **Control_qual_trim.sh**.
We see on the Multiqc report that there are no (or almost no) more adapters , and that the read lengths are not as homogeneous as before. 

Ajouter rapport multiQC

## Transcript expression quantification: 

### Get the reference transcriptome:
Download the reference transcriptome of *C.elegans*: `https://www.ensembl.org/info/data/ftp/index.html`

Use the wget command with this link:  ftp://ftp.ensembl.org/pub/release-101/fasta/caenorhabditis_elegans/cdna/Caenorhabditis_elegans.WBcel235.cdna.all.fa.gz

Create an index using the **Transcriptome_index.sh** script

### Use Salmon to quantify the expression of transcripts in each sample:
Run salmon on experimental data using **Salmon.sh**

### Generate a Multiqc report with Salmon output data: 
Use the **Multiqc_after_salmon.sh** script. 

## Evaluate the impact of development: 

### Install RAPTOR and wormRef on R: 

```Bash
BiocManager::install("limma")
devtools::install_github("LBMC/RAPToR", build_vignettes = TRUE) devtools::install_github("LBMC/wormRef")
```

read vignette : vignette("RAPToR")

### Compare multiqc report on subset and on complete set (Hors série): 
mettre les deux rapports multi QC