#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

# create_im_for_reg.sh - Compute root-mean-square (RMS) of raw data echoes or
# flip angles. The RMS will later be pre-processed and used for registration.
#
# - Inputs:
#   - MPM raw data 
#   - Raw data tha will be used to compute B1+ with the Double Angle Method
#   - echoes_for_rms: MPM echoes used to compute Root-Mean-Square (RMS) 
# - Code summary:
#   - Iterate over all sessions to
#     - Compute RMS of echoes_for_rms of MPM data
#     - Compute RMS of both flip angle from B1+ Double Angle Method 
# - Outputs:
#    - All RMS are stored in ../derivatives/im_for_reg/ following the BIDS folder
#      structure and with appropriate filename


echoes_for_rms="[1-4]"
for i_subject in ../rawdata/sub-*/; do
  # Extract subject ID from full path
  i_subject_id=$(basename ${i_subject%/})
  # Loop over all sessions within each subject
  for i_session in ${i_subject}*/; do
    echo "Computing RMS images for registration for $i_session"
    # Extract session ID from full path
    i_session_id=$(basename ${i_session%/})
    # Loop over all MPM data sets
    for i_flip_idx in {1..2}; do
      for i_mt_state in on off; do
        if [ $i_flip_idx = 2 ] && [ $i_mt_state = on ]; then
          continue
        else
          # Create root-mean-square (RMS) of first MPM echoes
          rms_output_prefix=../derivatives/registration/im_for_reg/${i_subject_id}/${i_session_id}/anat/${i_subject_id}_${i_session_id}_echo-rms-1-4_flip-${i_flip_idx}_mt-${i_mt_state}_MPM_degibbs
          if [[ -s "${rms_output_prefix}.nii.gz" ]]; then
            echo "File exists, skipping"
            continue
          else
            output_path=$(dirname ${rms_output_prefix})
            mkdir -p $output_path
            preprocessing/compute_rms.sh $rms_output_prefix \
              ../derivatives/mrdegibbs/${i_subject_id}/${i_session_id}/anat/${i_subject_id}_${i_session_id}_echo-${echoes_for_rms}_flip-${i_flip_idx}_mt-${i_mt_state}_MPM_degibbs.nii.gz
          fi
        fi
      done
    done
  done
done
