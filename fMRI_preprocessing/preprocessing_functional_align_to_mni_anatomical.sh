#!/bin/bash

################################################################################
# Align unbiased functional data to the MNI aligned anatomical image
################################################################################

for subject in $participants
do
    cd "$subject"/
    total_num_runs=`ls ./func/"$subject"_task-"$movie"_run-0?_bold.nii.gz  | wc -l`
    for run in `seq 1 $total_num_runs`
    do
        rm ./func/"$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_reg_al.nii.gz
        3dcopy \
            ./func/"$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_reg_al+orig \
            ./func/"$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_reg_al.nii.gz
        rm ./func/"$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_reg_al_mni.nii.gz
        3dNwarpApply \
            -master ./anat/"$subject"_T1w_avg_uni_ns.aw.nii.gz -dxyz 3 \
            -source ./func/"$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_reg_al.nii.gz \
            -nwarp 'awpy/anat.un.aff.qw_WARP.nii.gz awpy/anat.un.aff.Xat.1D' \
            -prefix ./func/"$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_reg_al_mni.nii.gz
    done
done

################################################################################
# End
################################################################################
