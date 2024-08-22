# statistical_analyses
Collection of scripts to run the following statistical analyses on the MPM maps and DBM jacobians:
* Test-retest metrics (implemented)
* Effect of cuprizone diet (to be implemented)
    * Control vs cuprizone, post diet
    * Pre vs post diet in cuprizone group

The code should be run in this order
```
# SETUP
module load minc-toolkit-v2 anaconda R RMINC ANTs

# Register qi outputs to commonspace
statistical_analyses/workflow/register_qimpmmaps_tocommonspace.sh

# Convert files to minc for use with RMINC
find ../derivatives/qi/outputs_to_commonspace/ -iname "*.nii.gz" -exec gunzip -kfv {} \;
find ../derivatives/qi/outputs_to_commonspace/ -iname "*.nii" -exec nii2mnc -clobber {} \;
find ../derivatives/registration/modelbuild/final/average/ -iname "*.nii.gz" -exec gunzip -kfv {} \;
find ../derivatives/registration/modelbuild/final/average/ -iname "*.nii" -exec nii2mnc -clobber {} \;

# Register final-target mask to template
statistical_analyses/workflow/resample_mask_to_template.sh

# Run analysis; see analyses folder for examples.
```
