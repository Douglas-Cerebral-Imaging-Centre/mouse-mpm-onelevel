# preprocessing
Collection of files to preprocess the data, for registration and eventually 
qMRI maps computation.
The scripts should be run, in this order:

```
# Load relevant modules
module load minc-toolkit-v2 minc-toolkit-extras ANTs FSL mrtrix3/dev.20230312

# Remove Gibbs ringing from all MPM echoes
preprocessing/gibbs_dering.sh

# Create images used for registration
preprocessing/create_im_for_reg.sh

# Preprocess images used for registration
preprocessing/preprocess_im_for_reg.sh
```

If you want to register the B1-map's raw data to the MPM data intra-session, e.g., because you suspect important motion, then have a look at the repository created for the cuprizone-test-retest data set. We tested B1-map's raw data preprocessing and registration there, but found out that intra-session motion was not important enough to justify it. The registration was also sometimes suboptimal.