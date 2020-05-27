#!/bin/bash

################################################################################
# Inflate MNI aligned anatomical image with Freesurfer
################################################################################

# NOTE
# Freesurfer cannot deal with special characters, in this case '@' in the directory name
# This explains the moving of files around to new directories below
# If running it in the background is desirable use, for example:
# nohup recon-all -all -subjid Freesurfer -i filename.nii >& /dev/null &
# To see if it is still running use, for example:
# tail -n 1 -f /sub-1/freesurfer/scripts/recon-all.log

for subject in $participants
do

    cd "$subject"/
    # Make Freesurfer directory structure
    mksubjdirs \
        freesurfer

    # Make freesrurfer compatible anatomical and put it in the correct directory
    mri_convert \
        -it nii -ot mgz \
        .
        /anat/"$subject"_T1w.aw.nii.gz \
        ./freesurfer/mri/orig/001.mgz

    # Run Freesurfer to make surfaces and get the anatomical parcellation
    export SUBJECTS_DIR="$subject"

    nohup recon-all \
          -all \
          -subjid freesurfer >& /dev/null &

done

################################################################################
# End
################################################################################
