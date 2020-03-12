#!/bin/bash

################################################################################
# Concatenate functional data if necessary
################################################################################

# NOTE
# Used for, e.g., ICA, 3dDegreeCentrality, etc.
# Will not work for more than 9 functional files

for perp in $perps
do
  # Change to perp directory
  cd "$data_dir"/"$perp"/
  for filename in norm polort norm_polort norm_polort_motion norm_polort_motion_wm_ventricle
  do
    # mv files back if necessary
    mv ./files/timeseries_files/media_?_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz ./
    mv ./files/timeseries_files/media_?_tshift_despike_reg_al_mni_mask_blur"$functional_blur_amount"_"$filename"_timing.nii.gz ./
    # Concatenate non-blur
    3dTcat \
      -prefix media_all_tshift_despike_reg_al_mni_mask_"$filename"_timing_long.nii.gz \
              media_?_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
    # Remove old non-blur results
    rm media_all_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
    rm ./files/timeseries_files/media_all_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
    # Set afni tp length
    movie_length_1=`echo $((movie_length - 1))`
    # Make length
    3dTcat \
      -prefix media_all_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz \
              media_all_tshift_despike_reg_al_mni_mask_"$filename"_timing_long.nii.gz[0.."$movie_length_1"]
    # Remove non-blur long file
    rm media_all_tshift_despike_reg_al_mni_mask_"$filename"_timing_long.nii.gz
    # Concatenate blur
    3dTcat \
      -prefix media_all_tshift_despike_reg_al_mni_mask_blur"$functional_blur_amount"_"$filename"_timing_long.nii.gz \
              media_?_tshift_despike_reg_al_mni_mask_blur"$functional_blur_amount"_"$filename"_timing.nii.gz
    # Remove old blur results
    rm media_all_tshift_despike_reg_al_mni_mask_blur"$functional_blur_amount"_"$filename"_timing.nii.gz
    rm ./files/timeseries_files/media_all_tshift_despike_reg_al_mni_mask_blur"$functional_blur_amount"_"$filename"_timing.nii.gz
    # Set afni tp length
    movie_length_1=`echo $((movie_length - 1))`
    3dTcat \
      -prefix media_all_tshift_despike_reg_al_mni_mask_blur"$functional_blur_amount"_"$filename"_timing.nii.gz \
              media_all_tshift_despike_reg_al_mni_mask_blur"$functional_blur_amount"_"$filename"_timing_long.nii.gz[0.."$movie_length_1"]
    # Remove blur long file
    rm media_all_tshift_despike_reg_al_mni_mask_blur"$functional_blur_amount"_"$filename"_timing_long.nii.gz
  done
done

################################################################################
# End
################################################################################
