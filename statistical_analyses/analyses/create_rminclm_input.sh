#! /bin/bash
set -euo pipefail
IFS=$'\n\t'
mpm_maps=( _MPM_R2s \
           _MTSat_delta \
           _MTSat_PD_rb1corr \
           _MTSat_R1 \
         )

# Define the input CSV file
original_csv_file="../sourcedata/cuprizone_ids.csv"

# Create output folder
mkdir -p ../derivatives/statistical_analyses/rminc_inputs/

# Find the index of the MouseID column
mouseid_col_index=$(head -1 "$original_csv_file" | tr ',' '\n' | grep -n -x "MouseID" | cut -d ':' -f 1)

# Check if the column exists
if [ -z "$mouseid_col_index" ]; then
  echo "Column MouseID not found"
  exit 1
fi

original_csv_header=$(head -n 1 "$original_csv_file")
csv_header=${original_csv_header},TimeToDiet,Filename

for i_mpm_map in ${mpm_maps[@]}; do
i_csv_output=../derivatives/statistical_analyses/rminc_inputs/rminc_input${i_mpm_map}.csv
echo $csv_header > ${i_csv_output}

# Loop through each line of the CSV file, skipping the header
tail -n +2 "$original_csv_file" | while IFS= read -r line
do
  # Extract the value corresponding to the column header
  i_mouseid=$(echo "$line" | cut -d ',' -f "$mouseid_col_index")
  
  # Extract mouse number with no upfront zeros
  i_mouseidx=$(echo "$i_mouseid" | tr -d -c '[:digit:]')
  i_mouseidx=$(echo "$i_mouseidx" | sed 's/^0*//')

  # Add mpm map filename at the end of the line
  precup_line="$line,pre,../derivatives/qi/outputs_to_commonspace/subject_${i_mouseidx}/sub-${i_mouseid}_ses-precup${i_mpm_map}_smoothed_fwhm200um_blur.mnc"
  echo "$precup_line" >> "$i_csv_output"
  postcup_line="$line,post,../derivatives/qi/outputs_to_commonspace/subject_${i_mouseidx}/sub-${i_mouseid}_ses-postcup${i_mpm_map}_smoothed_fwhm200um_blur.mnc"
  echo "$postcup_line" >> "$i_csv_output"
done
done