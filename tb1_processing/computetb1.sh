#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

# computetb1.sh - Compute and preprocess tb1 maps for all sessions

i_subject_idx=0
tb1_acq_type=(_acq-calcpul _acq-sincpul)


for i_subject in ../rawdata/sub-*/; do
  ((++i_subject_idx))
  # Extract subject ID from full path
  i_subject_id=$(basename ${i_subject%/})
  i_session_idx=0
  for i_session in ${i_subject}*/; do
    for i_tb1_acq_type in ${tb1_acq_type[@]}; do
      echo "Computing B1+ map for ${i_session}..."
      ((++i_session_idx))
      # Extract session ID from full path
      i_session_id=$(basename ${i_session%/})
      mkdir -p ../derivatives/tb1/${i_subject_id}/${i_session_id}/fmap/

      # Compute B1 map
      low_flip_angle_deg=$(jq -r ".FlipAngle" ../rawdata/${i_subject_id}/${i_session_id}/fmap/${i_subject_id}_${i_session_id}${i_tb1_acq_type}_flip-1_TB1DAM.json)
      mri-tb1/computetb1dam.sh -a ${low_flip_angle_deg} \
      ../rawdata/${i_subject_id}/${i_session_id}/fmap/${i_subject_id}_${i_session_id}${i_tb1_acq_type}_flip-1_TB1DAM.nii.gz \
      ../rawdata/${i_subject_id}/${i_session_id}/fmap/${i_subject_id}_${i_session_id}${i_tb1_acq_type}_flip-2_TB1DAM.nii.gz \
      ../derivatives/tb1/${i_subject_id}/${i_session_id}/fmap/${i_subject_id}_${i_session_id}${i_tb1_acq_type}_flip-1_TB1map.nii.gz

      # Resample to preprocessed MTw space
      antsApplyTransforms \
        -i  ../derivatives/tb1/${i_subject_id}/${i_session_id}/fmap/${i_subject_id}_${i_session_id}${i_tb1_acq_type}_flip-1_TB1map.nii.gz \
        -r ../derivatives/registration/im_for_reg_preproc/${i_subject_id}/${i_session_id}/anat/${i_subject_id}_${i_session_id}_echo-rms-1-4_flip-1_mt-on_MPM_degibbs_preproc.nii \
        -o ../derivatives/tb1/${i_subject_id}/${i_session_id}/fmap/${i_subject_id}_${i_session_id}${i_tb1_acq_type}_flip-1_TB1map_to_MTw.nii.gz

      # Smooth B1 map
      mri-tb1/smoothwithmask.sh \
        -m ../derivatives/registration/modelbuild/subjectspace-resample/subject_${i_subject_idx}/DSURQE_40micron_mask_to_${i_subject_id}_${i_session_id}_echo-rms-1-4_flip-1_mt-on_MPM_degibbs_preproc.nii.gz \
        ../derivatives/tb1/${i_subject_id}/${i_session_id}/fmap/${i_subject_id}_${i_session_id}${i_tb1_acq_type}_flip-1_TB1map_to_MTw.nii.gz \
        0.5 \
        ../derivatives/tb1/${i_subject_id}/${i_session_id}/fmap/${i_subject_id}_${i_session_id}${i_tb1_acq_type}_flip-1_TB1map_to_MTw_smoothed.nii.gz
    done
  done
done

