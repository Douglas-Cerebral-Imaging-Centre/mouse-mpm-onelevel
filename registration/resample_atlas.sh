#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

# Goals:
# 1. Resample an atlas to a resolution that makes sense for the template that will be made
# running modelbuild on the input data. After discussions with Gabriel Devenyi, this resolution
# should be set so that SNR is still good after averaging all scans. In our case, we have 40
# scans and an original resolution of 150um isotropic. If we want to keep the same SNR after 
# averaging all the scans, we can use the formula $SNR \propto V \times \sqrt N$, with V
# the voxel volume and N the number of scans, leading to a resolutin of ~81.1 um isotropic.
# We'll use 80 um isotropic.
# 
# 2. Resample masks and labels to the same resolution

# 1. Resample atlas
ResampleImage 3 \
  ${QUARANTINE_PATH}/resources/Dorr_2008_Steadman_2013_Ullmann_2013_Richards_2011_Qiu_2016_Egan_2015_40micron/ex-vivo/DSURQE_40micron.nii.gz \
  /data/foujer/atlas/Dorr_2008_Steadman_2013_Ullmann_2013_Richards_2011_Qiu_2016_Egan_2015_80micron/DSURQE_80micron.nii.gz \
  0.08x0.08x0.08 0 4

# Resample brain mask and labels
antsApplyTransforms \
   -i ${QUARANTINE_PATH}/resources/Dorr_2008_Steadman_2013_Ullmann_2013_Richards_2011_Qiu_2016_Egan_2015_40micron/ex-vivo/DSURQE_40micron_labels.nii.gz \
   -o /data/foujer/atlas/Dorr_2008_Steadman_2013_Ullmann_2013_Richards_2011_Qiu_2016_Egan_2015_80micron/DSURQE_80micron_labels.nii.gz \
   -r /data/foujer/atlas/Dorr_2008_Steadman_2013_Ullmann_2013_Richards_2011_Qiu_2016_Egan_2015_80micron/DSURQE_80micron.nii.gz \
   -n GenericLabel 


antsApplyTransforms \
   -i ${QUARANTINE_PATH}/resources/Dorr_2008_Steadman_2013_Ullmann_2013_Richards_2011_Qiu_2016_Egan_2015_40micron/ex-vivo/DSURQE_40micron_mask.nii.gz \
   -o /data/foujer/atlas/Dorr_2008_Steadman_2013_Ullmann_2013_Richards_2011_Qiu_2016_Egan_2015_80micron/DSURQE_80micron_mask.nii.gz \
   -r /data/foujer/atlas/Dorr_2008_Steadman_2013_Ullmann_2013_Richards_2011_Qiu_2016_Egan_2015_80micron/DSURQE_80micron.nii.gz \
   -n GenericLabel 