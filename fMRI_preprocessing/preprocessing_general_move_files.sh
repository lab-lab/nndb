#!/bin/bash

################################################################################
# Move files out of the way
################################################################################

# NOTE
# Used "?". Would need ?? if you have more than 9 files

for perp in $perps
do
    cd "$data_dir"/"$perp"/
    mv anatomical_1* \
       anatomical_2* \
       anatomical_avg.nii.gz \
       anatomical_avg_uni.nii.gz \
       anatomical_avg_uni_ns.nii.gz \
       anatomical_avg_ns.nii.gz \
       anatomical_avg_uni.aw.nii.gz \
       anatomical_avg_uni_ns.aw_mask.nii.gz \
       anatomical_avg_uni_ns.aw_mask_resample.nii.gz \
       files/anatomical_files/
    mv media_?.nii.gz \
       media_?_?_tshift_* \
       *_interpolation_amount.nii.gz \
       *_tp.nii.gz \
       *_slug.nii.gz \
       media_?_tshift.nii.gz \
       media_tshift_despike_align_image.nii.gz \
       media_?_tshift_despike.nii.gz \
       media_?_tshift_despike_reg.nii.gz \
       media_tshift_despike_reg_align_image.nii.gz \
       media_tshift_despike_reg_align_image_al+* \
       media_?_tshift_despike_reg_al+orig* \
       media_?_tshift_despike_reg_al.nii.gz \
       media_?_tshift_despike_reg_al_mni.nii.gz \
       media_?_tshift_despike_reg_al_mni_mask.nii.gz \
       media_?_tshift_despike_reg_al_mni_mask_*.nii.gz \
       files/timeseries_files/
    mv media_?_tshift_despike_reg_*_mat.aff12.1D \
       anatomical_avg_uni_ns_al_e2a_only_mat.aff12.1D \
       files/anatomical_files/anatomical_2_blur1_uni_al_mat.aff12.1D \
       media_tshift_despike_reg_align_image_al_mat.aff12.1D \
       files/text_files/
    mv media_*deoblique* \
       files/timeseries_files/
    mv ventricle_mask.nii.gz \
       ventricle_mask_resample_erode.nii.gz \
       ventricle_mask_resample.nii.gz \
       wm_mask.nii.gz \
       wm_mask_resample_erode.nii.gz \
       wm_mask_resample.nii.gz \
       files/anatomical_files/
done

################################################################################
# End
################################################################################
