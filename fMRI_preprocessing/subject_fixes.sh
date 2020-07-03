
######################################################################################################
# sub-1
######################################################################################################

subject="sub-1"
movie="500daysofsummer"
# This participant's last run was only 4 trs
# Thus, to make the same length as all the others, adding these trs to run three by dublicating the last 4 time points
3dTcat \
-prefix "$subject"_task-"$movie"_run-03_bold_tshift_despike_reg_al_mni_longer.nii.gz \
        "$subject"_task-"$movie"_run-03_bold_tshift_despike_reg_al_mni.nii.gz \
       '"$subject"_task-"$movie"_run-03_bold_tshift_despike_reg_al_mni.nii.gz[$]' \
       '"$subject"_task-"$movie"_run-03_bold_tshift_despike_reg_al_mni.nii.gz[$]' \
       '"$subject"_task-"$movie"_run-03_bold_tshift_despike_reg_al_mni.nii.gz[$]' \
       '"$subject"_task-"$movie"_run-03_bold_tshift_despike_reg_al_mni.nii.gz[$]'
3dcopy \
  "$subject"_task-"$movie"_run-03_bold_tshift_despike_reg_al_mni.nii.gz \
  "$subject"_task-"$movie"_run-03_bold_tshift_despike_reg_al_mni_shorter.nii.gz
rm "$subject"_task-"$movie"_run-03_bold_tshift_despike_reg_al_mni.nii.gz
3dcopy \
  "$subject"_task-"$movie"_run-03_bold_tshift_despike_reg_al_mni_longer.nii.gz \
  "$subject"_task-"$movie"_run-03_bold_tshift_despike_reg_al_mni.nii.gz
rm "$subject"_task-"$movie"_run-03_bold_tshift_despike_reg_al_mni_longer.nii.gz
# Now need to add four time points to the "$subject"_task-"$movie"_run-03_bold_motion_demean.1D  regressors by duplicating the final four points
cd ./files/text_files/
last_line=`cat "$subject"_task-"$movie"_run-03_bold_motion_demean.1D | tail -n 1`
cp "$subject"_task-"$movie"_run-03_bold_motion_demean.1D "$subject"_task-"$movie"_run-03_bold_motion_demean_original.1D
echo $last_line >> "$subject"_task-"$movie"_run-03_bold_motion_demean.1D
echo $last_line >> "$subject"_task-"$movie"_run-03_bold_motion_demean.1D
echo $last_line >> "$subject"_task-"$movie"_run-03_bold_motion_demean.1D
echo $last_line >> "$subject"_task-"$movie"_run-03_bold_motion_demean.1D
cd ./files/text_files/
last_line=`cat "$subject"_task-"$movie"_run-03_bold_ventricle_demean.1D | tail -n 1`
cp m"$subject"_task-"$movie"_run-03_bold_ventricle_demean.1D "$subject"_task-"$movie"_run-03_bold_ventricle_demean_original.1D
echo $last_line >> "$subject"_task-"$movie"_run-03_bold_ventricle_demean.1D
echo $last_line >> "$subject"_task-"$movie"_run-03_bold_ventricle_demean.1D
echo $last_line >> "$subject"_task-"$movie"_run-03_bold_ventricle_demean.1D
echo $last_line >> "$subject"_task-"$movie"_run-03_bold_ventricle_demean.1D
cd ./files/text_files/
last_line=`cat "$subject"_task-"$movie"_run-03_bold_wm_demean.1D | tail -n 1`
cp "$subject"_task-"$movie"_run-03_bold_wm_demean.1D "$subject"_task-"$movie"_run-03_bold_wm_demean_original.1D
echo $last_line >> "$subject"_task-"$movie"_run-03_bold_wm_demean.1D
echo $last_line >> "$subject"_task-"$movie"_run-03_bold_wm_demean.1D
echo $last_line >> "$subject"_task-"$movie"_run-03_bold_wm_demean.1D
echo $last_line >> "$subject"_task-"$movie"_run-03_bold_wm_demean.1D
# Verify these are the same length
cat "$subject"_task-"$movie"_run-03_bold_wm_demean.1D | wc -l
cat "$subject"_task-"$movie"_run-03_bold_ventricle_demean.1D | wc -l
cat "$subject"_task-"$movie"_run-03_bold_motion_demean.1D | wc -l

######################################################################################################
# sub-30
######################################################################################################

subject="sub-30"
movie="citizenfour"
# Final run too short, likely the scanner stopped before the credits done
# Thus, to make the same length as all the others, adding these three trs to run three by dublicating the last three time points
3dTcat \
-prefix "$subject"_task-"$movie"_run-03_bold_tshift_despike_reg_al_longer+orig. \
        "$subject"_task-"$movie"_run-03_bold_tshift_despike_reg_al+orig.\
       '"$subject"_task-"$movie"_run-03_bold_tshift_despike_reg_al+orig.[$]' \
       '"$subject"_task-"$movie"_run-03_bold_tshift_despike_reg_al+orig.[$]' \
       '"$subject"_task-"$movie"_run-03_bold_tshift_despike_reg_al+orig.[$]'
3dcopy \
  "$subject"_task-"$movie"_run-03_bold_tshift_despike_reg_al+orig. \
  "$subject"_task-"$movie"_run-03_bold_tshift_despike_reg_al_shorter+orig.
rm "$subject"_task-"$movie"_run-03_bold_tshift_despike_reg_al+orig.*
3dcopy \
  "$subject"_task-"$movie"_run-03_bold_tshift_despike_reg_al_longer+orig. \
  "$subject"_task-"$movie"_run-03_bold_tshift_despike_reg_al+orig.
rm "$subject"_task-"$movie"_run-03_bold_tshift_despike_reg_al_longer+orig.*
# As with sub-1, we now need to add three time points to the "$subject"_task-"$movie"_run-03_bold_motion_demean.1D  regressors by duplicating the final 3 points
# This does not need to be done for "$subject"_task-"$movie"_run-03_bold_ventricle_demean.1D  "$subject"_task-"$movie"_run-03_bold_wm_demean.1D b/c they were made after the padding
cd ./files/text_files/
last_line=`cat "$subject"_task-"$movie"_run-03_bold_motion_demean.1D | tail -n 1`
cp "$subject"_task-"$movie"_run-03_bold_motion_demean.1D "$subject"_task-"$movie"_run-03_bold_motion_demean_original.1D
echo $last_line >> "$subject"_task-"$movie"_run-03_bold_motion_demean.1D
echo $last_line >> "$subject"_task-"$movie"_run-03_bold_motion_demean.1D
echo $last_line >> "$subject"_task-"$movie"_run-03_bold_motion_demean.1D
# Verify these are the same length
cat "$subject"_task-"$movie"_run-03_bold_wm_demean.1D | wc -l
cat "$subject"_task-"$movie"_run-03_bold_motion_demean.1D | wc -l

######################################################################################################
# sub-40
######################################################################################################

subject="sub-40"
movie="theusualsuspects"
# file is 7 trs short
# All preprocessing got to the end so just adding the trs before the concat step
for filename in norm polort norm_polort norm_polort_motion norm_polort_motion_wm_ventricle
do
  for blur in "" "_blur6"
  do
    cp "$subject"_task-"$movie"_run-02_bold_tshift_despike_reg_al_mni_mask"$blur"_"$filename"_timing.nii.gz \
       "$subject"_task-"$movie"_run-02_bold_tshift_despike_reg_al_mni_mask"$blur"_"$filename"_timing_orig.nii.gz
    rm "$subject"_task-"$movie"_run-02_bold_tshift_despike_reg_al_mni_mask"$blur"_"$filename"_timing.nii.gz
    3dTcat \
      -prefix "$subject"_task-"$movie"_run-02_bold_tshift_despike_reg_al_mni_mask"$blur"_"$filename"_timing.nii.gz \
              "$subject"_task-"$movie"_run-02_bold_tshift_despike_reg_al_mni_mask"$blur"_"$filename"_timing_orig.nii.gz \
              "$subject"_task-"$movie"_run-02_bold_tshift_despike_reg_al_mni_mask"$blur"_"$filename"_timing_orig.nii.gz[$] \
              "$subject"_task-"$movie"_run-02_bold_tshift_despike_reg_al_mni_mask"$blur"_"$filename"_timing_orig.nii.gz[$] \
              "$subject"_task-"$movie"_run-02_bold_tshift_despike_reg_al_mni_mask"$blur"_"$filename"_timing_orig.nii.gz[$] \
              "$subject"_task-"$movie"_run-02_bold_tshift_despike_reg_al_mni_mask"$blur"_"$filename"_timing_orig.nii.gz[$] \
              "$subject"_task-"$movie"_run-02_bold_tshift_despike_reg_al_mni_mask"$blur"_"$filename"_timing_orig.nii.gz[$] \
              "$subject"_task-"$movie"_run-02_bold_tshift_despike_reg_al_mni_mask"$blur"_"$filename"_timing_orig.nii.gz[$] \
              "$subject"_task-"$movie"_run-02_bold_tshift_despike_reg_al_mni_mask"$blur"_"$filename"_timing_orig.nii.gz[$]
  done
