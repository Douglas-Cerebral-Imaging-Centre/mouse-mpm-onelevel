#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

# preprocess_im_for_reg.sh - Preprocess root-mean-squared images. Will be used
# for registration. All inputs and outputs are hardcoded for now.
#
# - Inputs:
#   - Root-Mean-Squared data
# - Code summary:
#   - Iterate over all sessions to run mouse-preprocessing-v8_pv6_brkraw_nifti.sh 
#     on MPM root-mean-squared echoes.
# - Outputs:
#    - All preprocessed RMS are stored in ../derivatives/im_for_reg_preproc/
#      following the BIDS folder structure and with _preproc suffix

for i_subject in ../derivatives/registration/im_for_reg/sub-*/; do
  for i_session in ${i_subject}/*/; do
    # Preprocess all MPM RMS
    for i_im_for_reg in ${i_session}/anat/*MPM_degibbs.nii.gz; do
      # Create output file name by adding _preproc suffix, changing extension for .mnc, and changing derivatives directory
      output_fname=$(dirname ${i_im_for_reg})/$(basename ${i_im_for_reg} .nii.gz)_preproc.mnc
      output_fname=${output_fname//\/im_for_reg\//\/im_for_reg_preproc\/}
      if [[ ! -s "${output_fname}" ]]; then
        mkdir -p $(dirname ${output_fname})
        mouse-preprocessing-v8_pv6_brkraw_nifti.sh ${i_im_for_reg} "${output_fname}"
      fi
    done
  done
done
# Convert back to nifti (for later ANTs call)
find ../derivatives/registration/im_for_reg_preproc/ -iname *.mnc -exec mnc2nii {} \;
