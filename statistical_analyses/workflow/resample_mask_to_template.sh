#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

# Define paths
final_target_mask=${QUARANTINE_PATH}/resources/Dorr_2008_Steadman_2013_Ullmann_2013_Richards_2011_Qiu_2016_Egan_2015_40micron/ex-vivo/DSURQE_40micron_mask.nii.gz
final_target=${QUARANTINE_PATH}/resources/Dorr_2008_Steadman_2013_Ullmann_2013_Richards_2011_Qiu_2016_Egan_2015_40micron/ex-vivo/DSURQE_40micron_mask.nii.gz
final_target_dir=../derivatives/registration/modelbuild/final-target/
template=../derivatives/registration/modelbuild/final/average/template_sharpen_shapeupdate.nii.gz

# Apply transforms from modelbuild to final target
antsApplyTransforms -d 3 -i ${final_target} -r ${template} -o ${final_target_dir}/DSURQE_40micron_to_template.nii.gz -n BSpline -v \
  -t [${final_target_dir}/to_target_0GenericAffine.mat,1] \
  -t ${final_target_dir}/to_target_1InverseWarp.nii.gz

antsApplyTransforms -d 3 -i ${final_target_mask} -r ${template} -o ${final_target_dir}/DSURQE_40micron_mask_to_template.nii.gz -n GenericLabel -v \
  -t [${final_target_dir}/to_target_0GenericAffine.mat,1] \
  -t ${final_target_dir}/to_target_1InverseWarp.nii.gz

# Convert to minc files for Rminc
gunzip -kf ${final_target_dir}/DSURQE_40micron_to_template.nii.gz
gunzip -kf ${final_target_dir}/DSURQE_40micron_mask_to_template.nii.gz
nii2mnc -clobber ${final_target_dir}/DSURQE_40micron_to_template.nii
nii2mnc -clobber ${final_target_dir}/DSURQE_40micron_mask_to_template.nii
