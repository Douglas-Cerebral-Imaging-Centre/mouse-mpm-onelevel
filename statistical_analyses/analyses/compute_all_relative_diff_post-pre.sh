#! /bin/bash

set -euo pipefail
IFS=$'\n\t'

output_dir=../derivatives/statistical_analyses/subjectwise/
qmri_maps_tocommonspace_dir=../derivatives/qi/outputs_to_commonspace/
qmri_maps_filename="_"
metrics_suffix=("MPM_R2s" "MTSat_delta" "MTSat_PD_rb1corr" "MTSat_R1")

subject_idx=0
i_subject_idx=0


for i_subject in ../rawdata/sub-*/; do
  ((++i_subject_idx))
  # Extract subject ID from full path
  i_subject_id=$(basename ${i_subject%/})
    mkdir -p ${output_dir}/${i_subject_id}
    for i_metric in ${metrics_suffix[@]}; do
      echo "Computing diff for ${i_subject_id}, ${i_metric}"
      statistical_analyses/test_retest_analysis/compute_relative_diff.sh --no-absolute \
        ${qmri_maps_tocommonspace_dir}/subject_${i_subject_idx}/${i_subject_id}_ses-postcup${qmri_maps_filename}${i_metric}.nii \
        ${qmri_maps_tocommonspace_dir}/subject_${i_subject_idx}/${i_subject_id}_ses-precup${qmri_maps_filename}${i_metric}.nii \
        ${output_dir}/${i_subject_id}/${i_subject_id}_postcup_precup_reldiff_${i_metric}.nii.gz \
        ../derivatives/registration/modelbuild/firstlevel/final-target/DSURQE_80micron_mask_to_template.nii.gz
    done
done