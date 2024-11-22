# statistical_analyses
Collection of scripts to prepare the MPM maps and run voxel-wise statistical analyses. 
Statistical analyses should be tailored to your project hypotheses. 
You can check the [analyses](./analyses) folder for examples.

The code should be run in this order
```
# SETUP
module load minc-toolkit-v2 anaconda R RMINC ANTs

# Register qi outputs to commonspace
statistical_analyses/workflow/register_qimpmmaps_tocommonspace.sh

# Convert files to minc for use with RMINC
find ../derivatives/qi/outputs_to_commonspace/ -iname "*.nii.gz" -exec gunzip -kfv {} \;
find ../derivatives/qi/outputs_to_commonspace/ -iname "*.nii" -exec nii2mnc -clobber {} \;

# Register final-target mask to template
statistical_analyses/workflow/resample_mask_to_template.sh

# Run voxel-wise analyses; see analyses folder for examples.
```
