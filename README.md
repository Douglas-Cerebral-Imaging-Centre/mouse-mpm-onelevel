# README for the mousempm repository
General scripts to analyze the MPM data, organized by subfolders.
Some parts must be adapted to your specific project. They are identified with a :computer: in the READMEs text.

## Data and code organization
We try to follow BIDS standards. To set up a directory for a project:
1. Create an empty directory to contain all the code and data for your project, which we will call here `<project_dir>`
2. Put all your Bruker raw data into `<project_dir>/sourcedata/`
3. Clone this repository into `<project_dir>/code`
4. :computer: Make the modifications required to the project-specific parts. I advise creating a branch to do so.

The rest of the subfolders will be created by the scripts contained in this repository.

## Running the scripts from this repo
First, set up submodules:
```bash
git submodule update --init
```


Then, follow the instructions in the READMEs of each subfolder in the following order. All the scripts must be launched from the `<project_dir>/code/` folder containing this README.md.

1. **[qa](./qa):** Scripts to run quality assurance tests on the data set
2. **[bids_conversion](./bids_conversion):** :computer: Scripts and files to convert the raw Bruker data to the MPM BIDS format.
3. **[preprocessing](./preprocessing):** Scripts to create composite images used for registration and preprocess them. 
4. **[registration](./registration):** :computer: Scripts to register the data, either intra- or inter-session.
5. **[tb1_processing](./tb1_processing):** Compute the B1+ maps using an in-house toolbox
6. **[qi](./qi):** Compute R2*, R1, PD, and MTsat using the QUIT (qi) toolbox
7. **[statistical_analyses](./statistical_analyses):** :computer: Should be tailored to the tests and models you want to fit to your data