done

######################################################################################################
# sub-71
######################################################################################################

subject="sub-71"
movie="split"
# 4th run is 2 TRs short
for blur in "" "_blur6"
do
  cp "$subject"_task-"$movie"_run-04_bold_tshift_despike_reg_al_mni_mask"$blur".nii.gz \
     "$subject"_task-"$movie"_run-04_bold_tshift_despike_reg_al_mni_mask"$blur"_orig.nii.gz
  rm "$subject"_task-"$movie"_run-04_bold_tshift_despike_reg_al_mni_mask"$blur".nii.gz
  3dTcat \
    -prefix "$subject"_task-"$movie"_run-04_bold_tshift_despike_reg_al_mni_mask"$blur".nii.gz \
            "$subject"_task-"$movie"_run-04_bold_tshift_despike_reg_al_mni_mask"$blur"_orig.nii.gz \
            "$subject"_task-"$movie"_run-04_bold_tshift_despike_reg_al_mni_mask"$blur"_orig.nii.gz[$] \
            "$subject"_task-"$movie"_run-04_bold_tshift_despike_reg_al_mni_mask"$blur"_orig.nii.gz[$]
done
# Add two time points to the "$subject"_task-"$movie"_run-04_bold_motion_demean.1D  regressors by duplicating the final 2 points
cd ./files/text_files/
for file_type in wm ventricle motion
do
  cp "$subject"_task-"$movie"_run-04_bold_"$file_type"_demean_original.1D "$subject"_task-"$movie"_run-04_bold_"$file_type"_demean.1D
  last_line=`cat "$subject"_task-"$movie"_run-04_bold_"$file_type"_demean.1D | tail -n 1`
  echo $last_line
  cp "$subject"_task-"$movie"_run-04_bold_"$file_type"_demean.1D "$subject"_task-"$movie"_run-04_bold_"$file_type"_demean_original.1D
  echo $last_line >> "$subject"_task-"$movie"_run-04_bold_"$file_type"_demean.1D
  echo $last_line >> "$subject"_task-"$movie"_run-04_bold_"$file_type"_demean.1D
  echo $last_line >> "$subject"_task-"$movie"_run-04_bold_"$file_type"_demean.1D
  echo $last_line >> "$subject"_task-"$movie"_run-04_bold_"$file_type"_demean.1D
  echo $last_line >> "$subject"_task-"$movie"_run-04_bold_"$file_type"_demean.1D
  echo $last_line >> "$subject"_task-"$movie"_run-04_bold_"$file_type"_demean.1D
done
# # Verify these are the same length
cat "$subject"_task-"$movie"_run-04_bold_wm_demean_original.1D | wc -l
cat "$subject"_task-"$movie"_run-04_bold_wm_demean.1D | wc -l

######################################################################################################
# sub-48
######################################################################################################

subject="sub-48"
movie="pulpfiction"
 
# Fix alignment cause of relocalising
cd ./func/"$subject"
# Check to see if grids are diffent and if so, subsequent steps will need resampling
3dinfo "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | grep extent
# Rename files for subsequent steps
cp "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3 4
do
  cp "$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike.nii.gz "$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_pre_zeropad.nii.gz
done
# Add some space so the functional can actually be moved around in that space
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3dZeropad \
-S 15 -I 15 \
-prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz  \
        "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3 4
do
  rm "$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_pre_resample.nii.gz
  3dZeropad \
  -S 15 -I 15 \
  -prefix "$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_pre_resample.nii.gz  \
          "$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_pre_zeropad.nii.gz
done
 
# Resample
for run in 1 2 3 4
do
  rm "$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_pre_nudge.nii.gz
  3dresample \
    -prefix "$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_pre_nudge.nii.gz \
    -master "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
    -input  "$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_pre_resample.nii.gz
done
 
# Nudge datasets closer to alignment image
rm "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz
3drotate \
-Fourier -rotate 0.00I 7.00R -2.00A -ashift 20.00S -3.00L -23.00P \
-prefix "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz  \
        "$subject"_task-"$movie"_run-01_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz
3drotate \
-Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
-prefix "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz  \
        "$subject"_task-"$movie"_run-02_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz
3drotate \
-Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
-prefix "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz  \
        "$subject"_task-"$movie"_run-03_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-04_bold_tshift_despike.nii.gz
3drotate \
-Fourier -rotate -4.00I -4.00R 1.00A -ashift 1.00S 6.00L -1.00P \
-prefix "$subject"_task-"$movie"_run-04_bold_tshift_despike.nii.gz  \
        "$subject"_task-"$movie"_run-04_bold_tshift_despike_pre_nudge.nii.gz

# 3dvolreg
total_num_runs=`ls ./"$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz  | wc -l`
for run in `seq 1 $total_num_runs`
do
  mkdir -p ./files/text_files/
  rm "$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_reg.nii.gz
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_bold_motion.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_bold_maxdisp.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_bold_realign_mat.aff12.1D
  3dvolreg \
      -float -twopass -twodup \
      -1Dfile        files/text_files/"$subject"_task-"$movie"_run-0"$run"_bold_motion.1D \
      -maxdisp1D     files/text_files/"$subject"_task-"$movie"_run-0"$run"_bold_maxdisp.1D \
      -1Dmatrix_save files/text_files/"$subject"_task-"$movie"_run-0"$run"_bold_realign_mat.aff12.1D \
      -base          "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
      -prefix        "$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike_reg.nii.gz \
                     "$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike.nii.gz
done
# Alignment to anatomy
# Set centre run again
num_files=`ls "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | wc -l`
set_center_run=`echo "$((($num_files + 1) / 2))"`
# Remove any old files
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
3dTstat \
    -datum float \
    -mean \
    -prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
            "$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike_reg.nii.gz
# Align
# -giant_move -cost lpc+ZZ -partial_coverage
rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
align_epi_anat.py \
-epi2anat -ginormous_move -cost lpc+ZZ -partial_coverage -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
-anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
-epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
-child_epi \
"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg.nii.gz
# Remove residual files
rm __tt*
rm *_mat.aff12.1D

######################################################################################################
# sub-16
######################################################################################################

subject="sub-16"
movie="500daysofsummer"
# Fix alignment
cd ./func/"$subject"
# Check to see if grids are diffent and if so, subsequent steps will need resampling
3dinfo "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | grep extent
# Rename files for subsequent steps
cp "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3
do
  cp "$subject"_task-"$movie"_run-0"$run"_bold_tshift_despike.nii.gz "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done

# Add some space so the functional can actually be moved around in that space
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3dZeropad \
-S 15 -I 15 \
-prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz  \
        "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
  3dZeropad \
  -S 15 -I 15 \
  -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz  \
          "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done

# Resample
for run in 1 2 3
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz
  3dresample \
    -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz \
    -master "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
    -input  "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
done

# Nudge datasets closer to alignment image
rm "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz
3drotate \
-Fourier -rotate 0.00I -1.00R 0.00A -ashift 3.00S 0.00L -1.00P \
-prefix "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz  \
        "$subject"_task-"$movie"_run-01_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz
3drotate \
-Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
-prefix "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz  \
        "$subject"_task-"$movie"_run-02_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz
3drotate \
-Fourier -rotate 3.00I 2.00R -2.00A -ashift 9.00S -7.00L -1.00P \
-prefix "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz  \
        "$subject"_task-"$movie"_run-03_bold_tshift_despike_pre_nudge.nii.gz

# 3dvolreg
total_num_runs=`ls ./"$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz  | wc -l`
for run in `seq 1 $total_num_runs`
do
  mkdir -p ./files/text_files/
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D
  3dvolreg \
      -float -twopass -twodup \
      -1Dfile        files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D \
      -maxdisp1D     files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D \
      -1Dmatrix_save files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D \
      -base          "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
      -prefix        "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz \
                     "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz
done

# Alignment to anatomy
# Set centre run again
num_files=`ls "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | wc -l`
set_center_run=`echo "$((($num_files + 1) / 2))"`
# Remove any old files
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
3dTstat \
    -datum float \
    -mean \
    -prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
            "$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike_reg.nii.gz

# Align
# -giant_move -cost lpc+ZZ -partial_coverage
rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
align_epi_anat.py \
-epi2anat -ginormous_move -cost lpc+ZZ -partial_coverage -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
-anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
-epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
-child_epi \
"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg.nii.gz
# Remove residual files
rm __tt*
rm *_mat.aff12.1D

######################################################################################################
# sub-51
######################################################################################################

