#!/bin/bash

################################################################################
# Mask functional data
################################################################################

# NOTE:
# This step is more cosmetic and was added b/c the next step really 'spreads' the activity out
# Also, the file sizes are about 4X smaller

for subject in $participants
do
    cd "$subject"/
    total_num_runs=`ls ./func/"$subject"_task-"$movie"_run-0?_bold.nii.gz  | wc -l`
    for run in `seq 1 $total_num_runs`
    do
      rm ./func/"$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_reg_al_mni_mask.nii.gz
      3dcalc \
          -a ./func/"$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_reg_al_mni.nii.gz \
          -b ./anat/"$subject"_T1w_mask.nii.gz \
          -expr 'a*b' \
          -prefix ./func/"$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_reg_al_mni_mask.nii.gz
    done
done

################################################################################
# End
################################################################################
