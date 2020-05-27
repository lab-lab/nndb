#!/bin/bash

################################################################################
# Move files out of the way
################################################################################

for perp in $perps
do
    cd "$subject"/
    mv ./anat/"$subject"_T1w_avg.nii.gz \
       ./anat/"$subject"_T1w_avg_uni.nii.gz \
       ./anat/"$subject"_T1w_avg_uni_ns.nii.gz \
       ./anat/"$subject"_T1w_avg_ns.nii.gz \
       ./anat/"$subject"_T1w_avg_uni.aw.nii.gz \
       ./anat/"$subject"_T1w_avg_uni_ns.aw_mask.nii.gz \
       ./anat/"$subject"_T1w_avg_uni_ns.aw_mask_resample.nii.gz \
       files/anatomical_files/
       
    mv ./func/"$subject"_task-"$movie"_run-0?_run-0?_bold_tshift_* \
       ./func/*_interpolation_amount.nii.gz \
       ./func/*_tp.nii.gz \
       ./func/*_slug.nii.gz \
       ./func/"$subject"_task-"$movie"_run-0?_bold_tshift.nii.gz \
       ./func/"$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
       ./func/"$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz \
       ./func/"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg.nii.gz \
       ./func/"$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
       ./func/"$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+* \
       ./func/"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig* \
       ./func/"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al.nii.gz \
       ./func/"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al_mni.nii.gz \
       ./func/"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al_mni_mask.nii.gz \
       ./func/"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al_mni_mask_*.nii.gz \
       files/timeseries_files/
    mv ./"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_*_mat.aff12.1D \
       ./"$subject"_T1w_avg_uni_ns_al_e2a_only_mat.aff12.1D \
       ./func/"$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al_mat.aff12.1D \
       files/text_files/
    mv ./func/"$subject"_task-"$movie"_*deoblique* \
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
