#Data statistics: 

## Load data matrix with: counts, abundunce (TPM) and samples information
load("/ifb/data/mydatalocal/data/salmon_matrix.RData")

## Measure coefficients of correlation between two samples: (Spearman)
cor(txi.salmon$counts, y = NULL, use = "everything", method = c("spearman"))

## Plots: 
plot(density(log1p(txi.salmon$counts))) #Density plot
log_counts <- log1p(txi.salmon$counts) #Create a variable with log1p of counts

WT <- log_counts[,1]
WT2 <- log_counts[,2]
plot(WT,WT2) #Plot WT rep1 against WT rep2 

vargenes <- apply(log_counts, 1, var) #Measure variance
avggenes <- apply(log_counts, 1, mean) #Measure mean
plot(avggenes,vargenes) #Variance is higher for less expressed transcripts compared to highly expressed ones

which.max(vargenes) #We saw a point of max variance far from the others, it refers to WBGene00001932 (his-R8)
