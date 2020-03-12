#!/bin/bash

################################################################################
# Make anatomical and functional brain masks
################################################################################

# NOTE:
# Making this b/c I think melodic falters though when there are all zeros as added by the anatomical mask

for perp in $perps
do
    cd "$data_dir"/"$perp"/
    # Make binary mask
    rm anatomical_avg_uni_ns.aw_mask.nii.gz
    3dcalc \
        -a anatomical_avg_uni_ns.aw.nii.gz \
        -expr 'astep(a,4)' \
        -prefix anatomical_avg_uni_ns.aw_mask.nii.gz
    # Resample binary mask
    # set_center_run=1
    num_files=`ls media_?.nii.gz | wc -l`
    set_center_run=`echo "$((($num_files + 1) / 2))"`
    rm anatomical_avg_uni_ns.aw_mask_resample.nii.gz
    3dresample \
        -rmode NN \
        -master media_"$set_center_run"_tshift_despike_reg_al_mni.nii.gz \
        -input  anatomical_avg_uni_ns.aw_mask.nii.gz \
        -prefix anatomical_avg_uni_ns.aw_mask_resample.nii.gz
    # Smaller mask for media runs
    total_num_runs=`ls ./media_?.nii.gz  | wc -l`
    for run in `seq 1 $total_num_runs`
    do
        rm media_"$run"_tshift_despike_reg_al_mni_mask.nii.gz
        3dAutomask \
            -dilate 1 \
            -prefix media_"$run"_tshift_despike_reg_al_mni_mask.nii.gz \
            media_"$run"_tshift_despike_reg_al_mni.nii.gz
    done
    # Combine media runs masks
    rm functional_mask.nii.gz
    3dmask_tool \
        -union \
        -inputs media_*_tshift_despike_reg_al_mni_mask.nii.gz \
        -prefix functional_mask.nii.gz
    # Combine anatomical and functional masks
    rm anatomical_mask.nii.gz
    3dmask_tool \
        -union \
        -prefix anatomical_mask.nii.gz \
        -inputs \
        anatomical_avg_uni_ns.aw_mask_resample.nii.gz \
        functional_mask.nii.gz
    rm media_?_tshift_despike_reg_al_mni_mask.nii.gz
done

################################################################################
# End
################################################################################
