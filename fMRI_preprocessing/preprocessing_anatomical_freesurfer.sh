#!/bin/bash

################################################################################
# Inflate MNI aligned anatomical image with Freesurfer
################################################################################

# NOTE
# Freesurfer cannot deal with special characters, in this case '@' in the directory name
# This explains the moving of files around to new directories below
# If running it in the background is desirable use, for example:
# nohup recon-all -all -subjid Freesurfer -i anatomy.nii >& /dev/null &
# To see if it is still running use, for example:
# tail -n 1 -f /data/5th_grader/6389/freesurfer/scripts/recon-all.log
# Have tried
# spmregister --s "$perp" --mov media_1.nii.gz --reg register.dat

# See which finished without errors
# perps=""
# for perp in $perps
# do
#     echo "***************************************************************************************" $perp
#     tail -n 1 /usr/local/freesurfer/subjects/"$perp"/scripts/recon-all.log
# done

for perp in $perps
do

    cd "$data_dir"/"$perp"/
    # Make Freesurfer directory structure
    mksubjdirs \
        freesurfer

    # Make freesrurfer compatible anatomical and put it in the correct directory
    mri_convert \
        -it nii -ot mgz \
        ./anatomical_avg.aw.nii.gz \
        ./freesurfer/mri/orig/001.mgz

    # Move new Freesurfer directory to a new place (b/c of '@' issue)
    # sudo mv ./"$perp" /usr/local/freesurfer/subjects/
    # Pause
    # sudo chown -R jskipper /usr/local/freesurfer/subjects/"$perp"

    # Run Freesurfer to make surfaces and get the anatomical parcellation
    export SUBJECTS_DIR="$data_dir"/"$perp"

    nohup recon-all \
          -all \
          -subjid freesurfer >& /dev/null &

done

################################################################################
# End
################################################################################