subject="sub-51"
movie="theshawshankredemption"
cd ./func/"$subject"
# run 1 is only few TR long cause it was ran with 700ms 4TR total (less than 8 sec)
# rename all other files accordingly after removing run 1
# the new run 1 (used to be run 2) needs 3 extra TRs at the beginning to fix the previous media's error
# do this at the tshift step
cp "$subject"_task-"$movie"_run-01_bold_tshift.nii.gz \
   "$subject"_task-"$movie"_run-01_bold_tshift_orig.nii.gz
rm "$subject"_task-"$movie"_run-01_bold_tshift.nii.gz
3dTcat \
  -prefix "$subject"_task-"$movie"_run-01_bold_tshift.nii.gz \
          "$subject"_task-"$movie"_run-01_bold_tshift_orig.nii.gz[0] \
          "$subject"_task-"$movie"_run-01_bold_tshift_orig.nii.gz[0] \
          "$subject"_task-"$movie"_run-01_bold_tshift_orig.nii.gz[0] \
          "$subject"_task-"$movie"_run-01_bold_tshift_orig.nii.gz
cd ./func/"$subject"
rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
    align_epi_anat.py \
      -epi2anat -giant_move cost -lpc+ZZ -partial_coverage -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
      -anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
      -epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
      -child_epi \
       "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg.nii.gz
# Remove residual files
rm __tt*
rm *_mat.aff12.1D


######################################################################################################
# sub-24
######################################################################################################

subject="sub-24"
movie="citizenfour"
cd ./func/"$subject"
# fix alignment
# Rename files for subsequent steps
mv "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_pre_zeropad.nii.gz
for run in 1 2 3 4
do
  mv "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg_pre_zeropad.nii.gz
done
# Add some space so the functional can actually be moved around in that space
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_pre_nudge.nii.gz
3dZeropad \
-S 15 -I 15 \
-prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_pre_nudge.nii.gz  \
        "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_pre_zeropad.nii.gz
for run in 1 2 3 4
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg_pre_nudge.nii.gz
  3dZeropad \
  -S 15 -I 15 \
  -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg_pre_nudge.nii.gz  \
          "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg_pre_zeropad.nii.gz
done
# Nudge (runs 1-4) closer into place
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
3drotate \
  -quintic -clipit -rotate 0.00I -8.00R 0.00A -ashift -25.00S 0.00L 10.00P \
  -prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz  \
          "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_pre_nudge.nii.gz
for run in 1 2 3 4
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz
  3drotate \
    -quintic -clipit -rotate 0.00I -8.00R 0.00A -ashift -25.00S 0.00L 10.00P \
    -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz  \
            "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg_pre_nudge.nii.gz
done
# Align:
# Things that didn't work:
# -giant_move -cost lpc+ZZ -partial_coverage
# -partial_coverage
rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
align_epi_anat.py \
-epi2anat -cost lpa -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
-anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
-epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
-child_epi \
"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg.nii.gz
# Remove residual files
rm __tt*
rm *_mat.aff12.1D

######################################################################################################
# sub-42
######################################################################################################

subject="sub-42"
movie="theusualsuspects"

cd ./func/"$subject"
# fix alignment
# Check to see if grids are diffent and if so, subsequent steps will need resampling
3dinfo "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | grep extent
# Rename files for subsequent steps
mv "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2
do
  mv "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
# Add some space so the functional can actually be moved around in that space
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3dZeropad \
-S 15 -I 15 \
-prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz  \
        "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
  3dZeropad \
  -S 15 -I 15 \
  -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz  \
          "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
# Resample 
for run in 1 2
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz
  3dresample \
    -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz \
    -master "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
    -input  "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
done
# Nudge datasets closer to alignment image
rm "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz
3drotate \
-Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
-prefix "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz  \
        "$subject"_task-"$movie"_run-01_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz
3drotate \
-Fourier -rotate 0.00I 4.00R 0.00A -ashift 11.00S 0.00L 1.00P \
-prefix "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz  \
        "$subject"_task-"$movie"_run-02_bold_tshift_despike_pre_nudge.nii.gz

# Test 3dvolreg
total_num_runs=`ls ./"$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz  | wc -l`
for run in `seq 1 $total_num_runs`
do
   rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz
   rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D
   rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D
   rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D
   3dvolreg \
       -float -twopass -twodup \
       -1Dfile        files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D \
       -maxdisp1D     files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D \
       -1Dmatrix_save files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D \
       -base          "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
       -prefix        "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz \
                      "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz
done
# Test volume alignment
# Set centre run again
num_files=`ls "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | wc -l`
set_center_run=`echo "$((($num_files + 1) / 2))"`
# Remove any old files
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
3dTstat \
    -datum float \
    -mean \
    -prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
            "$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike_reg.nii.gz
# Align
rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
align_epi_anat.py \
-epi2anat -giant_move -cost lpc+ZZ -partial_coverage -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
-anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
-epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
-child_epi \
"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg.nii.gz
# Remove residual files
rm __tt*
rm *_mat.aff12.1D

######################################################################################################
# sub-12
######################################################################################################

subject="sub-12"
movie="500daysofsummer"

cd ./func/"$subject"
# fix alignment
# Check to see if grids are diffent and if so, subsequent steps will need resampling
3dinfo "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | grep extent
# Rename files for subsequent steps
mv "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2
do
  mv "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
# Add some space so the functional can actually be moved around in that space
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3dZeropad \
-S 15 -I 15 \
-prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz  \
        "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
  3dZeropad \
  -S 15 -I 15 \
  -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz  \
          "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
# Resample
for run in 1 2
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz
  3dresample \
    -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz \
    -master "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
    -input  "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
done

# Nudge datasets closer to alignment image
rm "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz
3drotate \
-Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
-prefix "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz  \
        "$subject"_task-"$movie"_run-01_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz
3drotate \
-Fourier -rotate 0.00I 9.00R 0.00A -ashift 21.00S 0.00L -8.00P \
-prefix "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz  \
        "$subject"_task-"$movie"_run-02_bold_tshift_despike_pre_nudge.nii.gz
 
# 3dvolreg
total_num_runs=`ls ./"$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz  | wc -l`
for run in `seq 1 $total_num_runs`
do
  mkdir -p ./files/text_files/
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D
  3dvolreg \
      -float -twopass -twodup \
      -1Dfile        files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D \
      -maxdisp1D     files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D \
      -1Dmatrix_save files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D \
      -base          "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
      -prefix        "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz \
                     "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz
done

# Alignment to anatomy
# Set centre run again
num_files=`ls "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | wc -l`
set_center_run=`echo "$((($num_files + 1) / 2))"`
# Remove any old files
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
3dTstat \
    -datum float \
    -mean \
    -prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
            "$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike_reg.nii.gz
# Align
# -giant_move -cost lpc+ZZ -partial_coverage
rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
align_epi_anat.py \
-epi2anat -ginormous_move -cost lpc+ZZ -partial_coverage -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
-anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
-epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
-child_epi \
"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg.nii.gz
# Remove residual files
rm __tt*
rm *_mat.aff12.1D


######################################################################################################
# sub-68
######################################################################################################

subject="sub-68"
movie="backtothefuture"

cd ./func/"$subject"
# fix alignment
# Check to see if grids are diffent and if so, subsequent steps will need resampling
3dinfo "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | grep extent
# Rename files for subsequent steps
cp "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3 4 5
do
  cp "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
# Add some space so the functional can actually be moved around in that space
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3dZeropad \
-S 15 -I 15 \
-prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz  \
        "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3 4 5
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
  3dZeropad \
  -S 15 -I 15 \
  -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz  \
          "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
# Resample
for run in 1 2 3 4 5
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz
  3dresample \
    -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz \
    -master "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
    -input  "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
done

rm "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz
3drotate \
-Fourier -rotate 0.00I -5.00R 0.00A -ashift -10.00S 0.00L 1.00P \
-prefix "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz  \
        "$subject"_task-"$movie"_run-01_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz
3drotate \
-Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
-prefix "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz  \
        "$subject"_task-"$movie"_run-02_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz
3drotate \
-Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
-prefix "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz  \
        "$subject"_task-"$movie"_run-03_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-04_bold_tshift_despike.nii.gz
3drotate \
-Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
-prefix "$subject"_task-"$movie"_run-04_bold_tshift_despike.nii.gz  \
        "$subject"_task-"$movie"_run-04_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-05_bold_tshift_despike.nii.gz
3drotate \
-Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
-prefix "$subject"_task-"$movie"_run-05_bold_tshift_despike.nii.gz  \
        "$subject"_task-"$movie"_run-05_bold_tshift_despike_pre_nudge.nii.gz
# 3dvolreg
total_num_runs=`ls ./"$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz  | wc -l`
for run in `seq 1 $total_num_runs`
do
  mkdir -p ./files/text_files/
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D
  3dvolreg \
      -float -twopass -twodup \
      -1Dfile        files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D \
      -maxdisp1D     files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D \
      -1Dmatrix_save files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D \
      -base          "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
      -prefix        "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz \
                     "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz
