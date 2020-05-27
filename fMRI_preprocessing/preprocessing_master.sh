#!/bin/bash

################################################################################
# Pre-processing master script
################################################################################

# Written by Jeremy I Skipper
# Revised 18-09-20 for NNDb

################################################################################
# Steps to perform
################################################################################

# NOTE
# This script takes a long time to run as a whole and if there are lots of participants to run, it makes more sense to clone it for each subject.
# The detrend_norm step cannot be run until freesurfer has completed.
# CHECK ***** ALL ***** DATA ***** FROM ***** ALL ***** STEPS

# Redirect screen to a log file
exec &> >(tee -a preprocessing_master_logfile.txt)

#############################
# Steps
#############################

# NOTE
# The script needs to be broken into steps 1 and 2 b/c of how long freesurfer takes
# That is 'detrend_norm' is the last step that can be done until freesurfer finishes

# Typical step 1 might be:
# set_vars setup_dir uniform strip mni_align fs_mni slice_t despike registration func_anat_align func_mni_align make_masks mask_func smooth_me
# And step 2:
# set_vars detrend_norm timing (or trim_func_v1) cat_func clean_dir

# Set steps:
# Please select from the steps above and add them as a list in steps_order below
steps_order=""

#############################
# Start
#############################

# Set scripts directory
# Set to the directory path where you saved the Github repository (eg. '/Downloads/')
export scripts_dir=""

for step in $steps_order
do

  if [[ $step = set_vars ]]; then
    echo ""
    echo "****************************************************************************************************"
    echo "* Setting variables"
    echo "****************************************************************************************************"
    echo ""
    source "$scripts_dir"/general_set_variables.sh
  fi

  if [[ $step = setup_dir ]]; then
    echo ""
    echo "****************************************************************************************************"
    echo "* Setting up directories, moving files/dirs, and compressing files"
    echo "****************************************************************************************************"
    echo ""
    "$scripts_dir"/preprocessing_general_set_up_directories.sh
  fi

  if [[ $step = uniform ]]; then
    echo ""
    echo "****************************************************************************************************"
    echo "* Correcting for anatomical image intensity non-uniformity"
    echo "****************************************************************************************************"
    echo ""
    "$scripts_dir"/preprocessing_anatomical_uniformity.sh
  fi

  if [[ $step = strip ]]; then
    echo ""
    echo "****************************************************************************************************"
    echo "* Skull stripping"
    echo "****************************************************************************************************"
    echo ""
    "$scripts_dir"/preprocessing_anatomical_skull_strip.sh
  fi

  if [[ $step = mni_align ]]; then
    echo ""
    echo "****************************************************************************************************"
    echo "* Nonlinearly aligning the averaged anatomical image to an MNI template"
    echo "****************************************************************************************************"
    echo ""
    "$scripts_dir"/preprocessing_anatomical_nonlinearly_align_to_mni.sh
  fi

  if [[ $step = fs_mni ]]; then
    echo ""
    echo "****************************************************************************************************"
    echo "* Inflating MNI aligned anatomical image with Freesurfer"
    echo "****************************************************************************************************"
    echo ""
    "$scripts_dir"/preprocessing_anatomical_freesurfer.sh
  fi

  if [[ $step = slice_t ]]; then
    echo ""
    echo "****************************************************************************************************"
    echo "* Slice timing correction and timeseries truncation"
    echo "****************************************************************************************************"
    echo ""
    "$scripts_dir"/preprocessing_functional_slice_timing.sh
  fi

  if [[ $step = despike ]]; then
    echo ""
    echo "****************************************************************************************************"
    echo "* Despiking the functional data"
    echo "****************************************************************************************************"
    echo ""
    "$scripts_dir"/preprocessing_functional_despike.sh
  fi

  if [[ $step = registration ]]; then
    echo ""
    echo "****************************************************************************************************"
    echo "* Functional volume registration w/ mean functional image and motion regressors"
    echo "****************************************************************************************************"
    echo ""
    "$scripts_dir"/preprocessing_functional_volume_registration.sh
  fi

  if [[ $step = func_anat_align ]]; then
    echo ""
    echo "****************************************************************************************************"
    echo "* Aligning the functional data to aligned anatomical image"
    echo "****************************************************************************************************"
    echo ""
    "$scripts_dir"/preprocessing_functional_align_to_aligned_anatomical.sh
  fi

  if [[ $step = func_mni_align ]]; then
    echo ""
    echo "****************************************************************************************************"
    echo "* Aligning the functional data to the MNI aligned anatomical image"
    echo "****************************************************************************************************"
    echo ""
    "$scripts_dir"/preprocessing_functional_align_to_mni_anatomical.sh
  fi

  if [[ $step = make_masks ]]; then
    echo ""
    echo "****************************************************************************************************"
    echo "* Making anatomical and functional brain masks"
    echo "****************************************************************************************************"
    echo ""
    "$scripts_dir"/preprocessing_anatomical_functional_masks.sh
  fi

  if [[ $step = mask_func ]]; then
    echo ""
    echo "****************************************************************************************************"
    echo "* Masking the functional data"
    echo "****************************************************************************************************"
    echo ""
    "$scripts_dir"/preprocessing_functional_mask.sh
  fi

  if [[ $step = smooth_me ]]; then
    echo ""
    echo "****************************************************************************************************"
    echo "* Spatially smooth functional data"
    echo "****************************************************************************************************"
    echo ""
    "$scripts_dir"/preprocessing_functional_spatially_smooth.sh
  fi

  if [[ $step = detrend_norm ]]; then
    echo ""
    echo "****************************************************************************************************"
    echo "* Normalizing (aka scaling) and/or detrending the functional data"
    echo "****************************************************************************************************"
    echo ""
    "$scripts_dir"/preprocessing_functional_detrend_normalize.sh
  fi

  if [[ $step = trim_func_v1 ]]; then
    echo ""
    echo "****************************************************************************************************"
    echo "* Fixing timing, mplayer v1"
    echo "****************************************************************************************************"
    echo ""
    "$scripts_dir"/preprocessing_functional_trim_mplayer_v1.sh
  fi

  if [[ $step = timing ]]; then
    echo ""
    echo "****************************************************************************************************"
    echo "* Fixing timing"
    echo "****************************************************************************************************"
    echo ""
    "$scripts_dir"/preprocessing_functional_timing.sh
  fi

  if [[ $step = cat_func ]]; then
    echo ""
    echo "****************************************************************************************************"
    echo "* Concatenating functional data"
    echo "****************************************************************************************************"
    echo ""
    "$scripts_dir"/preprocessing_functional_concatenate.sh
  fi

  if [[ $step = clean_dir ]]; then
    echo ""
    echo "****************************************************************************************************"
    echo "* Moving files to clean up the participants directory"
    echo "****************************************************************************************************"
    echo ""
    "$scripts_dir"/preprocessing_general_move_files.sh
  fi

done

################################################################################
# End
################################################################################
