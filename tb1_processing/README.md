# tb1_processing

The `computetb1.sh` script computes TB1 maps for each scanning session from the the acquired data. It also resamples it to the preprocessed MPM space and smoothes it. The smoothing does not seem to help for test-retest reliability. 

It essentially applies the functions from the mri-tb1 repo in loops over all sessions. 