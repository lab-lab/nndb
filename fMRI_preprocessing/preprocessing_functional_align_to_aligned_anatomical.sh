#!/bin/bash

################################################################################
# Create mean functional image for alignment of functional data to anatomical image
################################################################################

# NOTE
# This isn't the same as the previously made alignment image
# This one is made after functional vilume registration so should be slightly better

for perp in $perps
do

    cd "$data_dir"/"$perp"/

    # Set centre run again
    num_files=`ls media_?.nii.gz | wc -l`
    set_center_run=`echo "$((($num_files + 1) / 2))"`

    # Remove any old files
    rm media_tshift_despike_reg_align_image.nii.gz
    3dTstat \
        -datum float \
        -mean \
        -prefix media_tshift_despike_reg_align_image.nii.gz \
                media_"$set_center_run"_tshift_despike_reg.nii.gz

################################################################################
# Align the functional data to aligned anatomical image
################################################################################

# NOTE
# This step comes before alignment to the MNI brain in order to deoblique
# This is done after despikeing b/c, again, the help file states:
# 'it seems like the registration problem does NOT happen, and in fact, despiking seems to help!'
# -big_move doesn't work

    # Remove any lingering files from prior attempts
    rm media_?_*_al*
    rm media_tshift_despike_reg_align_image_al+orig.*
    rm __tt_*+orig.*
    rm __tt_anatomical_avg_uni_ns_obla2e_mat.1D
    rm anatomical_avg_uni_ns_al_e2a_only_mat.aff12.1D

    # Move in files if needed
    mv files/anatomical_files/anatomical_avg_uni_ns.nii.gz ./

    # Align
    align_epi_anat.py \
        -epi2anat -giant_move -partial_coverage -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
        -anat anatomical_avg_uni_ns.nii.gz \
        -epi  media_tshift_despike_reg_align_image.nii.gz \
        -child_epi \
         media_?_tshift_despike_reg.nii.gz

    # Remove __* files (not sure why they hang around)
    rm __tt_*+orig.*
    rm __tt_anatomical_avg_uni_ns_obla2e_mat.1D

    # Compress BRIK files
    bzip2 *BRIK

done

################################################################################
# End
################################################################################
