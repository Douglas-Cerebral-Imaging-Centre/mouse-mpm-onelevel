#!/usr/bin/env Rscript
library(grid)
library(tidyverse)
library(MRIcrotome)
library(RMINC)
library(magrittr) #to be able to use "%>%"
library(glue)

## HERE GOES CODE TO SETUP DATAFRAME ETC ##

anatVol <- mincArray(mincGetVolume("../derivatives/registration/modelbuild/final/average/template_sharpen_shapeupdate.mnc"))
averagemask <- mincArray(mincGetVolume("../derivatives/registration/modelbuild/final-target/DSURQE_40micron_mask_to_template.mnc"))
anatVolLow <- 1
anatVolHigh <- 4

#Here we figure out the extent of the mask, so we can use it to limit
# the FOV
# You may want to adjust these slighty buy adding/subtracting, so you don't
# quite go to the edge of the mask
dim1_begin <- min(which(averagemask == 1, arr.ind=TRUE)[,"dim1"])
dim1_end <-max(which(averagemask == 1, arr.ind=TRUE)[,"dim1"])
dim2_begin <- min(which(averagemask == 1, arr.ind=TRUE)[,"dim2"])
dim2_end <- max(which(averagemask == 1, arr.ind=TRUE)[,"dim2"])
dim3_begin <- min(which(averagemask == 1, arr.ind=TRUE)[,"dim3"])
dim3_end <- max(which(averagemask == 1, arr.ind=TRUE)[,"dim3"])

dir.create("../derivatives/statistical_analyses/rminc_outputs/wsex/", showWarnings = FALSE)
mpm_maps <- c("MPM_R2s", "MTSat_delta", "MTSat_PD_rb1corr", "MTSat_R1", "MTR")
brain_mask <- "../derivatives/registration/modelbuild/final-target/DSURQE_40micron_mask_to_template.mnc"
fdr_threshold_for_svg <- "0.2"

for (i_mpm_map in mpm_maps) {
   # Get whole csv file
   csv_file_content_df <- read.csv(glue("../derivatives/statistical_analyses/rminc_inputs/rminc_input_{i_mpm_map}.csv"))
   
   # Test pre-vs-post diet
   csv_file_content_df$Treatment <- factor(csv_file_content_df$Treatment)
   csv_file_content_df <- within(csv_file_content_df, Treatment <- relevel(Treatment, ref = "PBS"))
   model <- mincLm(Filename ~ Treatment + Sex, csv_file_content_df, mask=brain_mask)
   print(model)
   thresholds = attr(mincFDR(model, mask=brain_mask), "thresholds")
   print(thresholds)

   mincWriteVolume(model, paste0("../derivatives/statistical_analyses/rminc_outputs/wsex/tvalue-TreatmentD-AIP_",i_mpm_map,".mnc"), "tvalue-TreatmentD-AIP")
   mincWriteVolume(model, paste0("../derivatives/statistical_analyses/rminc_outputs/wsex/tvalue-TreatmentS-AIP_",i_mpm_map,".mnc"), "tvalue-TreatmentS-AIP")

   for (predictor in dimnames(thresholds)[[2]][c(-1,-2)]) {
 
      #If you want to save this to a file, uncomment next line
      svg(paste0("../derivatives/statistical_analyses/rminc_outputs/wsex/pbs_vs_",predictor,"_",i_mpm_map,"_tstatthresh-2.svg"), height = 3.1, width = 4)
      #We use a tryCatch here to keep going if there's some kind of error in a an individual plot
      tryCatch({
      #Here, we extract the thresholds from the code, and clip them to 2 digits, otherwise the plotting doesn't look good
      lowerthreshold = round(thresholds[fdr_threshold_for_svg,predictor],digits=2)
      lowerthreshold <- 2
      #Sometimes, there isn't an 0.01 threshold, when thats the case, we use the max instead, be careful to read the threshold array printed above
      upperthreshold = round(ifelse(is.na(thresholds["0.01",predictor]), max(c(max(mincArray(model, predictor)),abs(min(mincArray(model, predictor))))), thresholds["0.01",predictor]),digits=2)
      # Here is the plotting code, we do all three slice directions in one figure. This was optimized for a human brain, you may need to
      # adjust the nrow and ncol to get exactly the figure you want
      # You will also need to adjust the anatVol low and high values to correspond to good thresholds for your template
      sliceSeries(nrow = 5, ncol = 2, dimension = 2, begin = dim2_begin, end = dim2_end) %>%  
         anatomy(anatVol, low=anatVolLow, high=anatVolHigh) %>%
         addtitle("Coronal") %>%
         overlay(mincArray(model, predictor),
            low=lowerthreshold, 
            high=upperthreshold, 
            symmetric = T, alpha=0.6) %>%
         sliceSeries(nrow = 6, ncol= 2, dimension = 1, begin = dim1_begin, end = dim1_end) %>%  
         anatomy(anatVol, low=anatVolLow, high=anatVolHigh) %>%
         addtitle("Sagittal") %>%
         overlay(mincArray(model, predictor),   
            low=lowerthreshold,
            high=upperthreshold,
            symmetric = T, alpha=0.6) %>%
         sliceSeries(nrow = 5, ncol= 2, dimension = 3, begin = dim3_begin, end = dim3_end) %>% 
         anatomy(anatVol, low=anatVolLow, high=anatVolHigh) %>%
         addtitle("Axial") %>%
         overlay(mincArray(model, predictor),
            low=lowerthreshold,
            high=upperthreshold,
            symmetric = T, alpha=0.6) %>%
         legend(predictor) %>%
         draw()}, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
      #If you are saving to file, also uncomment this
      dev.off()
      }
}