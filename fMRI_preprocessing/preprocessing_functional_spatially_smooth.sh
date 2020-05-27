#!/bin/bash

################################################################################
# Spatially smooth functional data
################################################################################

# NOTE
# This paper, which discusses the need for a fixed level of smoothness when combining FMRI datasets from different scanner platforms:
# Friedman L, Glover GH, Krenz D, Magnotta V; The FIRST BIRN. Reducing inter-scanner variability of activation in a multicenter fMRI study: role of smoothness equalization. Neuroimage. 2006 Oct 1;32(4):1656-68.

for subject in $participants
do
  # Go to the right directory
  cd "$subject"/
  # Move files around if needed
  mv files/timeseries_files/"$subject"_task-"$movie"_run-0?_bold.nii.gz ./
  mv files/timeseries_files/"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al_mni_mask.nii.gz ./
  # Get the number of runs
  total_num_runs=`ls ./func/"$subject"_task-"$movie"_run-0?_bold.nii.gz  | wc -l`
  # Loop through runs to blur
  for run in `seq 1 $total_num_runs`
  do
    # Remove old files no matter where located
    rm files/timeseries_files/"$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_reg_al_mni_mask_blur"$functional_blur_amount".nii.gz
    rm ./func/"$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_reg_al_mni_mask_blur"$functional_blur_amount".nii.gz
    3dBlurToFWHM \
      -detin \
      -FWHM   "$functional_blur_amount" \
      -input  ./func/"$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_reg_al_mni_mask.nii.gz \
      -mask   ./anat/"$subject"_T1w_mask.nii.gz \
      -prefix ./func/"$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_reg_al_mni_mask_blur"$functional_blur_amount".nii.gz
    # Remove unecessary files
    rm 3dFWHMx.1D.png 3dFWHMx.1D
  done
done

################################################################################
# End
################################################################################
