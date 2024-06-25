#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

# Back-propagate atlas mask to individual MT-weighted preprocessed space
optimized_antsMultivariateTemplateConstruction/subjectspace_resample.sh \
  --resample-input /data/foujer/atlas/Dorr_2008_Steadman_2013_Ullmann_2013_Richards_2011_Qiu_2016_Egan_2015_80micron/DSURQE_80micron_mask.nii.gz \
  --resample-input-space final-target \
  --output-dir ../derivatives/registration/modelbuild/ \
  ../derivatives/registration/modelbuild/inputs.txt

# Back-propagate atlas mask to individual B1 map space
# Create file for target space
output_dir=../derivatives/registration/modelbuild/
target_space=${output_dir}/b1_space.txt
registration/create_modelbuild_inputfile.sh \
  ../derivatives/registration/modelbuild/inputs_template.txt \
  -p ../rawdata/ \
  -f fmap \
  -s _flip-1_TB1DAM.nii \
  -o ${target_space}

optimized_antsMultivariateTemplateConstruction/subjectspace_resample.sh \
  --resample-input /data/foujer/atlas/Dorr_2008_Steadman_2013_Ullmann_2013_Richards_2011_Qiu_2016_Egan_2015_80micron/DSURQE_80micron_mask.nii.gz \
  --resample-input-space final-target \
  --output-dir ../derivatives/registration/modelbuild/ \
  --target-space ${target_space} \
  ../derivatives/registration/modelbuild/inputs.txt
