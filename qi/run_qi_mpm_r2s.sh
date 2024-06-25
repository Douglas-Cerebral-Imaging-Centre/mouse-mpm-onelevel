#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

export QUIT_EXT=NIFTI_GZ

i_subject_idx=0

for i_subject in ../rawdata/sub-*/; do
  ((++i_subject_idx))
  # Extract subject ID from full path
  i_subject_id=$(basename ${i_subject%/})
  i_session_idx=0
  for i_session in ${i_subject}*/; do
    ((++i_session_idx))
    # Extract session ID from full path
    i_session_id=$(basename ${i_session%/})
    
    
    mkdir -p ../derivatives/qi/outputs/r2s_mpm/${i_subject_id}/${i_session_id}/
    echo "Fitting R2* map for ${i_session}..."
    /data/foujer/programs/QUIT-fork/build/Source/qi mpm_r2s \
      ../derivatives/qi/inputs/r2s_mpm/${i_subject_id}/${i_session_id}/anat/${i_subject_id}_${i_session_id}_echo-1-7_flip-1_mt-off_MPM_degibbs_reg_to_preproc_MTw.nii.gz \
      ../derivatives/qi/inputs/r2s_mpm/${i_subject_id}/${i_session_id}/anat/${i_subject_id}_${i_session_id}_echo-1-7_flip-2_mt-off_MPM_degibbs_reg_to_preproc_MTw.nii.gz \
      ../derivatives/qi/inputs/r2s_mpm/${i_subject_id}/${i_session_id}/anat/${i_subject_id}_${i_session_id}_echo-1-6_flip-1_mt-on_MPM_degibbs_reg_to_preproc_MTw.nii.gz \
      --out="../derivatives/qi/outputs/r2s_mpm/${i_subject_id}/${i_session_id}/${i_subject_id}_${i_session_id}_" \
      --mask="../derivatives/registration/modelbuild/firstlevel/subject_${i_subject_idx}/subjectspace-resample/session_${i_session_idx}/DSURQE_80micron_mask_to_${i_subject_id}_${i_session_id}_echo-rms-1-4_flip-1_mt-on_MPM_degibbs_preproc.nii.gz" \
      --resids --covar \
      --json="qi/qi_mpm_r2s_param.json"
      
  done
done

    