# Differential expression analyses:

library("DESeq2")

##Load the data matrix: 
load("/ifb/data/mydatalocal/data/salmon_matrix.RData")

##Prepare matrix: 
salmon_matrix$counts <- round(salmon_matrix$counts) #Convert all numbers into finite numbers 

salmon_matrix$pdata$strain <- factor(salmon_matrix$pdata$strain, 
                        levels = c("WT", "alg-2(ok304) II", "alg-5(ram2) I")) #Convert strains into factors

##Run DESeq: 
DESeq_data <- DESeqDataSetFromMatrix(countData = salmon_matrix$counts,
                              colData = salmon_matrix$pdata,
                              design= ~ strain)

dds <- DESeq(DESeq_data)
resultsNames(dds)

##Stock results for each comparison in a variable: 

res_alg2 <- results(dds, name="strain_alg.2.ok304..II_vs_WT", alpha=0.05)
head(res_alg2)
res_alg5 <- results(dds, name="strain_alg.5.ram2..I_vs_WT", alpha=0.05)
head(res_alg5)

##Order results by pvalue
res_alg2_ordered <- res_alg2[order(res_alg2$pvalue),]
res_alg5_ordered <- res_alg5[order(res_alg5$pvalue),]

summary(res_alg2_ordered)
summary(res_alg5_ordered)

## Count the number of differentially expressed genes: 
sum(res_alg2_ordered$padj < 0.05, na.rm=TRUE)
sum(res_alg5_ordered$padj < 0.05, na.rm=TRUE)

##Plot results (volcano plot):
plotMA(res_alg2_ordered, ylim=c(-10,10), main = "\nAlg2 mutant vs WT\n(lFC>0 = UR genes, LFC<0 = DR genes)\n")
plotMA(res_alg5_ordered, ylim=c(-10,10), main = "\nAlg5 mutant vs WT\n(lFC>0 = UR genes, LFC<0 = DR genes)\n")

##Save data into csv: 
### DE genes Alg2: 
res_alg2_UR <- subset(res_alg2_ordered, padj < 0.05 & log2FoldChange > 0)
res_alg2_DR <- subset(res_alg2_ordered, padj < 0.05 & log2FoldChange < 0)
nrow(res_alg2_UR)

write.table(cbind(rownames(res_alg2_UR)), row.names = F, col.names = F, quote = F,
            file="/ifb/data/mydatalocal/data/alg2_UR_genes.csv")
write.table(cbind(rownames(res_alg2_DR)), row.names = F, col.names = F, quote = F,
            file="/ifb/data/mydatalocal/data/alg2_DR_genes.csv")

###DE genes Alg5: 
res_alg5_UR <- subset(res_alg5_ordered, padj < 0.05 & log2FoldChange > 0)
res_alg5_DR <- subset(res_alg5_ordered, padj < 0.05 & log2FoldChange < 0)

write.table(cbind(rownames(res_alg5_UR)), row.names = F, col.names = F, quote = F,
          file="/ifb/data/mydatalocal/data/alg5_UR_genes.csv")
write.table(cbind(rownames(res_alg5_DR)), row.names = F, col.names = F, quote = F,
            file="/ifb/data/mydatalocal/data/alg5_DR_genes.csv")

###All genes: 
write.table(cbind(rownames(res_alg2_ordered)), row.names = F, col.names = F, quote = F,
            file="/ifb/data/mydatalocal/data/all_genes.csv")

