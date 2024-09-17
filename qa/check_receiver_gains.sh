#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

# This script checks if receiver gains are the same for the two B1-mapping
# and the three MPM scans.


# Function to extract receiver gain from Bruker method file
extract_receivergain () {
    local receivergain=$(grep -i '##$rg=' $1)
    local receivergain=${receivergain#*=}
    printf $receivergain
}


tail -n +2 "../sourcedata/scan_indices.csv" | while IFS=',' read -r sourcedata_folder subject_id session_id structural_scanidx flip1_TB1DAM_scanidx flip2_TB1DAM_scanidx mpm_pdw_scanidx mpm_mtw_scanidx mpm_t1w_scanidx; do
    printf "Working on sub-%s, ses-%s\n" $subject_id $session_id
    # Extract ref power from all scans (I wanted to check if they were all the same)
    flip1_TB1DAM_receivergain=$(extract_receivergain ../sourcedata/${sourcedata_folder}/${flip1_TB1DAM_scanidx}/acqp)
    flip2_TB1DAM_receivergain=$(extract_receivergain ../sourcedata/${sourcedata_folder}/${flip2_TB1DAM_scanidx}/acqp)
    mpm_pdw_receivergain=$(extract_receivergain ../sourcedata/${sourcedata_folder}/${mpm_pdw_scanidx}/acqp)
    mpm_mtw_receivergain=$(extract_receivergain ../sourcedata/${sourcedata_folder}/${mpm_mtw_scanidx}/acqp)
    mpm_t1w_receivergain=$(extract_receivergain ../sourcedata/${sourcedata_folder}/${mpm_t1w_scanidx}/acqp)
    
    # Check if all receiver gains are the same for B1 mapping
    if [[ "$flip1_TB1DAM_receivergain" == "$flip2_TB1DAM_receivergain" ]]; then
        printf "All receiver gains are the same value for B1 mapping: $flip1_TB1DAM_receivergain\n"
    else
        printf "\n\n\nWARNING: Reference powers are different within same session\n"
        printf "%f\n" $flip1_TB1DAM_receivergain $flip2_TB1DAM_receivergain
    fi

    # Check if all receiver gains are the same for MPM scans
    if [[ "$mpm_pdw_receivergain" == "$mpm_mtw_receivergain" ]] && [[ "$mpm_pdw_receivergain" == "$mpm_t1w_receivergain" ]]; then
        printf "All receiver gains are the same value for MPM scans: $mpm_pdw_receivergain\n\n"
    else
        printf "\n\n\nWARNING: Reference powers are different within same session\n"
        printf "%f\n" $mpm_pdw_receivergain $mpm_mtw_receivergain $mpm_t1w_receivergain
    fi

done