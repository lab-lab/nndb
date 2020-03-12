#!/bin/bash

################################################################################
# Make NIFTI files if needed
################################################################################

# NOTE
# Simply makes nifti/nii files from afni formated files

for perp in $perps
do
    cd "$data_dir"/"$perp"/
    mkdir ./zzNIFTI
    afni_files=`ls zzAFNI/*HEAD | sed 's/\// /g' | awk '{print $2}'`
    for afni_file in $afni_files
    do
      afni_nifti_file=`echo $afni_file | sed 's/+orig.HEAD/.nii.gz/g'`
      # echo $afni_file
      # echo $afni_nifti_file
      3dcopy ./zzAFNI/"$afni_file" ./zzNIFTI/"$afni_nifti_file"
    done
done

################################################################################
# End
################################################################################