done
# Alignment to anatomy
# Set centre run again
num_files=`ls "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | wc -l`
set_center_run=`echo "$((($num_files + 1) / 2))"`
# Remove any old files
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
3dTstat \
    -datum float \
    -mean \
    -prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
            "$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike_reg.nii.gz
 
# Align
# -giant_move -cost lpc+ZZ -partial_coverage
rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
align_epi_anat.py \
-epi2anat -ginormous_move -cost lpc+ZZ -partial_coverage -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
-anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
-epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
-child_epi \
"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg.nii.gz
# Remove residual files
rm __tt*
rm *_mat.aff12.1D


######################################################################################################
# sub-81
######################################################################################################

subject="sub-81"
movie="12yearsaslave"

cd ./func/"$subject"
# fix alignment
# Check to see if grids are diffent and if so, subsequent steps will need resampling
3dinfo "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | grep extent
# Rename files for subsequent steps
cp "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3
do
  cp "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
# Add some space so the functional can actually be moved around in that space
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3dZeropad \
-S 15 -I 15 \
-prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz  \
        "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
  3dZeropad \
  -S 15 -I 15 \
  -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz  \
          "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
# Resample 
for run in 1 2 3
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz
  3dresample \
    -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz \
    -master "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
    -input  "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
done
 
# Nudge datasets closer to alignment image
rm "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz
3drotate \
-Fourier -rotate 0.00I -2.00R 0.00A -ashift -8.00S 0.00L 2.00P \
-prefix "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz  \
        "$subject"_task-"$movie"_run-01_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz
3drotate \
-Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
-prefix "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz  \
        "$subject"_task-"$movie"_run-02_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz
3drotate \
-Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
-prefix "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz  \
        "$subject"_task-"$movie"_run-03_bold_tshift_despike_pre_nudge.nii.gz
# 3dvolreg
total_num_runs=`ls ./"$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz  | wc -l`
for run in `seq 1 $total_num_runs`
do
  mkdir -p ./files/text_files/
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D
  3dvolreg \
      -float -twopass -twodup \
      -1Dfile        files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D \
      -maxdisp1D     files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D \
      -1Dmatrix_save files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D \
      -base          "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
      -prefix        "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz \
                     "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz
done
 
# Alignment to anatomy
# Set centre run again
num_files=`ls "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | wc -l`
set_center_run=`echo "$((($num_files + 1) / 2))"`
# Remove any old files
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
3dTstat \
    -datum float \
    -mean \
    -prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
            "$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike_reg.nii.gz
 
# Align
# -giant_move -cost lpc+ZZ -partial_coverage
rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
align_epi_anat.py \
-epi2anat -ginormous_move -cost lpc+ZZ -partial_coverage -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
-anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
-epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
-child_epi \
"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg.nii.gz
# Remove residual files
rm __tt*
rm *_mat.aff12.1D


######################################################################################################
# sub-6
######################################################################################################

subject="sub-6"
movie="500daysofsummer"

cd ./func/"$subject"
# fix alignment
# Check to see if grids are diffent and if so, subsequent steps will need resampling
3dinfo "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | grep extent
# Rename files for subsequent steps
cp "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2
do
  cp "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done

# Add some space so the functional can actually be moved around in that space
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3dZeropad \
-S 15 -I 15 \
-prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz  \
        "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
  3dZeropad \
  -S 15 -I 15 \
  -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz  \
          "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
# Resample
for run in 1 2
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz
  3dresample \
    -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz \
    -master "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
    -input  "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
done

# Nudge datasets closer to alignment image
rm "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-01_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I -4.00R 0.00A -ashift -8.00S 0.00L 1.00P \
  -prefix "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-02_bold_tshift_despike_pre_nudge.nii.gz
 
# 3dvolreg
total_num_runs=`ls ./"$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz  | wc -l`
for run in `seq 1 $total_num_runs`
do
  mkdir -p ./files/text_files/
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D
  3dvolreg \
      -float -twopass -twodup \
      -1Dfile        files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D \
      -maxdisp1D     files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D \
      -1Dmatrix_save files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D \
      -base          "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
      -prefix        "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz \
                     "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz
done
 
# Alignment to anatomy
# Set centre run again
num_files=`ls "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | wc -l`
set_center_run=`echo "$((($num_files + 1) / 2))"`
# Remove any old files
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
3dTstat \
    -datum float \
    -mean \
    -prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
            "$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike_reg.nii.gz
# Align
# -giant_move -cost lpc+ZZ -partial_coverage
rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
align_epi_anat.py \
-epi2anat -ginormous_move -cost lpc+ZZ -partial_coverage -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
-anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
-epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
-child_epi \
"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg.nii.gz
# Remove residual files
rm __tt*
rm *_mat.aff12.1D


######################################################################################################
# sub-27
######################################################################################################

subject="sub-27"
movie="citizenfour"

cd ./func/"$subject"
# fix alignment
# Check to see if grids are diffent and if so, subsequent steps will need resampling
3dinfo "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | grep extent
# Rename files for subsequent steps
cp "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3
do
  cp "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
 
# Add some space so the functional can actually be moved around in that space
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3dZeropad \
-S 15 -I 15 \
-prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz  \
        "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
  3dZeropad \
  -S 15 -I 15 \
  -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz  \
          "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
# Resample
for run in 1 2 3
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz
  3dresample \
    -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz \
    -master "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
    -input  "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
done
# Nudge datasets closer to alignment image
rm "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-01_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-02_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate -3.00I -4.00R -0.00A -ashift 5.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-03_bold_tshift_despike_pre_nudge.nii.gz

# 3dvolreg
total_num_runs=`ls ./"$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz  | wc -l`
for run in `seq 1 $total_num_runs`
do
  mkdir -p ./files/text_files/
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp_delt.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D
  3dvolreg \
      -float -twopass -twodup \
      -1Dfile        files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D \
      -maxdisp1D     files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D \
      -1Dmatrix_save files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D \
      -base          "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
      -prefix        "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz \
                     "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz
done
 
# Alignment to anatomy
# Set centre run again
num_files=`ls "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | wc -l`
set_center_run=`echo "$((($num_files + 1) / 2))"`
# Remove any old files
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
3dTstat \
    -datum float \
    -mean \
    -prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
            "$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike_reg.nii.gz

# Align
# -giant_move -cost lpc+ZZ -partial_coverage
rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
align_epi_anat.py \
-epi2anat -ginormous_move -cost lpc+ZZ -partial_coverage -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
-anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
-epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
-child_epi \
"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg.nii.gz
# Remove residual files
rm __tt*
rm *_mat.aff12.1D


######################################################################################################
# sub-17
######################################################################################################

subject="sub-17"
movie="500daysofsummer"

cd ./func/"$subject"
 
# fix alignment
# Check to see if grids are diffent and if so, subsequent steps will need resampling
3dinfo "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | grep extent
# Rename files for subsequent steps
cp "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2
do
  cp "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
# Add some space so the functional can actually be moved around in that space
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3dZeropad \
-S 15 -I 15 \
-prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz  \
        "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
  3dZeropad \
  -S 15 -I 15 \
  -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz  \
          "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
# Resample
for run in 1 2
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz
  3dresample \
    -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz \
    -master "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
    -input  "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
done
 
# Nudge datasets closer to alignment image
rm "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-01_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 0.00R 0.00A -ashift 11.00S 0.00L -5.00P \
  -prefix "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-02_bold_tshift_despike_pre_nudge.nii.gz
# 3dvolreg
total_num_runs=`ls ./"$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz  | wc -l`
for run in `seq 1 $total_num_runs`
do
  mkdir -p ./files/text_files/
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp_delt.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D
  3dvolreg \
      -float -twopass -twodup \
      -1Dfile        files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D \
      -maxdisp1D     files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D \
      -1Dmatrix_save files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D \
      -base          "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
      -prefix        "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz \
                     "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz
done

# Alignment to anatomy
# Set centre run again
num_files=`ls "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | wc -l`
set_center_run=`echo "$((($num_files + 1) / 2))"`
# Remove any old files
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
3dTstat \
    -datum float \
    -mean \
    -prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
            "$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike_reg.nii.gz
# Align
# -giant_move -cost lpc+ZZ -partial_coverage
rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
align_epi_anat.py \
-epi2anat -ginormous_move -cost lpc+ZZ -partial_coverage -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
-anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
-epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
-child_epi \
"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg.nii.gz
# Remove residual files
rm __tt*
rm *_mat.aff12.1D


######################################################################################################
# sub-28
######################################################################################################

subject="sub-28"
movie="citizenfour"

cd ./func/"$subject"
 
# fix alignment
# Check to see if grids are diffent and if so, subsequent steps will need resampling
3dinfo "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | grep extent

# Rename files for subsequent steps
cp "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3 4 5
do
  cp "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
# Add some space so the functional can actually be moved around in that space
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3dZeropad \
-S 15 -I 15 \
-prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz  \
        "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3 4 5
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
  3dZeropad \
  -S 15 -I 15 \
  -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz  \
          "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
