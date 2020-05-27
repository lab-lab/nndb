#!/bin/bash

################################################################################
# Artifact and outlier rejection tests
################################################################################

# NOTE
# Useful to have open:
# Hand classification of fMRI ICA noise components
# https://www.sciencedirect.com/science/article/pii/S1053811916307583
# which can be reduced by constraining the maximum number of components (e.g., 250 is set as the maximum for HCP preprocessing)
# See section on smoothing
# Should expect about 85% to be noise

################################################################################
# Run melodic to find artifacts
################################################################################

ts_file="$subject"_task-"$movie"_bold_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing
num_dim="250"
for subject in $participants
do
  cd "$subject"/
  melodic \
    --dim="$num_dim" --tr=1.0 --nobet --report --Oall \
    --outdir=ica_artifiact_d"$num_dim"_"$ts_file" \
    --mask=anatomical_mask.nii.gz \
    --bgimage=./anat/"$subject"_T1w_mask.nii.gz \
    --in=./func/"$ts_file".nii.gz
done

################################################################################
# Go through each subject by hand to remove ICA artifacts (EXAMPLE SCRIPT)
################################################################################

# This below is an example script for a participant. Need to set each subject manually for now
ts_file="$subject"_task-"$movie"_bold_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing
num_dim="250"
cd "$subject"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anat/"$subject"_T1w_avg.aw.nii.gz ./

# In the echo command insert the numbers of components that are selected as noise
# This should be a list of numbers
cd "$subject"/files/text_files/
echo "" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

################################################################################
# Build artifactual component regressor
################################################################################

# NOTE
# Set variables above
# Loop through labeled artifacts and rename timeseries files to include 'temp_'
# The 1D files containing ICA artifactual timecourses are found in /derivatives/sub-<ID>/func/<filename>.1D
cd "$subject"/
num_artis=`cat files/text_files/"$ts_file"_d"$num_dim"_artifacts.txt | wc | awk '{print $2}'`
while read arti_num; do
  echo "**************************************************" $arti_num
  cat  ica_artifiact_d"$num_dim"_"$ts_file"/report/t"$arti_num".txt \
     > ica_artifiact_d"$num_dim"_"$ts_file"/report/temp_t"$arti_num".1D
done < files/text_files/"$ts_file"_d"$num_dim"_artifacts.txt
# Concatenate 'temp_'s into one file
1dcat ica_artifiact_d"$num_dim"_"$ts_file"/report/temp_t*.1D \
    > files/text_files/"$ts_file"_d"$num_dim"_artifact_ics.1D
# Remove 'temp_' files
rm ica_artifiact_d"$num_dim"_"$ts_file"/report/temp_t*.1D
echo "**************************************************" $num_artis "**************************************************"

################################################################################
# Remove artifactual components from the functional data
################################################################################

cd "$subject"/
mkdir derivatives/
mkdir derivatives/func/
3dTproject \
-norm \
-ort files/text_files/"$ts_file"_d"$num_dim"_artifact_ics.1D \
-mask ./anat/"$subject"_T1w_mask.nii.gz \
-prefix ./derivatives/func/"$subject"_task-"$movie"_bold_preprocessedICA.nii.gz \
-input  ./func/"$ts_file".nii.gz


################################################################################
# End
################################################################################
