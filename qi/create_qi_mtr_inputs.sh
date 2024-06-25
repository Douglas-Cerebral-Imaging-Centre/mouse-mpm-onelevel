#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

for i_subject in ../rawdata/sub-*/; do
  # Extract subject ID from full path
  i_subject_id=$(basename ${i_subject%/})
  for i_session in ${i_subject}*/; do
    # Extract session ID from full path
    i_session_id=$(basename ${i_session%/})

    # Merge echoes into 4D files for PDw, MTw and T1w MPM data
    echo "Merging MTw and PDw for ${i_session}"
    mkdir -p ../derivatives/qi/inputs/mtr/${i_subject_id}/${i_session_id}/anat/


    ImageMath 4 ../derivatives/qi/inputs/mtr/${i_subject_id}/${i_session_id}/${i_subject_id}_${i_session_id}_MPM_S0_MTw_PDw.nii.gz TimeSeriesAssemble \
      1 0 \
      ../derivatives/qi/outputs/r2s_mpm/${i_subject_id}/${i_session_id}/${i_subject_id}_${i_session_id}_MPM_S0_MTw.nii.gz \
      ../derivatives/qi/outputs/r2s_mpm/${i_subject_id}/${i_session_id}/${i_subject_id}_${i_session_id}_MPM_S0_PDw.nii.gz

    done
done