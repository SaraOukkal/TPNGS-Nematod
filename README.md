---
title: "TP NGS"
author: "Sara Oukkal"
output:
  html_document: default
---

README NGS project.

## Introduction: 
*Ajouter background biologique*

## RNA-seq data download: 

Link to the data: `https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE98935`

Strains (Subset of the article's data): WT, alg-2(ok304) II (Argonaute 2 mutant) and alg-5(ram2) I (Argonaute 5 mutant). 
There are 3 replicates of each strain. 

I downloaded the data using the **Download_data.sh** script. Principal command: 

```{bash, eval=FALSE}
fastq-dump --split-3 --gzip --defline-seq '@$ac_$si/$ri' --defline-qual "+" $i
```

I changed the fasta def lines (defline-seq and defline-qual): 

- The sequence defline contain: The accession number, the spot id and the read number 

- The quality defline contain à + symbol. 

## Control the reads quality:

### 1) Fastqc analysis:
I used **Fastqc.sh** (one report per sample). Principal command: 

```{bash, eval=FALSE}
fastqc $file -o . -t 6
```

### 2) Multiqc analysis:
I used **Multiqc.sh** (on Fastqc directory output, one report for all samples). Principal command: 

```{bash, eval=FALSE}
multiqc $data/* -o . 
```
\newline

### 3) Results: 

Adapters sequences are present in our reads, that's why in the next step I will remove them. 

*Ajouter captures du rapport multiqc*

## Remove adapters from reads: 

### 1) Find adapters sequences:

Adapters' sequences were found in the supplementary data of Brown *et al*, 2017.

I generated reverse complement sequences using the online tool: `http://reverse-complement.com/`

I wrote the sequences on a Fasta file: **Adapter_sequences.fa**

### 2) Use Trimmomatic to remove adapters:

I used **Trimmomatic.sh**. Principal command: 

```{bash, eval=FALSE}
java -jar $TRIMMOMATIC_JAR PE -phred33 $input_1 $input_2 $output_1_paired \
  $output_1_unpaired $output_2_paired $output_2_unpaired ILLUMINACLIP:$adapter:2:30:10\
  LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 
```

ILLUMINACLIP remove adapters, LEADING remove leading low quality bases, TRAILING remove trailing low quality bases, SLIDINGWINDOW scan the read with a 4-base sliding window and cut when the average quality per base drops below 15. 

Trimmomatic generate two types of outputs, paired sequences (R1+R2) and unpaired sequences (R1 or R2 alone). For the rest of the analysis we only keep paired sequences.

### 3) Control the reads quality after trimming:

I combined the two scripts of **Fastqc.sh** and **Multiqc.sh** to form the **Control_qual_trim.sh**.
We see on the Multiqc report that there are no (or almost no) more adapters , and that the read lengths are not as homogeneous as before. 

*Ajouter captures du rapport multiQC*

## Transcript expression quantification: 

### 1) Get the reference transcriptome:

Download the reference transcriptome of *C.elegans*: `https://www.ensembl.org/info/data/ftp/index.html`

Use the wget command with this link:  `ftp://ftp.ensembl.org/pub/release-101/fasta/caenorhabditis_elegans/cdna/Caenorhabditis_elegans.WBcel235.cdna.all.fa.gz`

Create an index using the **Transcriptome_index.sh** script

### 2) Run Salmon analysis: 

Use Salmon to quantify the expression of transcripts in each sample:

Run salmon on experimental data using **Salmon.sh**. Principal command: 

```{bash, eval=FALSE}
salmon quant -i $data/index_transcriptome -l A \
         -1 $input_1 \
         -2 $input_2 \
         -p 8 --validateMappings -o $quants/${name}_quant
```

### 3) Generate a Multiqc report with Salmon output data: 

Use the **Multiqc_after_salmon.sh** script. 

*Ajouter captures du rapport multiqc*

## Evaluate the impact of development: 

### 1) Install RAPTOR and wormRef on R: 

```Bash
BiocManager::install("limma")
devtools::install_github("LBMC/RAPToR", build_vignettes = TRUE) devtools::install_github("LBMC/wormRef")
```

read vignette : 

```R
vignette("RAPToR")
```

## Compare multiqc report on subset and on complete set (Hors série): 
*Mettre les deux rapports multiQC*