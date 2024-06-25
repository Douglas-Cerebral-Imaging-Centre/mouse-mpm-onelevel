#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# SETUP
module load minc-toolkit-v2 anaconda R RMINC rstudio ANTs

# Register hmri outputs to commonspace
code/statistical_analyses/workflow/register_qmrimaps_tocommonspace.sh

# Convert files to minc for use with RMINC
find derivatives/hmri_outputs_tocommonspace/*/ -iname "*.nii" -exec nii2mnc -clobber {} \;

# Register final-target mask to template
code/statistical_analyses/workflow/resample_mask_to_template.sh

# Create data matrices
Rscript code/statistical_analyses/workflow/get_data_matrices.R

# Test analysis
Rscript code/statistical_analyses/analysis/test.R

###################

# TODO:
# 1) precup vs precupretest at all metrics - cor, wcv, histograms
# 2) precup vs postcup in controls (?)
# 3) sensitivity to demyelination (pre vs post, effect of diet)
# 4) registration to templates and atlas
# 5) B1+ correction, other choices in optimization
# 6) origin of differences between test retest
# 7) comparison to histology
# 8) comparison to Jacobian determinants
