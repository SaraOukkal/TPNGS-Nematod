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


