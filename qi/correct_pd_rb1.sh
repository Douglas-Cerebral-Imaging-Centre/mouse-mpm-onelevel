#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

i_subject_idx=0

for i_subject in ../rawdata/sub-*/; do
  ((++i_subject_idx))
  i_session_idx=0
  # Extract subject ID from full path
  i_subject_id=$(basename ${i_subject%/})
  # Loop over all sessions within each subject
  for i_session in ${i_subject}*/; do
    echo "Correcting PD for B1- for $i_session"
    ((++i_session_idx))
    # Extract session ID from full path
    i_session_id=$(basename ${i_session%/})
    
    # Divide by TB1 (we assume TB1 and RB1 are the same for a transmit-receive coil; reciprocity principle)
    ImageMath 3 ../derivatives/qi/outputs/mtsat/${i_subject_id}/${i_session_id}/${i_subject_id}_${i_session_id}_MTSat_PD_rb1corr.nii.gz / \
      ../derivatives/qi/outputs/mtsat/${i_subject_id}/${i_session_id}/${i_subject_id}_${i_session_id}_MTSat_PD.nii.gz \
      ../derivatives/tb1/${i_subject_id}/${i_session_id}/fmap/${i_subject_id}_${i_session_id}_acq-calcpul_flip-1_TB1map_to_MTw_smoothed.nii.gz

    # Mask after division
    ImageMath 3 ../derivatives/qi/outputs/mtsat/${i_subject_id}/${i_session_id}/${i_subject_id}_${i_session_id}_MTSat_PD_rb1corr.nii.gz m \
      ../derivatives/qi/outputs/mtsat/${i_subject_id}/${i_session_id}/${i_subject_id}_${i_session_id}_MTSat_PD_rb1corr.nii.gz \
      ../derivatives/registration/modelbuild/subjectspace-resample/subject_${i_subject_idx}/DSURQE_40micron_mask_to_${i_subject_id}_${i_session_id}_echo-rms-1-4_flip-1_mt-on_MPM_degibbs_preproc.nii.gz

  done
done
