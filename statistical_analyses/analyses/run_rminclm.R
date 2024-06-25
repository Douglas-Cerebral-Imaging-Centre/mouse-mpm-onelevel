#!/usr/bin/env Rscript
library(RMINC)
library(glue)

dir.create("../derivatives/statistical_analyses/rminc_outputs/", showWarnings = FALSE)
mpm_maps <- c("MPM_R2s", "MTSat_delta", "MTSat_PD_rb1corr", "MTSat_R1")
brain_mask <- "../derivatives/registration/modelbuild/secondlevel/final-target/DSURQE_80micron_mask_to_template.mnc"

for (i_mpm_map in mpm_maps) {
   # Get whole csv file
   csv_file_content_df <- read.csv(glue("../derivatives/statistical_analyses/rminc_inputs/rminc_input_{i_mpm_map}.csv"))
   
   # Test pre-vs-post diet
   pre_post_df <- csv_file_content_df[csv_file_content_df$ExperimentGroup == "Cuprizone_3weeks", ]
   str(pre_post_df)
   pre_post_lm <- mincLm(Filename ~ TimeToDiet, pre_post_df, mask=brain_mask)
   print(pre_post_lm)
   mincWriteVolume(pre_post_lm, glue("../derivatives/statistical_analyses/rminc_outputs/pre_vs_post_cuprizone_lm_tvalue-TimeToDietpre_{i_mpm_map}.mnc"), "tvalue-TimeToDietpre")

   #pre_post_lmer <- mincLmer(Filename ~ TimeToDiet * MouseSex + (1|MouseID), pre_post_df, mask=brain_mask)
   #print(pre_post_lmer)
   #mincWriteVolume(pre_post_lmer, glue("../derivatives/statistical_analyses/rminc_outputs/pre_vs_post_cuprizone_lmer_tvalue-TimeToDietpre_{i_mpm_map}.mnc"), "tvalue-TimeToDietpre")
   # Testing difference
   # Compute maps difference 
   # Filename ~ ExperimentGroup * MouseSex 

   # Try with less smoothing
   # 

   # Test control-vs-cup in post time point
   control_cup_df <- csv_file_content_df[csv_file_content_df$TimeToDiet == "post", ]
   str(control_cup_df)
   control_cup_lm <- mincLm(Filename ~ ExperimentGroup, control_cup_df, mask=brain_mask)
   print(control_cup_lm)
   mincWriteVolume(control_cup_lm, glue("../derivatives/statistical_analyses/rminc_outputs/control_vs_diet_cuprizone_lm_tvalue-ExperimentGroupCuprizone_3weeks{i_mpm_map}.mnc"), "tvalue-ExperimentGroupCuprizone_3weeks")
}