#! /bin/bash

set -euo pipefail
IFS=$'\n\t'

output_dir=../derivatives/statistical_analyses/subjectwise/
qmri_maps_tocommonspace_dir=../derivatives/qi/outputs_to_commonspace/
metrics_suffix=("MPM_R2s" "MTSat_delta" "MTSat_PD_rb1corr" "MTSat_R1")

i_subject_idx=0


for i_subject in ../rawdata/sub-*/; do
  ((++i_subject_idx))
  # Extract subject ID from full path
  i_subject_id=$(basename ${i_subject%/})
    mkdir -p ${output_dir}/${i_subject_id}
    for i_metric in ${metrics_suffix[@]}; do
      echo "Computing diff for ${i_subject_id}, ${i_metric}"
      fslmaths ${qmri_maps_tocommonspace_dir}/subject_${i_subject_idx}/${i_subject_id}_ses-postcup_${i_metric}.nii \
        -sub ${qmri_maps_tocommonspace_dir}/subject_${i_subject_idx}/${i_subject_id}_ses-precup_${i_metric}.nii \
        ${output_dir}/${i_subject_id}/${i_subject_id}_postcup_precup_diff_${i_metric}.nii.gz
    done
done