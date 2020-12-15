#Import transcript level abundance estimates

## Install RAPToR et wormRef to get Transcripts ID et Gene ID from wormRef:
BiocManager::install("limma")
devtools::install_github("LBMC/RAPToR", build_vignettes = TRUE)
devtools::install_github("LBMC/wormRef")
library("wormRef")

#Load files: 
dir <- "/ifb/data/mydatalocal/data/quantifications" #Directory path
SRR <- list("SRR5564855","SRR5564856","SRR5564857", "SRR5564864", "SRR5564865", "SRR5564866", "SRR5564867", "SRR5564868", "SRR5564869")
files <- file.path(dir, paste0(SRR,"_quant"), "quant.sf") #Filenames
sample_names <- read.table(file = "/ifb/data/mydatalocal/data/sample_names.txt",header = T,sep = ",")
names(files) <- (sample_names$sample_name)
print(files)

## Use tximport: 
library("tximport")
tx2gene = wormRef::Cel_genes[, c("transcript_name", "wb_id")] #load transcript IDs and Gene IDs from wormRef
txi.salmon <- tximport(files, type = "salmon", tx2gene = tx2gene)
head(txi.salmon$counts)
dim(txi.salmon$counts)

salmon_matrix <- list(counts = txi.salmon$counts, tpm = txi.salmon$abundance, pdata = sample_names)
save(salmon_matrix, file =  "/ifb/data/mydatalocal/data/salmon_matrix.RData")
load("/ifb/data/mydatalocal/data/salmon_matrix.RData")
