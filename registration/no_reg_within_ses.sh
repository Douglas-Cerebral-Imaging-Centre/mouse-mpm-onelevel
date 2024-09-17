#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

# no_reg_within_ses.sh - Resample all echoes from one session into the MTw space.
# Use instead of reg_within_ses.sh if you think there was no significant motion
# within sessions.


# Define the resampled volumes and their attributes
resampled_vol_suffix=(_flip-1_mt-off_MPM _flip-1_mt-on_MPM _flip-2_mt-off_MPM)
resampled_vol_nechoes=(7 6 7)
regvol_suffix=_reg_to_preproc_MTw

# Perform the registration, looping over subjects, sessions and moving volumes
for i_subject in ../rawdata/sub-*/; do
  # Extract subject ID from full path
  i_subject_id=$(basename ${i_subject%/})

  for i_session in ${i_subject}*/; do
    # Extract session ID from full path
    i_session_id=$(basename ${i_session%/})
    i_fixed_vol=../derivatives/registration/im_for_reg_preproc/${i_subject_id}/${i_session_id}/anat/${i_subject_id}_${i_session_id}_echo-rms-1-4_flip-1_mt-on_MPM_degibbs_preproc.nii
    i_moving_vol_idx=0

    printf "Resampling %s, %s\n" ${i_subject} ${i_session_id}
    for i_resampled_vol_suffix in ${resampled_vol_suffix[@]}; do
      # Define output paths for ANTs
      output_dir=../derivatives/registration/reg_within_ses/${i_subject_id}/${i_session_id}/anat/
      mkdir -p ${output_dir}
      # Resample raw echoes
      for ((i_echo = 1; i_echo <= ${resampled_vol_nechoes[$i_moving_vol_idx]}; i_echo++)); do
        antsApplyTransforms -d 3 --verbose \
          -i ${i_session}anat/${i_subject_id}_${i_session_id}_echo-${i_echo}${i_resampled_vol_suffix}.nii.gz \
          -o ${output_dir}${i_subject_id}_${i_session_id}_echo-${i_echo}${i_resampled_vol_suffix}${regvol_suffix}.nii.gz \
          -r ${i_fixed_vol}
        # Resample degibbsed echoes
        antsApplyTransforms -d 3 --verbose\
          -i ../derivatives/mrdegibbs/${i_subject_id}/${i_session_id}/anat/${i_subject_id}_${i_session_id}_echo-${i_echo}${i_resampled_vol_suffix}_degibbs.nii.gz \
          -o ${output_dir}${i_subject_id}_${i_session_id}_echo-${i_echo}${i_resampled_vol_suffix}_degibbs${regvol_suffix}.nii.gz \
          -r ${i_fixed_vol}
      done

      # Increment moving vol
      ((i_moving_vol_idx = i_moving_vol_idx + 1))
    done

  done
done