# Resample
for run in 1 2 3 4 5
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz
  3dresample \
    -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz \
    -master "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
    -input  "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
done
# Nudge datasets closer to alignment image
rm "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 2.00I 8.00R 2.00A -ashift 12.00S 0.00L 2.00P \
  -prefix "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-01_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 2.00I 8.00R 2.00A -ashift 12.00S 0.00L 2.00P \
  -prefix "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-02_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-03_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-04_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-04_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-04_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-05_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-05_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-05_bold_tshift_despike_pre_nudge.nii.gz
# 3dvolreg
total_num_runs=`ls ./"$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz  | wc -l`
for run in `seq 1 $total_num_runs`
do
  mkdir -p ./files/text_files/
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp_delt.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D
  3dvolreg \
      -float -twopass -twodup \
      -1Dfile        files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D \
      -maxdisp1D     files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D \
      -1Dmatrix_save files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D \
      -base          "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
      -prefix        "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz \
                     "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz
done
# Alignment to anatomy
# Set centre run again
num_files=`ls "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | wc -l`
set_center_run=`echo "$((($num_files + 1) / 2))"`
# Remove any old files
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
3dTstat \
    -datum float \
    -mean \
    -prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
            "$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike_reg.nii.gz
 
# Align
# -giant_move -cost lpc+ZZ -partial_coverage
rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
align_epi_anat.py \
-epi2anat -ginormous_move -cost lpc+ZZ -partial_coverage -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
-anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
-epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
-child_epi \
"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg.nii.gz
# Remove residual files
rm __tt*
rm *_mat.aff12.1D


######################################################################################################
# sub-75
######################################################################################################

subject="sub-75"
movie="littlemisssunshine"

cd ./func/"$subject"
 
# fix alignment
# Check to see if grids are diffent and if so, subsequent steps will need resampling
3dinfo "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | grep extent
# Rename files for subsequent steps
cp "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3
do
  cp "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
# Add some space so the functional can actually be moved around in that space
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3dZeropad \
-S 15 -I 15 \
-prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz  \
        "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
  3dZeropad \
  -S 15 -I 15 \
  -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz  \
          "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done

# Resample
for run in 1 2 3
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz
  3dresample \
    -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz \
    -master "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
    -input  "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
done 
# Nudge datasets closer to alignment image
rm "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 0.00R 0.00A -ashift 7.00S 0.00L -2.00P \
  -prefix "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-01_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-02_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-03_bold_tshift_despike_pre_nudge.nii.gz
# 3dvolreg
total_num_runs=`ls ./"$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz  | wc -l`
for run in `seq 1 $total_num_runs`
do
  mkdir -p ./files/text_files/
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp_delt.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D
  3dvolreg \
      -float -twopass -twodup \
      -1Dfile        files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D \
      -maxdisp1D     files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D \
      -1Dmatrix_save files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D \
      -base          "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
      -prefix        "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz \
                     "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz
done

# Alignment to anatomy
# Set centre run again
num_files=`ls "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | wc -l`
set_center_run=`echo "$((($num_files + 1) / 2))"`
# Remove any old files
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
3dTstat \
    -datum float \
    -mean \
    -prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
            "$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike_reg.nii.gz
# Align
# -giant_move -cost lpc+ZZ -partial_coverage
rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
align_epi_anat.py \
-epi2anat -ginormous_move -cost lpc+ZZ -partial_coverage -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
-anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
-epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
-child_epi \
"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg.nii.gz
# Remove residual files
rm __tt*
rm *_mat.aff12.1D

######################################################################################################
# sub-32
######################################################################################################

subject="sub-32"
movie="citizenfour"
cd ./func/"$subject"
 
# fix alignment
# Check to see if grids are diffent and if so, subsequent steps will need resampling
3dinfo "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | grep extent

# Rename files for subsequent steps
cp "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3
do
  cp "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done

# Add some space so the functional can actually be moved around in that space
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3dZeropad \
-S 15 -I 15 \
-prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz  \
        "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
  3dZeropad \
  -S 15 -I 15 \
  -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz  \
          "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
# Resample
for run in 1 2 3
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz
  3dresample \
    -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz \
    -master "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
    -input  "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
done
# Nudge datasets closer to alignment image
rm "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 5.00R 0.00A -ashift -1.00S 0.00L 1.00P \
  -prefix "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-01_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 1.00R 0.00A -ashift 0.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-02_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 1.00R 0.00A -ashift 0.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-03_bold_tshift_despike_pre_nudge.nii.gz
 
# 3dvolreg
total_num_runs=`ls ./"$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz  | wc -l`
for run in `seq 1 $total_num_runs`
do
  mkdir -p ./files/text_files/
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp_delt.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D
  3dvolreg \
      -float -twopass -twodup \
      -1Dfile        files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D \
      -maxdisp1D     files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D \
      -1Dmatrix_save files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D \
      -base          "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
      -prefix        "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz \
                     "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz
done
 
# Alignment to anatomy
# Set centre run again
num_files=`ls "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | wc -l`
set_center_run=`echo "$((($num_files + 1) / 2))"`
# Remove any old files
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
3dTstat \
    -datum float \
    -mean \
    -prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
            "$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike_reg.nii.gz
 
# Align
# -giant_move -cost lpc+ZZ -partial_coverage
rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
align_epi_anat.py \
-epi2anat -ginormous_move -cost lpc+ZZ -partial_coverage -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
-anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
-epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
-child_epi \
"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg.nii.gz
# Remove residual files
rm __tt*
rm *_mat.aff12.1D

######################################################################################################
# sub-45
######################################################################################################

subject="sub-45"
movie="pulpfiction"

cd ./func/"$subject"
 
# fix alignment
# Check to see if grids are diffent and if so, subsequent steps will need resampling
3dinfo "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | grep extent
# Rename files for subsequent steps
cp "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3 4 5
do
  cp "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
# Add some space so the functional can actually be moved around in that space
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3dZeropad \
-S 15 -I 15 \
-prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz  \
        "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3 4 5
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
  3dZeropad \
  -S 15 -I 15 \
  -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz  \
          "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
# Resample
for run in 1 2 3 4 5
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz
  3dresample \
    -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz \
    -master "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
    -input  "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
done
 
# Nudge datasets closer to alignment image
rm "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 2.00I -1.00R -5.00A -ashift 3.00S 0.00L 2.00P \
  -prefix "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-01_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz
3drotate \
  -Fourier  -rotate 2.01I -1.00R -5.00A -ashift 0.00S 0.00L 2.00P \
  -prefix "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-02_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-03_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-04_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-04_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-04_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-05_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-05_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-05_bold_tshift_despike_pre_nudge.nii.gz
# 3dvolreg
total_num_runs=`ls ./"$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz  | wc -l`
for run in `seq 1 $total_num_runs`
do
  mkdir -p ./files/text_files/
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp_delt.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D
  3dvolreg \
      -float -twopass -twodup \
      -1Dfile        files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D \
      -maxdisp1D     files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D \
      -1Dmatrix_save files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D \
      -base          "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
      -prefix        "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz \
                     "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz
done

# Alignment to anatomy
# Set centre run again
num_files=`ls "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | wc -l`
set_center_run=`echo "$((($num_files + 1) / 2))"`
# Remove any old files
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
3dTstat \
    -datum float \
    -mean \
    -prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
            "$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike_reg.nii.gz

# Align
rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
align_epi_anat.py \
-epi2anat -ginormous_move -cost lpc+ZZ -partial_coverage -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
-anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
-epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
-child_epi \
"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg.nii.gz
# Remove residual files
rm __tt*
rm *_mat.aff12.1D

######################################################################################################
# sub-34
######################################################################################################

subject="sub-34"
movie="citizenfour"

cd ./func/"$subject"
# fix alignment
# Check to see if grids are diffent and if so, subsequent steps will need resampling
3dinfo "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | grep extent
# Rename files for subsequent steps
cp "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3
do
  cp "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
# Add some space so the functional can actually be moved around in that space
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3dZeropad \
-S 15 -I 15 \
-prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz  \
        "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
  3dZeropad \
  -S 15 -I 15 \
  -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz  \
          "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
# Resample
for run in 1 2 3
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz
  3dresample \
    -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz \
    -master "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
    -input  "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
done
# Nudge datasets closer to alignment image
rm "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 1.00R -1.00A -ashift -10.00S 0.00L 6.00P \
  -prefix "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-01_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz
3drotate \
  -Fourier  -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-02_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 3.00R 0.00A -ashift 0.00S 0.00L -1.00P \
  -prefix "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-03_bold_tshift_despike_pre_nudge.nii.gz
# 3dvolreg
total_num_runs=`ls ./"$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz  | wc -l`
for run in `seq 1 $total_num_runs`
do
  mkdir -p ./files/text_files/
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp_delt.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D
  3dvolreg \
      -float -twopass -twodup \
      -1Dfile        files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D \
      -maxdisp1D     files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D \
      -1Dmatrix_save files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D \
      -base          "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
      -prefix        "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz \
                     "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz
