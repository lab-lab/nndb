#!/bin/bash

################################################################################
# Despike the functional data
################################################################################

for subject in $participants
do
    cd "$subject"/
    total_num_runs=`ls ./func/"$subject"_task-"$movie"_run-0?_bold.nii.gz  | wc -l`
    for run in `seq 1 $total_num_runs`
    do
      rm ./func/"$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike.nii.gz
      3dDespike \
        -NEW \
        -prefix ./func/"$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike.nii.gz \
        ./func/"$subject"_task-"$movie"_run-0"$run"_bold_tshift.nii.gz
    done
done

################################################################################
# End
################################################################################
