#!/bin/bash

################################################################################
# Set up directories, move files/dirs, compress
################################################################################

# NOTE

for perp in $perps
do

  cd "$data_dir"/"$perp"/

  # Make directory structure for both sessions
  mkdir files/
  mkdir files/text_files/
  mkdir files/original_files/
  mkdir files/anatomical_files/
  mkdir files/timeseries_files/

  # bzip2 IMA files?
  bzip2 *IMA

  # Move session 1 files and dirs around
  mv zzNIFTI  files/
  mv zzAFNI   files/
  mv *IMA.bz2 files/original_files/
  mv *.SR     files/original_files/
  mv zzNOTES \
     zzNOTES~ \
     zzDUMPHEADER \
     files/original_files/

  # Compress files to save space/time
  # gzip  files/original_files/*IMA
  gzip  files/zz*/*.nii
  bzip2 files/zz*/*.BRIK

  # Move and rename functional and anatomical images into main directory
  # Currently assumes there are no more than 4 anatomical and 10 media files
  anatomical_01=anatomical_1_"$perp"
  anatomical_02=anatomical_2_"$perp"
  anatomical_03=anatomical_3_"$perp"
  anatomical_04=anatomical_4_"$perp"
  functional_01=functional_1_"$perp"
  functional_02=functional_2_"$perp"
  functional_03=functional_3_"$perp"
  functional_04=functional_4_"$perp"
  functional_05=functional_5_"$perp"
  functional_06=functional_6_"$perp"
  functional_07=functional_7_"$perp"
  functional_08=functional_8_"$perp"
  functional_09=functional_9_"$perp"
  functional_10=functional_10_"$perp"
  cp files/zzNIFTI/"${!anatomical_01}".nii.gz  anatomical_1.nii.gz 2>/dev/null
  cp files/zzNIFTI/"${!anatomical_02}".nii.gz  anatomical_2.nii.gz 2>/dev/null
  cp files/zzNIFTI/"${!anatomical_03}".nii.gz  anatomical_3.nii.gz 2>/dev/null
  cp files/zzNIFTI/"${!anatomical_04}".nii.gz  anatomical_4.nii.gz 2>/dev/null
  cp files/zzNIFTI/"${!functional_01}".nii.gz  media_1.nii.gz 2>/dev/null
  cp files/zzNIFTI/"${!functional_02}".nii.gz  media_2.nii.gz 2>/dev/null
  cp files/zzNIFTI/"${!functional_03}".nii.gz  media_3.nii.gz 2>/dev/null
  cp files/zzNIFTI/"${!functional_04}".nii.gz  media_4.nii.gz 2>/dev/null
  cp files/zzNIFTI/"${!functional_05}".nii.gz  media_5.nii.gz 2>/dev/null
  cp files/zzNIFTI/"${!functional_06}".nii.gz  media_6.nii.gz 2>/dev/null
  cp files/zzNIFTI/"${!functional_07}".nii.gz  media_7.nii.gz 2>/dev/null
  cp files/zzNIFTI/"${!functional_08}".nii.gz  media_8.nii.gz 2>/dev/null
  cp files/zzNIFTI/"${!functional_09}".nii.gz  media_9.nii.gz 2>/dev/null
  cp files/zzNIFTI/"${!functional_10}".nii.gz media_10.nii.gz 2>/dev/null

done

################################################################################
# End
################################################################################
