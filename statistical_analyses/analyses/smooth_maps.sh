#! /bin/bash
set -euo pipefail
IFS=$'\n\t'
mpm_maps_to_smooth=( _MPM_R2s \
                    _MTSat_delta \
                    _MTSat_PD_rb1corr \
                    _MTSat_R1 \
                    _MTR \
                    )

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
    
    
    echo "Smoothing MPM maps for ${i_session}..."
    for i_mpm_map in ${mpm_maps_to_smooth[@]}; do
      mincblur -fwhm 0.3 -verbose -clobber \
        ../derivatives/qi/outputs_to_commonspace/${i_subject_id}_${i_session_id}${i_mpm_map}.mnc \
        ../derivatives/qi/outputs_to_commonspace/${i_subject_id}_${i_session_id}${i_mpm_map}_smoothed_fwhm200um
    done
      
  done
done
