#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

# reg_within_ses.sh - Uses preprocessed RMS images to register all images from one session into the MTw space.


# Define the moving volumes we will register with their attributes
moving_vol_fname=(echo-rms-1-4_flip-1_mt-off_MPM_degibbs_preproc.nii echo-rms-1-4_flip-2_mt-off_MPM_degibbs_preproc.nii)
moving_vol_shortname=(PDw T1w)
accompanying_vol_suffix=(_flip-1_mt-off_MPM _flip-2_mt-off_MPM)
# Define registration options
interpolation=BSpline
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

    for i_moving_vol in ${moving_vol_fname[@]}; do
      # Define output paths for ANTs
      output_dir=../derivatives/registration/reg_within_ses/${i_subject_id}/${i_session_id}/anat/
      ants_output_prefix=${output_dir}/${moving_vol_shortname[$i_moving_vol_idx]}_to_MTw
      i_lintransform_fname=${ants_output_prefix}0GenericAffine.mat
      # Perform ANTs registration only if transform files do not exist
      if [[ ! -s ${i_lintransform_fname} ]]; then
        mkdir -p ${output_dir}
        antsRegistration_affine_SyN.sh --verbose --linear-type rigid \
          --close --skip-nonlinear --initial-transform none --no-clobber \
          --fixed-mask ../derivatives/registration/im_for_reg_preproc/${i_subject_id}/${i_session_id}/anat/${i_subject_id}_${i_session_id}_echo-rms-1-4_flip-1_mt-on_MPM_degibbs_preproc_mask.nii \
          ../derivatives/registration/im_for_reg_preproc/${i_subject_id}/${i_session_id}/anat/${i_subject_id}_${i_session_id}_${moving_vol_fname[$i_moving_vol_idx]} \
          ${i_fixed_vol} \
          $ants_output_prefix
      fi

      # Apply transforms to accompanying volumes
      for ((i_accompanying_vol = 1; i_accompanying_vol <= 7; i_accompanying_vol++)); do
        antsApplyTransforms -d 3 \
          -i ${i_session}anat/${i_subject_id}_${i_session_id}_echo-${i_accompanying_vol}${accompanying_vol_suffix[$i_moving_vol_idx]}.nii.gz \
          -t ${i_lintransform_fname} \
          -o ${output_dir}${i_subject_id}_${i_session_id}_echo-${i_accompanying_vol}${accompanying_vol_suffix[$i_moving_vol_idx]}${regvol_suffix}.nii.gz \
          -n $interpolation -r ${i_fixed_vol} --verbose
        # Apply transforms to degibbsed volumes 
        antsApplyTransforms -d 3 \
          -i ../derivatives/mrdegibbs/${i_subject_id}/${i_session_id}/anat/${i_subject_id}_${i_session_id}_echo-${i_accompanying_vol}${accompanying_vol_suffix[$i_moving_vol_idx]}_degibbs.nii.gz \
          -t ${i_lintransform_fname} \
          -o ${output_dir}${i_subject_id}_${i_session_id}_echo-${i_accompanying_vol}${accompanying_vol_suffix[$i_moving_vol_idx]}_degibbs${regvol_suffix}.nii.gz \
          -n $interpolation -r ${i_fixed_vol} --verbose
      done

      # Increment moving vol
      ((i_moving_vol_idx = i_moving_vol_idx + 1))
    done

    # Resample MT weighted echoes to preprocessed space
    output_dir=../derivatives/registration/reg_within_ses/${i_subject_id}/${i_session_id}/anat/
    # Loop over all echoes
    for i_echo in {1..6}; do
      # Resample raw echoes
      antsApplyTransforms -d 3 --verbose -n $interpolation \
        -i ${i_session}anat/${i_subject_id}_${i_session_id}_echo-${i_echo}_flip-1_mt-on_MPM.nii.gz \
        -o ${output_dir}${i_subject_id}_${i_session_id}_echo-${i_echo}_flip-1_mt-on_MPM${regvol_suffix}.nii.gz \
        -r ${i_fixed_vol}
      # Resample to degibbsed echoes
      antsApplyTransforms -d 3 --verbose -n $interpolation \
        -i ../derivatives/mrdegibbs/${i_subject_id}/${i_session_id}/anat/${i_subject_id}_${i_session_id}_echo-${i_echo}_flip-1_mt-on_MPM_degibbs.nii.gz \
        -o ${output_dir}${i_subject_id}_${i_session_id}_echo-${i_echo}_flip-1_mt-on_MPM_degibbs${regvol_suffix}.nii.gz \
        -r ${i_fixed_vol}
    done

  done
done
