#!/bin/bash

################################################################################
# Deoblique
################################################################################

# NOTES
# Why didn't I do this earlier? Aligns EPI to anatomy perfectly
# Help says:
# ** N.B.: EPI time series data should be time shifted with 3dTshift before rotating the volumes to a cardinal direction
# Thus the prior step

# 3dWarp -deoblique \
# -prefix "$data_dir"/"$perp_dir"/media_"$run"_tshift_deoblique.nii.gz \
#        ''$data_dir'/'$perp_dir'/media_'$run'_tshift.nii.gz'

################################################################################
# End
################################################################################