done
# Alignment to anatomy
# Set centre run again
num_files=`ls "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | wc -l`
set_center_run=`echo "$((($num_files + 1) / 2))"`
# Remove any old files
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
3dTstat \
    -datum float \
    -mean \
    -prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
            "$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike_reg.nii.gz

# Align
rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
align_epi_anat.py \
-epi2anat -ginormous_move -cost lpc+ZZ -partial_coverage -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
-anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
-epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
-child_epi \
"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg.nii.gz
# Remove residual files
rm __tt*
rm *_mat.aff12.1D


######################################################################################################
# sub-35
######################################################################################################

subject="sub-35"
movie="citizenfour"

cd ./func/"$subject"
 
# fix alignment
# Check to see if grids are diffent and if so, subsequent steps will need resampling
3dinfo "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | grep extent
# Rename files for subsequent steps
cp "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3
do
  cp "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
# Add some space so the functional can actually be moved around in that space
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3dZeropad \
-S 15 -I 15 \
-prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz  \
        "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
  3dZeropad \
  -S 15 -I 15 \
  -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz  \
          "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
# Resample
for run in 1 2 3
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz
  3dresample \
    -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz \
    -master "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
    -input  "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
done

# Nudge datasets closer to alignment image
rm "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 2.00I 8.00R 2.00A -ashift 8.05S 2.00L -2.00P \
  -prefix "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-01_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-02_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-03_bold_tshift_despike_pre_nudge.nii.gz

# 3dvolreg
total_num_runs=`ls ./"$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz  | wc -l`
for run in `seq 1 $total_num_runs`
do
  mkdir -p ./files/text_files/
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp_delt.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D
  3dvolreg \
      -float -twopass -twodup \
      -1Dfile        files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D \
      -maxdisp1D     files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D \
      -1Dmatrix_save files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D \
      -base          "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
      -prefix        "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz \
                     "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz
done
# Alignment to anatomy
# Set centre run again
num_files=`ls "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | wc -l`
set_center_run=`echo "$((($num_files + 1) / 2))"`
# Remove any old files
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
3dTstat \
    -datum float \
    -mean \
    -prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
            "$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike_reg.nii.gz
# Align
rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
align_epi_anat.py \
-epi2anat -ginormous_move -cost lpc+ZZ -partial_coverage -Allineate_opts '-maxscl 1.001' -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
-anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
-epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
-child_epi \
"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg.nii.gz
# Remove residual files
rm __tt*
rm *_mat.aff12.1D

######################################################################################################
# sub-66
######################################################################################################

subject="sub-66"
movie="backtothefuture"

cd ./func/"$subject"
 
# fix alignment
# Check to see if grids are diffent and if so, subsequent steps will need resampling
3dinfo "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | grep extent

# Rename files for subsequent steps
cp "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2
do
  cp "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
# Add some space so the functional can actually be moved around in that space
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3dZeropad \
-S 15 -I 15 \
-prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz  \
        "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
  3dZeropad \
  -S 15 -I 15 \
  -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz  \
          "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
# Resample
for run in 1 2
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz
  3dresample \
    -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz \
    -master "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
    -input  "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
done
# Nudge datasets closer to alignment image
rm "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz
3drotate \
  -Fourier  -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-01_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I -6.00R 0.00A -ashift -4.00S 0.00L 4.00P \
  -prefix "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-02_bold_tshift_despike_pre_nudge.nii.gz
# 3dvolreg
total_num_runs=`ls ./"$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz  | wc -l`
for run in `seq 1 $total_num_runs`
do
  mkdir -p ./files/text_files/
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp_delt.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D
  3dvolreg \
      -float -twopass -twodup \
      -1Dfile        files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D \
      -maxdisp1D     files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D \
      -1Dmatrix_save files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D \
      -base          "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
      -prefix        "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz \
                     "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz
done

# Alignment to anatomy
# Set centre run again
num_files=`ls "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | wc -l`
set_center_run=`echo "$((($num_files + 1) / 2))"`
# Remove any old files
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
3dTstat \
    -datum float \
    -mean \
    -prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
            "$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike_reg.nii.gz
# Align
rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
align_epi_anat.py \
-epi2anat -ginormous_move -cost lpc+ZZ -partial_coverage -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
-anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
-epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
-child_epi \
"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg.nii.gz
# Remove residual files
rm __tt*
rm *_mat.aff12.1D

######################################################################################################
# sub-55
######################################################################################################

subject="sub-55"
movie="theshawshankredemption"

cd ./func/"$subject"
 
# fix alignment
# Check to see if grids are diffent and if so, subsequent steps will need resampling
3dinfo "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | grep extent
# Rename files for subsequent steps
cp "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3 4
do
  cp "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
# Add some space so the functional can actually be moved around in that space
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3dZeropad \
-S 15 -I 15 \
-prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz  \
        "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3 4
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
  3dZeropad \
  -S 15 -I 15 \
  -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz  \
          "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done

# Resample
for run in 1 2 3 4
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz
  3dresample \
    -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz \
    -master "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
    -input  "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
done
# Nudge datasets closer to alignment image
rm "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I -1.00R 0.00A -ashift -2.00S 0.00L 3.00P \
  -prefix "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-01_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-02_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate -3.00I -4.00R 0.00A -ashift 7.00S 0.00L -1.00P \
  -prefix "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-03_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-04_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate -1.00I 1.00R 0.00A -ashift 12.00S 0.00L -5.00P \
  -prefix "$subject"_task-"$movie"_run-04_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-04_bold_tshift_despike_pre_nudge.nii.gz
# 3dvolreg
total_num_runs=`ls ./"$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz  | wc -l`
for run in `seq 1 $total_num_runs`
do
  mkdir -p ./files/text_files/
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp_delt.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D
  3dvolreg \
      -float -twopass -twodup \
      -1Dfile        files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D \
      -maxdisp1D     files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D \
      -1Dmatrix_save files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D \
      -base          "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
      -prefix        "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz \
                     "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz
done
 
# Alignment to anatomy
# Set centre run again
num_files=`ls "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | wc -l`
set_center_run=`echo "$((($num_files + 1) / 2))"`
# Remove any old files
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
3dTstat \
    -datum float \
    -mean \
    -prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
            "$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike_reg.nii.gz
 
# Align
rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
align_epi_anat.py \
-epi2anat -ginormous_move -cost lpc+ZZ -partial_coverage -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
-anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
-epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
-child_epi \
"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg.nii.gz
# Remove residual files
rm __tt*
rm *_mat.aff12.1D


######################################################################################################
# sub-76
######################################################################################################

subject="sub-76"
mmovie="littlemisssunshine"

cd ./func/"$subject"
 
3dTstat -datum float -mean -prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz
for run in 1 2 3 4
do
  mv "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz
done
 
# Rename files for subsequent steps
cp "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3 4
do
  cp "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
 
# Add some space so the functional can actually be moved around in that space
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_nudge.nii.gz
3dZeropad \
-S 5 -I 30 -P 15 \
-prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_nudge.nii.gz  \
        "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3 4
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
  3dZeropad \
  -S 5 -I 30 -P 15 \
  -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz  \
          "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
 
# Resample
for run in 1 2 3 4
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz
  3dresample \
    -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz \
    -master "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_nudge.nii.gz \
    -input  "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
done
 
# Nudge datasets closer to alignment image
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3drotate \
  -Fourier -rotate 0.00I -13.00R 0.00A -ashift -30.00S 0.00L 4.00P \
  -prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz  \
          "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz
3drotate \
-Fourier -rotate 0.00I -13.00R 0.00A -ashift -30.00S 0.00L 4.00P \
  -prefix "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-01_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz
3drotate \
-Fourier -rotate 0.00I -13.00R 0.00A -ashift -30.00S 0.00L 4.00P \
  -prefix "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-02_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz
3drotate \
-Fourier -rotate 0.00I -13.00R 0.00A -ashift -30.00S 0.00L 4.00P \
  -prefix "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-03_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-04_bold_tshift_despike.nii.gz
3drotate \
-Fourier -rotate 0.00I -13.00R 0.00A -ashift -30.00S 0.00L 4.00P \
  -prefix "$subject"_task-"$movie"_run-04_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-04_bold_tshift_despike_pre_nudge.nii.gz
 
# 3dvolreg
total_num_runs=`ls ./"$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz  | wc -l`
for run in `seq 1 $total_num_runs`
do
  mkdir -p ./files/text_files/
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp_delt.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D
  3dvolreg \
      -float -twopass -twodup \
      -1Dfile        files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D \
      -maxdisp1D     files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D \
      -1Dmatrix_save files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D \
      -base          "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
      -prefix        "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz \
                     "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz
done
 
