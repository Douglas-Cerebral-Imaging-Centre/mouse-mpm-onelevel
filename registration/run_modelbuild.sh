#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

# Run the (twolevel_)modelbuid.sh on the preprocssed MTw composite image
# from all subjects.
# Requires minc-toolkit-extas and ANTs modules.
# If you have more than 2 time points for some subjects, add the twolevel_
# prefix to all modelbuild.sh calls.

# Create output dir
output_dir=../derivatives/registration/modelbuild
mkdir -p $output_dir

input_template_file=${output_dir}/inputs_template.txt
rm -f $input_template_file
# Create subject/session/ template list
for i_subject in ../rawdata/sub-*/; do
  # Extract subject ID from full path
  i_subject_id=$(basename ${i_subject%/})
  # Loop over all sessions within each subject
  for i_session in ${i_subject}*/; do
    # Extract session ID from full path
    i_session_id=$(basename ${i_session%/})
    printf '%s/%s/,' ${i_subject_id} ${i_session_id} >> ${input_template_file}
  done
  truncate -s -1 ${input_template_file} # Remove last comma
  printf '\n' >> ${input_template_file}
done

# Create modelbuild input files
input_file=${output_dir}/inputs.txt
registration/create_modelbuild_inputfile.sh \
  ../derivatives/registration/modelbuild/inputs_template.txt \
  -p ../derivatives/registration/im_for_reg_preproc/ \
  -f anat \
  -s _echo-rms-1-4_flip-1_mt-on_MPM_degibbs_preproc.nii \
  -o ${input_file}

input_file_mask=${output_dir}/inputs_mask.txt
registration/create_modelbuild_inputfile.sh \
  ../derivatives/registration/modelbuild/inputs_template.txt \
  -p ../derivatives/registration/im_for_reg_preproc/ \
  -f anat \
  -s _echo-rms-1-4_flip-1_mt-on_MPM_degibbs_preproc_mask.nii \
  -o ${input_file_mask}

# Set qbatch options
export QBATCH_PPJ=8       # requested processors per job
export QBATCH_CHUNKSIZE=1 # commands to run per job
export QBATCH_CORES=1     # commonds to run in parallel per job

# Run modelbuild.sh
DSURQE_80micron_atlasfile=/data/foujer/atlas/Dorr_2008_Steadman_2013_Ullmann_2013_Richards_2011_Qiu_2016_Egan_2015_80micron/DSURQE_80micron.nii.gz
DSURQE_40micron_atlasfile=${QUARANTINE_PATH}/resources/Dorr_2008_Steadman_2013_Ullmann_2013_Richards_2011_Qiu_2016_Egan_2015_40micron/ex-vivo/DSURQE_40micron.nii.gz
optimized_antsMultivariateTemplateConstruction/modelbuild.sh ${input_file} --starting-target ${DSURQE_80micron_atlasfile} --final-target ${DSURQE_80micron_atlasfile} --output-dir $output_dir --walltime-linear '1:30:00' --walltime-nonlinear '9:00:00' --sharpen-type none
