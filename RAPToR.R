#Assess the impact of development: 

##Install RAPToR and wormRef using devtools: 
BiocManager::install("limma")
devtools::install_github("LBMC/RAPToR", build_vignettes = TRUE)
devtools::install_github("LBMC/wormRef")

##Load the data matrix: 
load("/ifb/data/mydatalocal/data/salmon_matrix.RData")

##Load wormRef: 
vignette("RAPToR")
library(RAPToR)
#Choose the right dataset of wormRef depending on the developmental stage of your samples
(plot_refs("wormRef"))
#Use n.Inter parameter above 500 for better resolution
#If it's too high RAPToR takes more time to run and uses more RAM memory 
ref_larv <- prepare_refdata("Cel_larv_YA", "wormRef", n.inter = 500) 
names(ref_larv)

##Run RAPToR: 
ae_data <- ae(samp = salmon_matrix$tpm,                         #input gene expression matrix
                          refdata = ref_larv$interpGE,            #interpolated gene expression
                          ref.time_series = ref_larv$time.series) #Reference time series  

#Plot results: 
print(salmon_matrix$pdata$sample_name)
strain_groups <- factor(salmon_matrix$pdata$strain, 
                        levels = c("WT", "alg-2(ok304) II", "alg-5(ram2) I"))
boxplot(ae_data$age.estimates[,1]~strain_groups, 
        main = "Estimated age of each condition", 
        ylab = "Estimated age (Hours post-hatching)", 
        xlab = "Samples", col = "lightblue", border = "darkblue", boxwex = 0.5)
points(ae_data$age.estimates[,1]~strain_groups, lwd=2, col = c("firebrick", "coral", "green"))

##function to get the indices/GExpr of the reference matching sample age estimates.

getrefTP <- function(ref, ae_obj, ret.idx = T){
  idx <- sapply(ae_obj$age.estimates[,1], function(t) which.min(abs(ref$time.series - t)))
  if(ret.idx)
    return(idx) 
  return(ref$interpGE[,idx])}

getrefTP(ref_larv, ae_data) #Run getrefTP

## function to compute the reference changes and the observed changes 
refCompare <- function(samp, ref, ae_obj, fac){
  ovl <- format_to_ref(samp, getrefTP(ref_larv, ae_data, ret.idx = F))
  lm_samp <- lm(t(ovl$samp)~fac)
  lm_ref <- lm(t(ovl$ref)~fac) #Operates a statistical test, but we only keep the log2 fold change.
  return(list(samp=lm_samp, ref=lm_ref, ovl_genelist=ovl$inter.genes)) }

log1p_samp <- log1p(salmon_matrix$tpm)

rc <- refCompare(log1p_samp, ref_larv, ae_data, strain_groups)

##Measure the correlation factors between ref and samples:
print(rc$samp$coefficients[, 1:5]) #Coefficients are log1p Fold Change 
print(rc$ref$coefficients[, 1:5])

###Coeff of correlation for all genes
cor(rc$samp$coefficients[2, ], rc$ref$coefficients[2, ])
cor(rc$samp$coefficients[3, ], rc$ref$coefficients[3, ])

###Coeff of correlation for DE genes: 

cor(rc$samp$coefficients[2, (rc$ovl_genelist %in% alg2_UR) | (rc$ovl_genelist %in% alg2_DR)], 
    rc$ref$coefficients[2, (rc$ovl_genelist %in% alg2_UR) | (rc$ovl_genelist %in% alg2_DR)]) #0.7321606

cor(rc$samp$coefficients[2, (rc$ovl_genelist %in% alg5_UR) | (rc$ovl_genelist %in% alg5_DR)], 
    rc$ref$coefficients[2, (rc$ovl_genelist %in% alg5_UR) | (rc$ovl_genelist %in% alg5_DR)]) #0.1953245

##Plots: 
### Create variables with UR and DR gene names:
alg2_UR <- rownames(res_alg2_UR) #
alg2_DR <- rownames(res_alg2_DR) 

alg5_UR <- rownames(res_alg5_UR) 
alg5_DR <- rownames(res_alg5_DR) 

col_alg2 <- rep("grey", length(rc$ovl_genelist))
col_alg2[rc$ovl_genelist %in% alg2_UR] <- "red"
col_alg2[rc$ovl_genelist %in% alg2_DR] <- "darkblue"

col_alg5 <- rep("grey", length(rc$ovl_genelist))
col_alg5[rc$ovl_genelist %in% alg5_UR] <- "red"
col_alg5[rc$ovl_genelist %in% alg5_DR] <- "darkblue"

###Do square plots: 
par(pty = 's')

###ALg2 plot:
plot(rc$samp$coefficients[2,], rc$ref$coefficients[2,], main = "\nlog1p FC Alg2 vs Reference\n r = 0.611", 
     xlab = "Alg2 log1pFC", ylab = "Reference log1p FC", pch = 6, col=col_alg2, 
     ylim=c(-5,5), xlim=c(-5,5), cex = 0.3)

legend('topleft', legend = c('UR genes', 'Not DE genes', 'DR genes' ), col = c('red', 'grey','darkblue'), pch = 6, pt.cex = 1,5, box.lty=0, cex=0.5)

###Alg5 plot
plot(rc$samp$coefficients[3,], rc$ref$coefficients[3,], main = "\nlog1p FC Alg5 ram2 vs Reference\n r = 0.093", 
     xlab = "Alg5 log1pFC", ylab = "Reference log1p FC", pch = 6, col=col_alg5 , 
     ylim=c(-5,5), xlim=c(-5,5), cex = 0.3 )

legend('topleft', legend = c('UR genes', 'Not DE genes', 'DR genes' ), col = c('red', 'grey','darkblue'), pch = 6, pt.cex = 1, box.lty=0, cex=0.5)

sel <- col_alg5!= "grey" 
points(rc$samp$coefficients[3,sel], rc$ref$coefficients[3,sel], cex = 0.3, pch = 6,col=col_alg5[sel]) #Put DE genes on top of others on the plot
