#!/bin/bash

################################################################################
# Skull strip
################################################################################

# NOTE:
# ROBEX does a better job at skull stripping than the programs for doing so in AFNI (3dSkullStrip) or freesurfer or FSL
# Set RROBEX directory path!
robex_dir=""

for subject in $participants
do

  cd "$subject"/

  "$robex_dir"/runROBEX.sh \
    ./anat/"$subject"_T1w_avg_uni.nii.gz \
    ./anat/"$subject"_T1w_avg_uni_ns.nii.gz

  "$robex_dir"/runROBEX.sh \
    ./anat/"$subject"_T1w_avg.nii.gz \
    ./anat/"$subject"_T1w_avg_ns.nii.gz

# NOTE
# ./anat/"$subject"_T1w_avg_uni.nii.gz IS the blurred version (see prior step)
# blur_amount=1
# "$roobex_dir"/runROBEX.sh \
# "$subject"/anat/"$subject"_T1w_blur"$blur_amount"_uni.nii.gz \
# "$subject"/anat/"$subject"_T1w_avg_uni_ns.nii.gz

done

################################################################################
# End
################################################################################