# Alignment to anatomy
# Set centre run again
num_files=`ls "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | wc -l`
set_center_run=`echo "$((($num_files + 1) / 2))"`
# Remove any old files
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
3dTstat \
    -datum float \
    -mean \
    -prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
            "$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike_reg.nii.gz

rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
align_epi_anat.py \
-epi2anat -cost lpc+ -Allineate_opts '-maxscl 1.01' -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
-anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
-epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
rm __tt*
rm *_mat.aff12.1D

######################################################################################################
# sub-46
######################################################################################################

subject="sub-46"
movie="pulpfiction"

cd ./func/"$subject"
 
# Check to see if grids are diffent and if so, subsequent steps will need resampling
3dinfo "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | grep extent
 
# Rename files for subsequent steps
cp "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3 4 5 6
do
  cp "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
 
# Add some space so the functional can actually be moved around in that space
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3dZeropad \
-S 15 -I 15 \
-prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz  \
        "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3 4 5 6
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
  3dZeropad \
  -S 15 -I 15 \
  -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz  \
          "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
 
# Resample
for run in 1 2 3 4 5 6
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz
  3dresample \
    -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz \
    -master "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
    -input  "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
done
 
# Nudge datasets closer to alignment image
rm "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz
3drotate \
  -Fourier  -rotate 1.00I 0.00R 0.00A -ashift 1.00S 1.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-01_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I -1.00R 0.00A -ashift 3.00S 1.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-02_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-03_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-04_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-04_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-04_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-05_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-05_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-05_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-06_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate -1.00I 1.00R 0.00A -ashift -4.00S 2.00L -3.00P \
  -prefix "$subject"_task-"$movie"_run-06_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-06_bold_tshift_despike_pre_nudge.nii.gz
 
# 3dvolreg
total_num_runs=`ls ./"$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz  | wc -l`
for run in `seq 1 $total_num_runs`
do
  mkdir -p ./files/text_files/
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp_delt.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D
  3dvolreg \
      -float -twopass -twodup \
      -1Dfile        files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D \
      -maxdisp1D     files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D \
      -1Dmatrix_save files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D \
      -base          "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
      -prefix        "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz \
                     "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz
done
 
# Alignment to anatomy
# Set centre run again
num_files=`ls "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | wc -l`
set_center_run=`echo "$((($num_files + 1) / 2))"`
# Remove any old files
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
3dTstat \
    -datum float \
    -mean \
    -prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
            "$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike_reg.nii.gz
 
# Align
rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
align_epi_anat.py \
-epi2anat -ginormous_move -cost lpc+ZZ -partial_coverage -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
-anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
-epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
-child_epi \
"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg.nii.gz
# Remove residual files
rm __tt*
rm *_mat.aff12.1D


######################################################################################################
# sub-11
######################################################################################################

subject="sub-11"
movie="500daysofsummer"

cd ./func/"$subject"
 
# Redo skull strip in AFNI as it does a better job in this case
3dSkullStrip \
  -push_to_edge \
  -prefix ../anat/"$subject"_T1w_avg_uni_ns_afni.nii.gz \
  -input  ../anat/"$subject"_T1w_avg.nii.gz
 

# Rename files for subsequent steps
cp "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3
do
  cp "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
 
# Add some space so the functional can actually be moved around in that space
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_nudge.nii.gz
3dZeropad \
-S 15 -I 15 \
-prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_nudge.nii.gz  \
        "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
  3dZeropad \
  -S 15 -I 15 \
  -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz  \
          "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
 
# Resample
for run in 1 2 3
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz
  3dresample \
    -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz \
    -master "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_nudge.nii.gz \
    -input  "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
done
 
# Nudge datasets closer to alignment image
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3drotate \
  -Fourier -rotate 0.00I -8.00R 0.00A -ashift -14.00S 0.00L 10.00P \
  -prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz  \
          "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate -1.00I -7.00R 0.00A -ashift -16.00S 0.00L 10.00P \
  -prefix "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-01_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate -1.00I -7.00R 0.00A -ashift -13.00S 0.00L 10.00P \
  -prefix "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-02_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I -8.00R 0.00A -ashift -14.00S 0.00L 10.00P \
  -prefix "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-03_bold_tshift_despike_pre_nudge.nii.gz
 
# 3dvolreg
total_num_runs=`ls ./"$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz  | wc -l`
for run in `seq 1 $total_num_runs`
do
  mkdir -p ./files/text_files/
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp_delt.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D
  3dvolreg \
      -float -twopass -twodup \
      -1Dfile        files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D \
      -maxdisp1D     files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D \
      -1Dmatrix_save files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D \
      -base          "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
      -prefix        "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz \
                     "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz
done
 
# Alignment to anatomy
# Set centre run again
num_files=`ls "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | wc -l`
set_center_run=`echo "$((($num_files + 1) / 2))"`
# Remove any old files
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
3dTstat \
    -datum float \
    -mean \
    -prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
            "$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike_reg.nii.gz
rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
align_epi_anat.py \
-epi2anat -partial_coverage -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
-anat ../anat/"$subject"_T1w_avg_uni_ns_afni.nii.gz \
-epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
-child_epi \
"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg.nii.gz
# Remove residual files
rm __tt*
rm *_mat.aff12.1D


######################################################################################################
# sub-2
######################################################################################################

subject="sub-2"
movie="500daysofsummer"

cd ./func/"$subject"
 
# Check to see if grids are diffent and if so, subsequent steps will need resampling
3dinfo "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | grep extent
 
# Rename files for subsequent steps
cp "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3
do
  cp "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
 
# Add some space so the functional can actually be moved around in that space
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3dZeropad \
-S 15 -I 15 \
-prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz  \
        "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
  3dZeropad \
  -S 15 -I 15 \
  -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz  \
          "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
 
# Resample
for run in 1 2 3
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz
  3dresample \
    -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz \
    -master "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
    -input  "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
done
 
# Nudge datasets closer to alignment image
rm "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate -1.00I 1.00R 0.00A -ashift -2.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-01_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate -1.00I 1.00R 0.00A -ashift 1.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-02_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-03_bold_tshift_despike_pre_nudge.nii.gz
 
# 3dvolreg
total_num_runs=`ls ./"$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz  | wc -l`
for run in `seq 1 $total_num_runs`
do
  mkdir -p ./files/text_files/
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp_delt.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D
  3dvolreg \
      -float -twopass -twodup \
      -1Dfile        files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D \
      -maxdisp1D     files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D \
      -1Dmatrix_save files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D \
      -base          "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
      -prefix        "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz \
                     "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz
done
 
# Alignment to anatomy
# Set centre run again
num_files=`ls "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | wc -l`
set_center_run=`echo "$((($num_files + 1) / 2))"`
# Remove any old files
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
3dTstat \
    -datum float \
    -mean \
    -prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
            "$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike_reg.nii.gz
 
# Align
rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
align_epi_anat.py \
-epi2anat -ginormous_move -cost lpc+ZZ -partial_coverage -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
-anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
-epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
-child_epi \
"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg.nii.gz
# Remove residual files
rm __tt*
rm *_mat.aff12.1D


######################################################################################################
# sub-33
######################################################################################################

subject="sub-33"
movie="citizenfour"

cd ./func/"$subject"
 
# Rename files for subsequent steps
cp "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3
do
  cp "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
 
# Add some space so the functional can actually be moved around in that space
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3dZeropad \
-S 15 -I 15 \
-prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz  \
        "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
  3dZeropad \
  -S 15 -I 15 \
  -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz  \
          "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
 
# Resample
for run in 1 2 3
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz
  3dresample \
    -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz \
    -master "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
    -input  "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
done
 
# Nudge datasets closer to alignment image
rm "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I -1.00R 0.00A -ashift 1.00S 0.00L 1.00P \
  -prefix "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-01_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-02_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-03_bold_tshift_despike_pre_nudge.nii.gz
 
# 3dvolreg
total_num_runs=`ls ./"$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz  | wc -l`
for run in `seq 1 $total_num_runs`
do
  mkdir -p ./files/text_files/
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp_delt.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D
  3dvolreg \
      -float -twopass -twodup \
      -1Dfile        files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D \
      -maxdisp1D     files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D \
      -1Dmatrix_save files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D \
      -base          "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
      -prefix        "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz \
                     "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz
done
 
# Alignment to anatomy
# Set centre run again
num_files=`ls "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | wc -l`
set_center_run=`echo "$((($num_files + 1) / 2))"`
# Remove any old files
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
3dTstat \
    -datum float \
    -mean \
    -prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
            "$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike_reg.nii.gz
 
# Align
rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
align_epi_anat.py \
-epi2anat -ginormous_move -cost lpc+ZZ -partial_coverage -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
-anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
-epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
-child_epi \
"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg.nii.gz
# Remove residual files
rm __tt*
rm *_mat.aff12.1D
 
######################################################################################################
# sub-77
######################################################################################################

subject="sub-77"
movie="littlemisssunshine"

