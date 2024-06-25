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
    
    
    mkdir -p ../derivatives/qi/outputs/mtsat/${i_subject_id}/${i_session_id}/
    echo "Computing MTsat, R1, and PD map for ${i_session}..."
    /data/foujer/programs/QUIT-fork/build/Source/qi mtsat \
      ../derivatives/qi/outputs/r2s_mpm/${i_subject_id}/${i_session_id}/${i_subject_id}_${i_session_id}_MPM_S0_PDw.nii.gz \
      ../derivatives/qi/outputs/r2s_mpm/${i_subject_id}/${i_session_id}/${i_subject_id}_${i_session_id}_MPM_S0_T1w.nii.gz \
      ../derivatives/qi/outputs/r2s_mpm/${i_subject_id}/${i_session_id}/${i_subject_id}_${i_session_id}_MPM_S0_MTw.nii.gz \
      --B1="../derivatives/tb1/${i_subject_id}/${i_session_id}/fmap/${i_subject_id}_${i_session_id}_flip-1_TB1map_to_MTw_smoothed.nii.gz" \
      --out="../derivatives/qi/outputs/mtsat/${i_subject_id}/${i_session_id}/${i_subject_id}_${i_session_id}_" \
      --mask="../derivatives/registration/modelbuild/firstlevel/subject_${i_subject_idx}/subjectspace-resample/session_${i_session_idx}/DSURQE_80micron_mask_to_${i_subject_id}_${i_session_id}_echo-rms-1-4_flip-1_mt-on_MPM_degibbs_preproc.nii.gz" \
      --delta-max=30 \
      --json="qi/qi_mtsat_param.json"
      
  done
done

#--B1="../derivatives/tb1/${i_subject_id}/${i_session_id}/fmap/${i_subject_id}_${i_session_id}_flip-1_TB1map_to_MTw_smoothed.nii.gz" \