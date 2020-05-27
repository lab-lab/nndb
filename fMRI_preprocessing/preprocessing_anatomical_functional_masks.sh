#!/bin/bash

################################################################################
# Make anatomical and functional brain masks
################################################################################

# NOTE:
# Making this b/c melodic falters through when there are all zeros as added by the anatomical mask

for subject in $participants
do
    cd "$subject"/
    # Make binary mask
    rm ./anat/"$subject"_T1w_avg_uni_ns.aw_mask.nii.gz
    3dcalc \
        -a ./anat/"$subject"_T1w_avg_uni_ns.aw.nii.gz \
        -expr 'astep(a,4)' \
        -prefix ./anat/"$subject"_T1w_avg_uni_ns.aw_mask.nii.gz
        
    # Resample binary mask
    num_files=`ls ./func/"$subject"_task-"$movie"_run-0?_bold.nii.gz | wc -l`
    set_center_run=`echo "$((($num_files + 1) / 2))"`
    rm ./anat/"$subject"_T1w_avg_uni_ns.aw_mask_resample.nii.gz
    3dresample \
        -rmode NN \
        -master ./func/"$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike_reg_al_mni.nii.gz \
        -input  ./anat/"$subject"_T1w_avg_uni_ns.aw_mask.nii.gz \
        -prefix ./anat/"$subject"_T1w_avg_uni_ns.aw_mask_resample.nii.gz
        
    # Smaller mask for functional runs
    total_num_runs=`ls ./func/"$subject"_task-"$movie"_run-0?_bold.nii.gz  | wc -l`
    for run in `seq 1 $total_num_runs`
    do
        rm ./func/"$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_reg_al_mni_mask.nii.gz
        3dAutomask \
            -dilate 1 \
            -prefix ./func/"$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_reg_al_mni_mask.nii.gz \
            ./func/"$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_reg_al_mni.nii.gz
    done
    
    # Combine functional runs masks
    rm ./func/"$subject"_task-"$movie"_bold_mask.nii.gz
    3dmask_tool \
        -union \
        -inputs ./func/"$subject"_task-"$movie"_run-0*_bold_tshift_despike_reg_al_mni_mask.nii.gz \
        -prefix ./func/"$subject"_task-"$movie"_bold_mask.nii.gz
        
    # Combine anatomical and functional masks
    rm ./anat/"$subject"_T1w_mask.nii.gz
    3dmask_tool \
        -union \
        -prefix ./anat/"$subject"_T1w_mask.nii.gz \
        -inputs \
        ./anat/"$subject"_T1w_avg_uni_ns.aw_mask_resample.nii.gz \
        ./func/"$subject"_task-"$movie"_bold_mask.nii.gz
    rm ./func/"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al_mni_mask.nii.gz
done

################################################################################
# End
################################################################################
