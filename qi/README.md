# mpm

Collection of scripts to get from preprocessed, registered MPM echoes and a B1+ map to the MPM outputs using the QUIT toolbox. Make sure that the B1+ maps were computed with the script in `../tb1_processing`.

From the `../` root folder, run the scripts in the following order:

```
qi/create_qi_r2s_inputs.sh
qi/run_qi_mpm_r2s.sh
qi/run_qi_mtsat.sh
qi/correct_pd_rb1.sh
qi/run_qi_mtr.sh
```