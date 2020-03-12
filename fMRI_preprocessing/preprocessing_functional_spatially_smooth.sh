#!/bin/bash

################################################################################
# Spatially smooth functional data
################################################################################

# NOTE
# Do here before ICA number 2?
# removed -detin and added -nodetrend - why detrend again
# This paper, which discusses the need for a fixed level of smoothness when combining FMRI datasets from different scanner platforms:
# Friedman L, Glover GH, Krenz D, Magnotta V; The FIRST BIRN. Reducing inter-scanner variability of activation in a multicenter fMRI study: role of smoothness equalization. Neuroimage. 2006 Oct 1;32(4):1656-68.
# Check with:
# /usr/lib/afni/bin/3dFWHMx -arith -mask /data/jskipper@lab-lab.org/experiments/movie/fmri/participants/adults/150929JS/anatomical_mask.nii.gz /data/jskipper@lab-lab.org/experiments/movie/fmri/participants/adults/150929JS/media_tshift_despike_reg_al_mni_mask_norm_detrend_arti_blur6.nii.gz
# previously this script had the no detrending flag because we were blurring after detrending.
# Now have added it back with the re trending flag b/c we now detrend later

for perp in $perps
do
  # Go to the right directory
  cd "$data_dir"/"$perp"/
  # Move files around if needed
  mv files/timeseries_files/media_?.nii.gz ./
  mv files/timeseries_files/media_?_tshift_despike_reg_al_mni_mask.nii.gz ./
  # Get the number of runs
  total_num_runs=`ls ./media_?.nii.gz  | wc -l`
  # Loop through runs to blur
  for run in `seq 1 $total_num_runs`
  do
    # Remove old files no matter where located
    rm files/timeseries_files/media_"$run"_tshift_despike_reg_al_mni_mask_blur"$functional_blur_amount".nii.gz
    rm media_"$run"_tshift_despike_reg_al_mni_mask_blur"$functional_blur_amount".nii.gz
    3dBlurToFWHM \
      -detin \
      -FWHM   "$functional_blur_amount" \
      -input  media_"$run"_tshift_despike_reg_al_mni_mask.nii.gz \
      -mask   anatomical_mask.nii.gz \
      -prefix media_"$run"_tshift_despike_reg_al_mni_mask_blur"$functional_blur_amount".nii.gz
    # Remove unecessary files
    rm 3dFWHMx.1D.png 3dFWHMx.1D
  done
done

################################################################################
# End
################################################################################
