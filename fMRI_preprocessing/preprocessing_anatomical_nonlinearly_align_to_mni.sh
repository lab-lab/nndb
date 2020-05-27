#!/bin/bash

################################################################################
# Nonlinearly align grand averaged anatomical image to MNI template
################################################################################

# Make sure you set the suma directory path!
suma_dir=""

for subject in $participants
do

  cd "$subject"/

  auto_warp.py \
    -base "$suma_dir"/MNI_N27_SurfVol.nii \
    -input ./anat/"$subject"_T1w_avg_uni_ns.nii.gz \
    -skull_strip_base no -skull_strip_input no

  # Compress files created during the alignment process
  gzip awpy/*nii

  # Move aligned brain into base directory
  cp awpy/"$subject"_T1w_avg_uni_ns.aw.nii.gz ./

  # Apply nonlinear alignment to skulled anatomical
  rm ./anat/"$subject"_T1w_avg.aw.nii.gz
  3dNwarpApply \
    -master ./anat/"$subject"_T1w_avg_uni_ns.aw.nii.gz \
    -source ./anat/"$subject"_T1w_avg.nii.gz \
    -nwarp ''$subject'/awpy/anat.un.aff.qw_WARP.nii.gz '$subject'/awpy/anat.un.aff.Xat.1D' \
    -prefix ./anat/"$subject"_T1w_avg.aw.nii.gz

  # Apply nonlinear alignment to skulled uniformized anatomical
  rm ./anat/"$subject"_T1w_avg_uni.aw.nii.gz
  3dNwarpApply \
    -master ./anat/"$subject"_T1w_avg_uni_ns.aw.nii.gz \
    -source ./anat/"$subject"_T1w_avg_uni.nii.gz \
    -nwarp ''$subject'/awpy/anat.un.aff.qw_WARP.nii.gz '$subject'/awpy/anat.un.aff.Xat.1D' \
    -prefix ./anat/"$subject"_T1w_avg_uni.aw.nii.gz

done

################################################################################
# End
################################################################################
