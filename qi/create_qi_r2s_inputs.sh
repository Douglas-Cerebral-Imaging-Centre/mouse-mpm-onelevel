#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

folder_with_3d_data=../derivatives/registration/reg_within_ses/

for i_subject in ../rawdata/sub-*/; do
  # Extract subject ID from full path
  i_subject_id=$(basename ${i_subject%/})
  for i_session in ${i_subject}*/; do
    # Extract session ID from full path
    i_session_id=$(basename ${i_session%/})

    # Merge echoes into 4D files for PDw, MTw and T1w MPM data
    echo "Merging echoes for ${i_session}"
    mkdir -p ../derivatives/qi/inputs/r2s_mpm/${i_subject_id}/${i_session_id}/anat/


    ImageMath 4 ../derivatives/qi/inputs/r2s_mpm/${i_subject_id}/${i_session_id}/anat/${i_subject_id}_${i_session_id}_echo-1-7_flip-1_mt-off_MPM_degibbs_reg_to_preproc_MTw.nii.gz TimeSeriesAssemble \
      0.0022 0.002 \
      ${folder_with_3d_data}${i_subject_id}/${i_session_id}/anat/${i_subject_id}_${i_session_id}_echo-{1..7}_flip-1_mt-off_MPM_degibbs_reg_to_preproc_MTw.nii

    ImageMath 4 ../derivatives/qi/inputs/r2s_mpm/${i_subject_id}/${i_session_id}/anat/${i_subject_id}_${i_session_id}_echo-1-6_flip-1_mt-on_MPM_degibbs_reg_to_preproc_MTw.nii.gz TimeSeriesAssemble \
      0.0022 0.002 \
      ${folder_with_3d_data}${i_subject_id}/${i_session_id}/anat/${i_subject_id}_${i_session_id}_echo-{1..6}_flip-1_mt-on_MPM_degibbs_reg_to_preproc_MTw.nii

    ImageMath 4 ../derivatives/qi/inputs/r2s_mpm/${i_subject_id}/${i_session_id}/anat/${i_subject_id}_${i_session_id}_echo-1-7_flip-2_mt-off_MPM_degibbs_reg_to_preproc_MTw.nii.gz TimeSeriesAssemble \
      0.0022 0.002 \
      ${folder_with_3d_data}${i_subject_id}/${i_session_id}/anat/${i_subject_id}_${i_session_id}_echo-{1..7}_flip-2_mt-off_MPM_degibbs_reg_to_preproc_MTw.nii

    done
done