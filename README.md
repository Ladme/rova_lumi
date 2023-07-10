
# RoVa LUMI

This repository contains scripts designed for RoVa Lab to simplify working on LUMI.

⚠️ **This repository is currently in a VERY EXPERIMENTAL STAGE, and extreme caution should be exercised.**

The repository contains several run scripts and an installation script. When run, it sets up "RoVa Lab LUMI Environment" creating user directories in the specified projects and setting up aliases for easier access to these directories.

## Setting up the environment

To set up the environment, follow these steps:

Connect to LUMI and clone this repository:
```
git clone https://github.com/Ladme/rova_lumi.git
```

Install the environment by running the following command:
```
cd rova_lumi && bash install.sh PROJECT_NUMBER1 PROJECT_NUMBER2 (...)
```

`PROJECT_NUMBER` is an ID of any project you are part of. It should look something like this `465000???`.

Provide "shortcuts" for your projects. Here's an example:
```
labarto@uan02:~/rova_lumi> $ bash install.sh 465000573 465000590
Enter shortcut for project '465000573': gpu
Enter shortcut for project '465000590': cpu

Shortcuts created:
Shortcut: gpu --> Project: 465000573
Shortcut: cpu --> Project: 465000590

Setting up bin directory and PATH.

Successfully set up RoVa Lab LUMI environment.
```

You do not have to provide shortcut for a project. In such case, no aliases will be generated for it.

## Scripts

- `loop_md_cpu`: Script for running multidir Gromacs simulations as a single job on LUMI. It supports looping using the `loop_sub` script.

- `loop_re_cpu`: Script for running Hamiltonian Replica Exchange Gromacs simulation. It supports looping using the `loop_sub` script.

- `loop_md_gpu`: Script for running multidir Gromacs simulations as a single job on LUMI-G (GPU-accelerated). It supports looping using the `loop_sub` script.

- `loop_sub`: Script for submitting loop jobs on LUMI. If you have installed the RoVa Lab LUMI environment, the script should already be placed in your `$PATH`, so you can call it from anywhere as `loop_sub`. To submit a job for *N* cycles, run `loop_sub RUN_SCRIPT N` in the directory where your simulation is present. For example, `loop_sub loop_md_cpu 4` will submit the `loop_md_cpu` script for 4 cycles. The script will submit all cycles at once, but each subsequent cycle will only start after the previous cycle is successfully completed. In essence, this mimics the `precycle_md` script used in the Infinity environment.

- `fetch`: Script for fetching other scripts from the `rova_lumi` directory. For example, `fetch loop_md_cpu` will copy `loop_md_cpu` from the `rova_lumi` directory to the current directory. If you have installed the RoVa Lab LUMI environment, the script should already be placed in your `$PATH`, so you can call it from anywhere as `fetch`. The location of the `rova_lumi` directory is also set when installing the RoVa LUMI environment, so do not move the `rova_lumi` directory after.

## Environment variables and aliases

These variables and aliases are generated for each project that was provided with a shortcut.

- `project-{YOUR_SHORTCUT}`: Jump to your directory in the scratch directory associated with the project. Example: `project-gpu` will take me to `/scratch/project_465000573/$USER`.

- `ID_{YOUR_SHORTCUT}`: Project number associated with the shortcut. Example: `echo $ID_gpu` will print `465000573`.

- `main-{YOUR_SHORTCUT}`: Jump to the shared persistent storage directory for a project. You should not use this directory as it has very limited capacity.

- `set-install-{YOUR_SHORTCUT}`: Sets EasyBuild to install software into the EasyBuild directory of the target project. No example as you should not do this.
