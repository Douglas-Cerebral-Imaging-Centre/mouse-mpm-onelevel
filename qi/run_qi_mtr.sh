#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

i_subject_idx=0

export QUIT_EXT=NIFTI_GZ

for i_subject in ../rawdata/sub-*/; do
  ((++i_subject_idx))
  # Extract subject ID from full path
  i_subject_id=$(basename ${i_subject%/})
  i_session_idx=0
  for i_session in ${i_subject}*/; do
    ((++i_session_idx))
    # Extract session ID from full path
    i_session_id=$(basename ${i_session%/})
    
    
    mkdir -p ../derivatives/qi/outputs/mtr/${i_subject_id}/${i_session_id}/
    echo "Computing MTR for ${i_session}..."
    /data/foujer/programs/QUIT-fork/build/Source/qi mtr \
      ../derivatives/qi/inputs/mtr/${i_subject_id}/${i_session_id}/${i_subject_id}_${i_session_id}_MPM_S0_MTw_PDw.nii.gz \
      --out="../derivatives/qi/outputs/mtr/${i_subject_id}/${i_session_id}/${i_subject_id}_${i_session_id}_" \
      --mask="../derivatives/registration/modelbuild/subjectspace-resample/subject_${i_subject_idx}/DSURQE_40micron_mask_to_${i_subject_id}_${i_session_id}_echo-rms-1-4_flip-1_mt-on_MPM_degibbs_preproc.nii.gz" 
      
  done
done