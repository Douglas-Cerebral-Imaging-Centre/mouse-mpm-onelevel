#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

# Degibbs all MPM individual echoes
# Require mrtrix3 dev branch for 3D capability

for i_anat_im in ../rawdata/*/*/anat/*MPM.nii.gz; do
  output_fname=${i_anat_im//rawdata/derivatives\/mrdegibbs}
  output_fname=$(dirname ${output_fname})/$(basename ${output_fname} .nii.gz)_degibbs.nii.gz
  mkdir -p $(dirname ${output_fname})
  mrdegibbs ${i_anat_im} ${output_fname} -mode 3d
done
