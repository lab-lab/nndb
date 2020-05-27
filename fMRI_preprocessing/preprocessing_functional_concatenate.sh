#!/bin/bash

################################################################################
# Concatenate functional data if necessary
################################################################################

# NOTE
# Used for, e.g., ICA, 3dDegreeCentrality, etc.

for subject in $participants
do
  # Change to subject directory
  cd "$subject"/
  for filename in norm polort norm_polort norm_polort_motion norm_polort_motion_wm_ventricle
  do
    # mv files back if necessary
    mv ./files/timeseries_files/"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz ./
    mv ./files/timeseries_files/"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al_mni_mask_blur"$functional_blur_amount"_"$filename"_timing.nii.gz ./
    # Concatenate non-blur
    3dTcat \
      -prefix ./func/"$subject"_task-"$movie"_bold_tshift_despike_reg_al_mni_mask_"$filename"_timing_long.nii.gz \
              ./func/"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
    # Remove old non-blur results
    rm ./func/"$subject"_task-"$movie"_bold_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
    rm ./files/timeseries_files/"$subject"_task-"$movie"_bold_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
    # Set afni tp length
    movie_length_1=`echo $((movie_length - 1))`
    # Make length
    3dTcat \
      -prefix ./func/"$subject"_task-"$movie"_bold_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz \
              ./func/"$subject"_task-"$movie"_bold_tshift_despike_reg_al_mni_mask_"$filename"_timing_long.nii.gz[0.."$movie_length_1"]
    # Remove non-blur long file
    rm ./func/"$subject"_task-"$movie"_bold_tshift_despike_reg_al_mni_mask_"$filename"_timing_long.nii.gz
    # Concatenate blur
    3dTcat \
      -prefix ./func/"$subject"_task-"$movie"_bold_tshift_despike_reg_al_mni_mask_blur"$functional_blur_amount"_"$filename"_timing_long.nii.gz \
              ./func/"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al_mni_mask_blur"$functional_blur_amount"_"$filename"_timing.nii.gz
    # Remove old blur results
    rm ./func/"$subject"_task-"$movie"_bold_tshift_despike_reg_al_mni_mask_blur"$functional_blur_amount"_"$filename"_timing.nii.gz
    rm ./files/timeseries_files/"$subject"_task-"$movie"_bold_tshift_despike_reg_al_mni_mask_blur"$functional_blur_amount"_"$filename"_timing.nii.gz
    # Set afni tp length
    movie_length_1=`echo $((movie_length - 1))`
    3dTcat \
      -prefix ./func/"$subject"_task-"$movie"_bold_tshift_despike_reg_al_mni_mask_blur"$functional_blur_amount"_"$filename"_timing.nii.gz \
              ./func/"$subject"_task-"$movie"_bold_tshift_despike_reg_al_mni_mask_blur"$functional_blur_amount"_"$filename"_timing_long.nii.gz[0.."$movie_length_1"]
    # Remove blur long file
    rm ./func/"$subject"_task-"$movie"_bold_tshift_despike_reg_al_mni_mask_blur"$functional_blur_amount"_"$filename"_timing_long.nii.gz
  done
done

################################################################################
# End
################################################################################
