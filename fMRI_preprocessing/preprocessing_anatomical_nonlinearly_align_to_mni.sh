#!/bin/bash

################################################################################
# Nonlinearly align grand averaged anatomical image to MNI template
################################################################################

# NOTE:
# suma -spec /usr/local/suma_MNI_N27/MNI_N27_both.spec -sv anatomical_avg_uni_ns_al.aw.nii.gz

for perp in $perps
do

  cd "$data_dir"/"$perp"/

  auto_warp.py \
    -base /usr/local/suma_MNI_N27/MNI_N27_SurfVol.nii \
    -input anatomical_avg_uni_ns.nii.gz \
    -skull_strip_base no -skull_strip_input no

  # Compress files created during the alignment process
  gzip awpy/*nii

  # Move aligned brain into base directory
  cp awpy/anatomical_avg_uni_ns.aw.nii.gz ./

  # Apply nonlinear alignment to skulled anatomical
  rm anatomical_avg.aw.nii.gz
  3dNwarpApply \
    -master anatomical_avg_uni_ns.aw.nii.gz \
    -source anatomical_avg.nii.gz \
    -nwarp ''$data_dir'/'$perp'/awpy/anat.un.aff.qw_WARP.nii.gz '$data_dir'/'$perp'/awpy/anat.un.aff.Xat.1D' \
    -prefix anatomical_avg.aw.nii.gz

  # Apply nonlinear alignment to skulled uniformized anatomical
  rm anatomical_avg_uni.aw.nii.gz
  3dNwarpApply \
    -master anatomical_avg_uni_ns.aw.nii.gz \
    -source anatomical_avg_uni.nii.gz \
    -nwarp ''$data_dir'/'$perp'/awpy/anat.un.aff.qw_WARP.nii.gz '$data_dir'/'$perp'/awpy/anat.un.aff.Xat.1D' \
    -prefix anatomical_avg_uni.aw.nii.gz

done

################################################################################
# End
################################################################################
