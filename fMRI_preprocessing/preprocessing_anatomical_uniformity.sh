#!/bin/bash

################################################################################
# Correct for anatomical image intensity non-uniformity
################################################################################

for subject in $participants
do

  cd "$subject"/


  # Mask the anatomical image
  3dAutomask \
      -prefix ./anat/"$subject"_T1w_mask.nii.gz \
      ./anat/"$subject"_T1w.nii.gz
  # Fill in any holes in the resulting mask
  3dinfill -blend SOLID -minhits 2 \
      -input  ./anat/"$subject"_T1w_mask.nii.gz \
      -prefix ./anat/"$subject"_T1w_mask_fill.nii.gz
  # Blur the anatomical
  3dBlurInMask \
      -FWHM "$anatomical_blur_amount" \
      -mask   ./anat/"$subject"_T1w_mask_fill.nii.gz \
      -input  ./anat/"$subject"_T1w.nii.gz \
      -prefix ./anat/"$subject"_T1w_blur"$anatomical_blur_amount".nii.gz
  # Use the newer program to uniformize wm/gm
  3dUnifize \
      -GM \
      -input  ./anat/"$subject"_T1w_blur"$anatomical_blur_amount".nii.gz \
      -prefix ./anat/"$subject"_T1w_blur"$anatomical_blur_amount"_uni.nii.gz

done

# This is just a naming change
cp ./anat/"$subject"_T1w.nii.gz ./anat/"$subject"_T1w_avg.nii.gz
################################################################################
# End
################################################################################
