#! /bin/bash

# Remove fmap lines (we don't convert B0 maps)
sed '/fmap/d' $1 >$2

# Remove all CUPUnderscore
sed -e 's/MCHUnderscore//g' -i $2
sed -e 's/UnderscoreB//g' -i $2
sed -e 's/Underscore//g' -i $2

# Loop through sessions indices and assign proper tags based on experiment notes
# Specify the CSV file name

# For each line in bids_conversion/scan_indices.csv, do the appropriate substitution
while IFS=',' read -r _ subject_id session_id structural_scanidx mpm_pdw_scanidx mpm_mtw_scanidx mpm_t1w_scanidx flip1_TB1DAM_scanidx flip2_TB1DAM_scanidx; do
    sed -i "s/${subject_id},${session_id},${structural_scanidx},1,anat,,,,,,,,,,,,,/${subject_id},${session_id},${structural_scanidx},1,anat,,,,,,,,,,,PDw,,/" $2
    sed -i "s/${subject_id},${session_id},${mpm_pdw_scanidx},1,etc,,,,,,,,,,,,,/${subject_id},${session_id},${mpm_pdw_scanidx},1,anat,,,,,,,,1,off,,MPM,,/" $2
    sed -i "s/${subject_id},${session_id},${mpm_mtw_scanidx},1,etc,,,,,,,,,,,,,/${subject_id},${session_id},${mpm_mtw_scanidx},1,anat,,,,,,,,1,on,,MPM,,/" $2
    sed -i "s/${subject_id},${session_id},${mpm_t1w_scanidx},1,etc,,,,,,,,,,,,,/${subject_id},${session_id},${mpm_t1w_scanidx},1,anat,,,,,,,,2,off,,MPM,,/" $2
    sed -i "s/${subject_id},${session_id},${flip1_TB1DAM_scanidx},1,anat,,,,,,,,,,,,,/${subject_id},${session_id},${flip1_TB1DAM_scanidx},1,fmap,,,,,,,,1,,,TB1DAM,,/" $2
    sed -i "s/${subject_id},${session_id},${flip2_TB1DAM_scanidx},1,anat,,,,,,,,,,,,,/${subject_id},${session_id},${flip2_TB1DAM_scanidx},1,fmap,,,,,,,,2,,,TB1DAM,,/" $2
done < "bids_conversion/scan_indices.csv"

# Remove lines that were not updated - presumably these are acquired images that were re-acquired
sed -i "/,,,,,,,,,,,,,/d" $2

# Study specific modifications
sed -i "s/XMP010,3/XMP010,1/" $2

