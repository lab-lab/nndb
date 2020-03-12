#!/bin/bash

################################################################################
# Skull strip
################################################################################

# NOTE:
# I think ROBEX does a better job skull stripping than the programs for doing so in AFNI (3dSkullStrip) or freesurfer or FSL
# Test (stripping and alignment) for blurred/uniformized vs not - seems to be better for the latter?

for perp in $perps
do

  cd "$data_dir"/"$perp"/

  /usr/local/ROBEX/runROBEX.sh \
    anatomical_avg_uni.nii.gz \
    anatomical_avg_uni_ns.nii.gz

  /usr/local/ROBEX/runROBEX.sh \
    anatomical_avg.nii.gz \
    anatomical_avg_ns.nii.gz

# NOTE
# anatomical_avg_uni.nii.gz IS the blurred version (see prior step)
# blur_amount=1
# /usr/local/ROBEX/runROBEX.sh \
# "$data_dir"/"$perp_dir"/anatomical_1_blur"$blur_amount"_uni.nii.gz \
# "$data_dir"/"$perp_dir"/anatomical_avg_uni_ns.nii.gz

done

################################################################################
# End
################################################################################
