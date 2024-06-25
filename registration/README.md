# registration
Collection of scripts to perform registration. 

:computer: Change `registration/run_modelbuild.sh` and `registration/reg_finaltargetmask_to_scan.sh`
based on your study design. If more than one session for some subjects, change `modelbuild.sh` for `twolevel_modelbuild.sh` in
`registration/run_modelbuild.sh`, and `subjectspace_resample.sh` for `twolevel_subjectspace_resample.sh` in `registration/reg_finaltargetmask_to_scan.sh`.

Run the scripts in this order:
```
# Load required modules
module load ANTs minc-toolkit-v2 minc-toolkit-extras

# Register within session
registration/reg_within_ses.sh

# Register between sessions and create template
registration/run_modelbuild.sh

# Back-propagate brain mask from atlas to subject space
registration/reg_finaltargetmask_to_scan.sh
```