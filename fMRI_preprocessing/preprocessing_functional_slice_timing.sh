#!/bin/bash

################################################################################
# Slice timing correction and timeseries truncation
################################################################################

# NOTE
# This script removes the first eight TRS

for subject in $participants
do
    cd "$subject"/
    # Move files if needed
    mv ./files/timeseries_files/"$subject"_task-"$movie"_run-0?_bold.nii.gz ./
    # Count the number of time series files
    total_num_runs=`ls ./func/"$subject"_task-"$movie"_run-0?_bold.nii.gz  | wc -l`
    # Loops through timeseries files and tshift
    for run in `seq 1 $total_num_runs`
    do
      rm ./func/"$subject"_task-"$movie"_run-0"$run"_bold_tshift.nii.gz
      3dTshift \
          -tpattern alt+z2 \
          -prefix ./func/"$subject"_task-"$movie"_run-0"$run"_bold_tshift.nii.gz \
          './func/'$subject'_task-'$movie'_run-0'$run'_bold.nii.gz[8..$]'
    done
done

################################################################################
# End
################################################################################
