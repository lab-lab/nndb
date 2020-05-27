#!/bin/bash

################################################################################
# Create mean functional image for functional volume registration
################################################################################


for subject in $participants
do
  cd "$subject"/
  rm ./func/"$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
  num_files=`ls ./func/"$subject"_task-"$movie"_run-0?_bold.nii.gz | wc -l`
  set_center_run=`echo "$((($num_files + 1) / 2))"`
  echo "* There are " $num_files "runs and the centre run will be " $set_center_run
  3dTstat \
      -datum float \
      -mean \
      -prefix ./func/"$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
              ./func/"$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike.nii.gz

################################################################################
# Functional volume registration
################################################################################

# NOTE
# This step aligns each whole brain collection to the alignment image created above
# *** These files get demeaned later in the processing series for use in detrending

  total_num_runs=`ls ./func/"$subject"_task-"$movie"_run-0?_bold.nii.gz | wc -l`
  for run in `seq 1 $total_num_runs`
  do
    rm ./func/"$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_reg.nii.gz
    3dvolreg \
        -float -twopass -twodup \
        -1Dfile        files/text_files/"$subject"_task-"$movie"_run-0"$run"_bold_motion.1D \
        -maxdisp1D     files/text_files/"$subject"_task-"$movie"_run-0"$run"_bold_maxdisp.1D \
        -1Dmatrix_save files/text_files/"$subject"_task-"$movie"_run-0"$run"_bold_realign_mat.aff12.1D \
        -base          ./func/"$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
        -prefix        ./func/"$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_reg.nii.gz \
                       ./func/"$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike.nii.gz
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
    rm files/text_files/"$subject"_task-"$movie"_bold_"$move_type".1D
    cat \
      files/text_files/"$subject"_task-"$movie"_run-01_bold_"$move_type".1D  \
      files/text_files/"$subject"_task-"$movie"_run-02_bold_"$move_type".1D  \
      files/text_files/"$subject"_task-"$movie"_run-03_bold_"$move_type".1D  \
      files/text_files/"$subject"_task-"$movie"_run-04_bold_"$move_type".1D  \
      files/text_files/"$subject"_task-"$movie"_run-05_bold_"$move_type".1D  \
      files/text_files/"$subject"_task-"$movie"_run-06_bold_"$move_type".1D  \
      files/text_files/"$subject"_task-"$movie"_run-07_bold_"$move_type".1D  \
      files/text_files/"$subject"_task-"$movie"_run-08_bold_"$move_type".1D  \
      files/text_files/"$subject"_task-"$movie"_run-09_bold_"$move_type".1D  \
      files/text_files/"$subject"_task-"$movie"_run-10_bold_"$move_type".1D \
      > files/text_files/"$subject"_task-"$movie"_bold_"$move_type".1D
      1dplot -pngs 2000 "$move_type"_plot files/text_files/"$subject"_task-"$movie"_bold_"$move_type".1D
    done
done

################################################################################
# End
################################################################################
