#!/bin/bash

################################################################################
# Align anatomical image 2 to 1 within session
################################################################################

# NOTE

for perp in $perps
do

  cd "$data_dir"/"$perp"/

  # align_epi_anat.py \
  # -dset1to2 \
  # -dset1 "$data_dir"/"$perp_dir"/anatomical_2_blur"$blur_amount"_uni.nii.gz \
  # -dset2 "$data_dir"/"$perp_dir"/anatomical_1_blur"$blur_amount"_uni.nii.gz \
  # -epi_base 0  \
  # -anat_has_skull yes \
  # -dset1_strip None \
  # -dset2_strip None \
  # -cost lpa \
  # -overwrite -suffix _al

  # # Compress the files produced
  # bzip2 *BRIK

  # # Put in NIFTI format
  # 3dcopy \
  # "$data_dir"/"$perp_dir"/anatomical_2_blur"$blur_amount"_uni_al+orig \
  # "$data_dir"/"$perp_dir"/anatomical_2_blur"$blur_amount"_uni_al.nii.gz

  # # Align the 2nd anatomical image that still has the skull and was not uniformized to the 1st anatomical image
  # # (For later use in freesrurfer)
  # 3dAllineate \
  # -1Dmatrix_apply anatomical_2_blur"$blur_amount"_uni_al_mat.aff12.1D \
  # -base "$data_dir"/"$perp_dir"/anatomical_1_blur"$blur_amount"_uni.nii.gz \
  # -source "$data_dir"/"$perp_dir"/anatomical_2.nii.gz \
  # -prefix "$data_dir"/"$perp_dir"/anatomical_2_al.nii.gz

################################################################################
# Average aligned anatomical images 1 & 2 within session
################################################################################

  # NOTE:

  # Average original and now aligned anatomicals
  # 3dmerge \
  #     -gnzmean -nscale \
  #     -prefix "$data_dir"/"$perp_dir"/anatomical_avg.nii.gz \
  #             "$data_dir"/"$perp_dir"/anatomical_1.nii.gz \
  #             "$data_dir"/"$perp_dir"/anatomical_2_al.nii.gz

  # For movie/audible
  cp anatomical_1.nii.gz anatomical_avg.nii.gz

  # Average uniformized and now aligned anatomicals
  # 3dmerge \
  #     -gnzmean -nscale \
  #     -prefix "$data_dir"/"$perp_dir"/anatomical_avg_uni.nii.gz \
  #             "$data_dir"/"$perp_dir"/anatomical_1_blur"$blur_amount"_uni.nii.gz \
  #             "$data_dir"/"$perp_dir"/anatomical_2_blur"$blur_amount"_uni_al.nii.gz

  # For movie/audible
  cp anatomical_1_blur"$anatomical_blur_amount"_uni.nii.gz anatomical_avg_uni.nii.gz

done

################################################################################
# End
################################################################################