cd ./func/"$subject"
 
# Rename files for subsequent steps
cp "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2
do
  cp "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
 
# Add some space so the functional can actually be moved around in that space
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3dZeropad \
-S 15 -I 15 \
-prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz  \
        "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
  3dZeropad \
  -S 15 -I 15 \
  -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz  \
          "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
 
# Resample
for run in 1 2
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz
  3dresample \
    -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz \
    -master "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
    -input  "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
done
 
# Nudge datasets closer to alignment image
rm "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 1.00R 0.00A -ashift 3.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-01_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I 0.00R 0.00A -ashift 0.00S 0.00L 0.00P \
  -prefix "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-02_bold_tshift_despike_pre_nudge.nii.gz
 
# 3dvolreg
total_num_runs=`ls ./"$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz  | wc -l`
for run in `seq 1 $total_num_runs`
do
  mkdir -p ./files/text_files/
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp_delt.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D
  3dvolreg \
      -float -twopass -twodup \
      -1Dfile        files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D \
      -maxdisp1D     files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D \
      -1Dmatrix_save files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D \
      -base          "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
      -prefix        "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz \
                     "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz
done
 
# Alignment to anatomy
# Set centre run again
num_files=`ls "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | wc -l`
set_center_run=`echo "$((($num_files + 1) / 2))"`
# Remove any old files
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
3dTstat \
    -datum float \
    -mean \
    -prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
            "$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike_reg.nii.gz
 
# Align
rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
align_epi_anat.py \
-epi2anat -ginormous_move -cost lpc+ZZ -partial_coverage -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
-anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
-epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
-child_epi \
"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg.nii.gz
# Remove residual files
rm __tt*
rm *_mat.aff12.1D



######################################################################################################
# sub-73
######################################################################################################

subject="sub-73"
movie="split"

cd ./func/"$subject"
 
# Rename files for subsequent steps
cp "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3
do
  cp "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
 
# Add some space so the functional can actually be moved around in that space
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3dZeropad \
-S 15 -I 15 \
-prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz  \
        "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
  3dZeropad \
  -S 15 -I 15 \
  -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz  \
          "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
 
# Resample
for run in 1 2 3
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz
  3dresample \
    -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz \
    -master "$subject"_task-"$movie"_bold_tshift_despike_align_image_prenudge.nii.gz \
    -input  "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
done
 
# Nudge datasets closer to alignment image
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3drotate \
  -Fourier -rotate 0.00I -20.00R 0.00A -ashift -39.00S 0.00L 14.00P \
  -prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz  \
          "$subject"_task-"$movie"_bold_tshift_despike_align_image_prenudge.nii.gz
rm "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I -20.00R 0.00A -ashift -39.00S 0.00L 14.00P \
  -prefix "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-01_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I -20.00R 0.00A -ashift -39.00S 0.00L 14.00P \
  -prefix "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-02_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I -22.00R 0.00A -ashift -35.00S 0.00L 14.00P \
  -prefix "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-03_bold_tshift_despike_pre_nudge.nii.gz
 
# 3dvolreg
total_num_runs=`ls ./"$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz  | wc -l`
for run in `seq 1 $total_num_runs`
do
  mkdir -p ./files/text_files/
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp_delt.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D
  3dvolreg \
      -float -twopass -twodup \
      -1Dfile        files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D \
      -maxdisp1D     files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D \
      -1Dmatrix_save files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D \
      -base          "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
      -prefix        "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz \
                     "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz
done
 
# Alignment to anatomy
# Set centre run again
num_files=`ls "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | wc -l`
set_center_run=`echo "$((($num_files + 1) / 2))"`
# Remove any old files
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
3dTstat \
    -datum float \
    -mean \
    -prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
            "$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike_reg.nii.gz
 
# Align
rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
align_epi_anat.py \
-epi2anat -ginormous_move -cost lpc+ZZ -partial_coverage -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
-anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
-epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
-child_epi \
"$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg.nii.gz
# Remove residual files
rm __tt*
rm *_mat.aff12.1D


######################################################################################################
# sub-31
######################################################################################################

subject="sub-31"
movie="citizenfour"

cd ./func/"$subject"
 
# Rename files for subsequent steps
cp "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3
do
  cp "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
 
# Add some space so the functional can actually be moved around in that space
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3dZeropad \
-S 15 -I 15 \
-prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_nudge.nii.gz  \
        "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_zeropad.nii.gz
for run in 1 2 3
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
  3dZeropad \
  -S 15 -I 15 \
  -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz  \
          "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_zeropad.nii.gz
done
 
# Resample
for run in 1 2 3
do
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz
  3dresample \
    -prefix "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_nudge.nii.gz \
    -master "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_nudge.nii.gz \
    -input  "$subject"_task-"$movie"_run-0"$run"_tshift_despike_pre_resample.nii.gz
done
 
# Nudge datasets closer to alignment image
# "$subject"_task-"$movie"_run-01_bold_tshift_despike_reg_1.nii.gz "$subject"_task-"$movie"_run-01_bold_tshift_despike_reg_1_zeropad_pre_nudged.nii.gz
rm "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz
3drotate \
  -Fourier -rotate 0.00I -16.00R 0.00A -ashift -30.00S 0.00L 12.00P \
  -prefix "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz  \
          "$subject"_task-"$movie"_bold_tshift_despike_align_image_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate -1.00I -18.00R -1.00A -ashift -28.00S 0.00L 11.00P \
  -prefix "$subject"_task-"$movie"_run-01_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-01_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I -16.00R 0.00A -ashift -30.00S 0.00L 12.00P \
  -prefix "$subject"_task-"$movie"_run-02_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-02_bold_tshift_despike_pre_nudge.nii.gz
rm "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz
3drotate \
  -Fourier -rotate 0.00I -16.00R 0.00A -ashift -30.00S 0.00L 12.00P \
  -prefix "$subject"_task-"$movie"_run-03_bold_tshift_despike.nii.gz  \
          "$subject"_task-"$movie"_run-03_bold_tshift_despike_pre_nudge.nii.gz
 
# 3dvolreg
total_num_runs=`ls ./"$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz  | wc -l`
for run in `seq 1 $total_num_runs`
do
  mkdir -p ./files/text_files/
  rm "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp_delt.1D
  rm files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D
  3dvolreg \
      -float -twopass -twodup \
      -1Dfile        files/text_files/"$subject"_task-"$movie"_run-0"$run"_motion.1D \
      -maxdisp1D     files/text_files/"$subject"_task-"$movie"_run-0"$run"_maxdisp.1D \
      -1Dmatrix_save files/text_files/"$subject"_task-"$movie"_run-0"$run"_realign_mat.aff12.1D \
      -base          "$subject"_task-"$movie"_bold_tshift_despike_align_image.nii.gz \
      -prefix        "$subject"_task-"$movie"_run-0"$run"_tshift_despike_reg.nii.gz \
                     "$subject"_task-"$movie"_run-0"$run"_tshift_despike.nii.gz
done
 
# Alignment to anatomy
# Set centre run again
num_files=`ls "$subject"_task-"$movie"_run-0?_bold_tshift_despike.nii.gz | wc -l`
set_center_run=`echo "$((($num_files + 1) / 2))"`
# Remove any old files
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
3dTstat \
    -datum float \
    -mean \
    -prefix "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz \
            "$subject"_task-"$movie"_run-0"$set_center_run"_bold_tshift_despike_reg.nii.gz
 
rm __tt*
rm *_mat.aff12.1D
rm "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image_al+orig*
rm "$subject"_task-"$movie"_run-0?_bold_tshift_despike_reg_al+orig*
align_epi_anat.py \
-epi2anat -cost lpc+ -Allineate_opts '-maxscl 1.01' -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
-anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
-epi  "$subject"_task-"$movie"_bold_tshift_despike_reg_align_image.nii.gz
rm __tt*
rm *_mat.aff12.1D


######################################################################################################
# sub-(18 49 50 52 53)
######################################################################################################

subjects="sub-49 sub-50 sub-18 sub-52 sub-53"
for subject in $subjects
do
  cd ./func/"$subject"
  rm __tt*
  rm *_mat.aff12.1D
  rm "$subject"_task-*_bold_tshift_despike_reg_align_image_al+orig*
  rm "$subject"_task-*_run-0?_bold_tshift_despike_reg_al+orig*
      align_epi_anat.py \
        -epi2anat -giant_move cost -lpc+ZZ -partial_coverage -deoblique on -anat_has_skull no -tshift off -volreg off -epi_base 0 \
        -anat ../anat/"$subject"_T1w_avg_uni_ns.nii.gz \
        -epi  "$subject"_task-*_bold_tshift_despike_reg_align_image.nii.gz \
        -child_epi \
         "$subject"_task-*_run-0?_bold_tshift_despike_reg.nii.gz
  # Remove residual files
  rm __tt*
  rm *_mat.aff12.1D
done
