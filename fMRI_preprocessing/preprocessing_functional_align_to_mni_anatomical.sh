#!/bin/bash

################################################################################
# Align unbiased functional data to the MNI aligned anatomical image
################################################################################

# NOTE
# This step might be better done later in the game

for perp in $perps
do
    cd "$data_dir"/"$perp"/
    total_num_runs=`ls ./media_?.nii.gz  | wc -l`
    for run in `seq 1 $total_num_runs`
    do
        rm media_"$run"_tshift_despike_reg_al.nii.gz
        3dcopy \
            media_"$run"_tshift_despike_reg_al+orig \
            media_"$run"_tshift_despike_reg_al.nii.gz
        rm media_"$run"_tshift_despike_reg_al_mni.nii.gz
        3dNwarpApply \
            -master anatomical_avg_uni_ns.aw.nii.gz -dxyz 3 \
            -source media_"$run"_tshift_despike_reg_al.nii.gz \
            -nwarp 'awpy/anat.un.aff.qw_WARP.nii.gz awpy/anat.un.aff.Xat.1D' \
            -prefix media_"$run"_tshift_despike_reg_al_mni.nii.gz
    done
done

################################################################################
# End
################################################################################
