#!/bin/bash

################################################################################
# Resample masks and timeseries data
################################################################################

# NOTE
# Used for, e.g., ICA, 3dDegreeCentrality, etc.
# Will not work for more than 9 functional files

for perp in $perps
do

  cd "$data_dir"/"$perp"/

  echo ""
  echo "**************************************************"
  echo "* Working on participant" $perp
  echo "**************************************************"
  echo ""

  for resample_mask_file in "$resample_mask_files"
  do

    rm "$resample_mask_file"_"$dxyz_size"mm.nii.gz
    3dresample \
        -dxyz   "$dxyz_size" "$dxyz_size" "$dxyz_size" \
        -prefix "$resample_mask_file"_"$dxyz_size"mm.nii.gz \
        -input  "$resample_mask_file".nii.gz
  done

  for resample_timeseries_file in "$resample_timeseries_files"
  do

    rm "$file_prefix"_"$resample_timeseries_file"_blur"$functional_blur_amount"_"$dxyz_size"mm.nii.gz
    3dresample \
        -dxyz   "$dxyz_size" "$dxyz_size" "$dxyz_size" \
        -prefix "$file_prefix"_"$resample_timeseries_file"_blur"$functional_blur_amount"_"$dxyz_size"mm.nii.gz \
        -input  "$file_prefix"_"$resample_timeseries_file"_blur"$functional_blur_amount".nii.gz

  done

done

################################################################################
# End
################################################################################
