# bids_conversion
The scripts in this folder were used together with [brkraw](https://github.com/BrkRaw/brkraw) to convert the Bruker raw data to the MPM BIDS format. To use them, first, rsync all Bruker raw data to `../../sourcedata/`. 

:computer: You will then need to modify the files:
* `bids_conversion/modify_csv.sh`
* `bids_conversion/scan_indices.csv`.

After proper modifications were made, run the following from the root code directory (`../`):

```bash
module load brkraw
brkraw bids_helper ../sourcedata/ ../sourcedata/bids_helper -j
bids_conversion/modify_csv.sh ../sourcedata/bids_helper.csv ../sourcedata/bids_helper_modif.csv
brkraw bids_convert ../sourcedata ../sourcedata/bids_helper_modif.csv -j ../sourcedata/bids_helper.json -o ../rawdata
```
