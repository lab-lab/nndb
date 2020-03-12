#!/bin/bash

################################################################################
# Remove some files
################################################################################

# NOTE
# This step is tre dangerous, are you sure?
# Currently leaves steps earlier in the processing pipeline in case something needs to be redone

for perp in $perps
do
    cd "$data_dir"/"$perp"/
    rm files/timeseries_files/media_?_tshift_despike_reg_al_mni_mask_norm*.nii.gz
    rm files/timeseries_files/media_?_tshift_despike_reg_al_mni_mask_polort*.nii.gz
    rm files/timeseries_files/media_?_tshift_despike_reg_al_mni_mask_blur6_norm*.nii.gz
    rm files/timeseries_files/media_?_tshift_despike_reg_al_mni_mask_blur6_polort*.nii.gz
    rm files/timeseries_files/media_?_?_tshift_despike_reg_al_mni_mask_*.nii.gz
done

################################################################################
# End
################################################################################
