#!/bin/bash

################################################################################
# Create mean functional image for functional volume registration
################################################################################

# NOTE

for perp in $perps
do
  cd "$data_dir"/"$perp"/
  # set_center_run=1
  rm media_tshift_despike_align_image.nii.gz
  num_files=`ls media_?.nii.gz | wc -l`
  set_center_run=`echo "$((($num_files + 1) / 2))"`
  echo "* There are " $num_files "runs and the centre run will be " $set_center_run
  3dTstat \
      -datum float \
      -mean \
      -prefix media_tshift_despike_align_image.nii.gz \
              media_"$set_center_run"_tshift_despike.nii.gz

################################################################################
# Functional volume registration
################################################################################

# NOTE
# This step aligns each whole brain collection to the alignment image created above
# *** These files get demeaned later in the processing series for use in detrending

  total_num_runs=`ls ./media_?.nii.gz  | wc -l`
  for run in `seq 1 $total_num_runs`
  do
    rm media_"$run"_tshift_despike_reg.nii.gz
    3dvolreg \
        -float -twopass -twodup \
        -1Dfile        files/text_files/media_"$run"_motion.1D \
        -maxdisp1D     files/text_files/media_"$run"_maxdisp.1D \
        -1Dmatrix_save files/text_files/media_"$run"_realign_mat.aff12.1D \
        -base          media_tshift_despike_align_image.nii.gz \
        -prefix        media_"$run"_tshift_despike_reg.nii.gz \
                       media_"$run"_tshift_despike.nii.gz
  done

################################################################################
# Cat motion/max displacement files from functional volume registration
################################################################################

# NOTE
# TODO: Check each participants motion files and put this information into a spreadsheet
# If multiple runs, need to add here
# Always look at plots to see if the data is any good!
# THIS WORKS FOR 1-10 RUNS
# This isn't a very useful file b/c, e.g., timepoints get changed, trucnated later

  for move_type in motion maxdisp
  do
    rm files/text_files/media_"$move_type".1D
    cat \
      files/text_files/media_1_"$move_type".1D  \
      files/text_files/media_2_"$move_type".1D  \
      files/text_files/media_3_"$move_type".1D  \
      files/text_files/media_4_"$move_type".1D  \
      files/text_files/media_5_"$move_type".1D  \
      files/text_files/media_6_"$move_type".1D  \
      files/text_files/media_7_"$move_type".1D  \
      files/text_files/media_8_"$move_type".1D  \
      files/text_files/media_9_"$move_type".1D  \
      files/text_files/media_10_"$move_type".1D \
      > files/text_files/media_"$move_type".1D
      1dplot -pngs 2000 "$move_type"_plot files/text_files/media_"$move_type".1D
    done
done

################################################################################
# End
################################################################################
