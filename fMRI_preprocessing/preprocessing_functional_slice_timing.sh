#!/bin/bash

################################################################################
# Slice timing correction and timeseries truncation
################################################################################

# NOTE
# This script removes the first eight TRS

for perp in $perps
do
    cd "$data_dir"/"$perp"/
    # Move files if needed
    mv ./files/timeseries_files/media_?.nii.gz ./
    # Count the number of time series files
    total_num_runs=`ls ./media_?.nii.gz  | wc -l`
    # Loops through timeseries files and tshift
    for run in `seq 1 $total_num_runs`
    do
      rm media_"$run"_tshift.nii.gz
      3dTshift \
          -tpattern alt+z2 \
          -prefix media_"$run"_tshift.nii.gz \
          'media_'$run'.nii.gz[8..$]'
    done
done

################################################################################
# End
################################################################################
