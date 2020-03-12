#!/bin/bash

################################################################################
# Correct for anatomical image intensity non-uniformity
################################################################################

# NOTE
# TODO: Apply to Movie? Done
# Modernized since overlearn
# Did a little 1mm blurring to help out

for perp in $perps
do

  cd "$data_dir"/"$perp"/

  for anatomical in 1 2 3 4
  do

    # Mask the anatomical image
    3dAutomask \
      -prefix anatomical_"$anatomical"_mask.nii.gz \
      anatomical_"$anatomical".nii.gz
    # Fill in any holes in the resulting mask
    3dinfill -blend SOLID -minhits 2 \
      -input  anatomical_"$anatomical"_mask.nii.gz \
      -prefix anatomical_"$anatomical"_mask_fill.nii.gz
    # Blur the anatomical some
    3dBlurInMask \
      -FWHM "$anatomical_blur_amount" \
      -mask   anatomical_"$anatomical"_mask_fill.nii.gz \
      -input  anatomical_"$anatomical".nii.gz \
      -prefix anatomical_"$anatomical"_blur"$anatomical_blur_amount".nii.gz
    # Use the newer program to uniformize wm/gm
    3dUnifize \
      -GM \
      -input  anatomical_"$anatomical"_blur"$anatomical_blur_amount".nii.gz \
      -prefix anatomical_"$anatomical"_blur"$anatomical_blur_amount"_uni.nii.gz

    done
done

################################################################################
# End
################################################################################
