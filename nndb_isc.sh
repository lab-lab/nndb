#!/bin/bash

source ~/.bashrc

##########################################
# INTERSUBJECT CORRELATION ACROSS MOVIES
##########################################

path="/data/movie/fmri/participants/adults"
cd $path

ls -d {12_years_a_slave,the_prestige,little_miss_sunshine,the_usual_suspects,back_to_the_future,citizenfour,split,500_days,the_shawshank_redemption,pulp_fiction}/[0-9][0-9][0-9][0-9][0-9][0-9][A-Z][A-Z]

# define subject list based on folders in each movie directory
subjects=($(ls -d {12_years_a_slave,the_prestige,little_miss_sunshine,the_usual_suspects,back_to_the_future,citizenfour,split,500_days,the_shawshank_redemption,pulp_fiction}/[0-9][0-9][0-9][0-9][0-9][0-9][A-Z][A-Z])) #subject ID 6 numbers + 2 letters

# define number of subjects
num_subjects=${#subjects[@]}
echo number of subjects $num_subjects

# define which subjects should be excluded
# subjects_excl=(*/HERE)
# exclude subjects: compare the elements of subjects_excl and subjects
# if they match, delete (i.e. unset) the element in subject
for e in ${!subjects_excl[@]}; do
	excl=${subjects_excl[$e]}
	for i in ${!subjects[@]}; do
		subj=${subjects[$i]}
		if [[ "$excl" == "$subj" ]]; then
			unset subjects[i]
			subjects=( "${subjects[@]}" )
		fi
	done
done

# define number of subjects
num_subjects=${#subjects[@]}
echo number of subjects after exclusion $num_subjects

# create ISC folder
ISC_dir="$path"/"ISC_analysis"/
mkdir $ISC_dir
cd $ISC_dir

# create mask folder
mask_dir="$ISC_dir"/"masks"/
mkdir $mask_dir

# create DataTable file
printf "Subj1 \tSubj2 \tgrp \tInputFile" > ./DataTable_ISC_across_movies.txt

# loop over subjects
for (( s=0; s<${num_subjects}; s++));
do
	# define variable subj_id
	subj_id=${subjects[$s]}
	echo ""
	echo subject 1 $subj_id
	echo ""
	# change directory to where the bold data of subj_id is saved
	s1_dir="$path"/"$subj_id"/
	# define file for subj_id
	s1_file=$s1_dir"media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing_ica.nii.gz"
	# check whether s1_file exists
	if [ -f "$s1_file" ]; then
		# define mask file for subj_id
		s1_mask=$s1_dir"anatomical_mask_no_wm_ventricle.nii.gz"
		# define mask_prefix
		find=/
		replace=_
		mask_p=anatomical_mask_no_wm_ventricle_${subj_id}.nii.gz
		mask_prefix=${mask_p//$find/$replace}
		# copy mask to mask_dir
		3dcopy $s1_mask ${mask_dir}${mask_prefix}
		# loop over subjects+1
		for (( t=s+1; t<${num_subjects}; t++));
		do
			# define variable subj_corr, change directory to where the bold data of subj_corr is saved and define file for subj_corr
			subj_corr=${subjects[$t]}
			s2_dir="$path"/"$subj_corr"/
			# define file for subj_id
			s2_file=$s2_dir"media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing_ica.nii.gz"
			# check whether s2_file exists
			if [ -f "$s2_file" ]; then
				# define mask file for subj_id
				s2_mask=$s2_dir"anatomical_mask_no_wm_ventricle.nii.gz"
				# determine whether s1 and s2 are from the same movie
				dir1=($(dirname $subj_id))
				dir2=($(dirname $subj_corr))
				if [[ "$dir1" == "$dir2" ]]; then
					category=within
					group=1
				else
					category=between
					group=-1
				fi
					# define ISC_prefix
					find=/
					replace=_
					ISC_p="ISC_${category}_m1_${subj_id}_m2_${subj_corr}.nii.gz"
					ISC_prefix=${ISC_p//$find/$replace}
					# add information to DataTable file
					printf "\t \\ \n${subj_id//$find/$replace} \t${subj_corr//$find/$replace} \t$group \t$ISC_prefix" >> ./DataTable_ISC_across_movies.txt
					# check for the number of 3dTcorrelate commands running
					# num_running=`ps -aux | grep "3dTcorrelate" | grep -v grep | wc -l`
					# check whether ISC map already exists
					if [ ! -f "$ISC_prefix" ]; then
						echo ""
						echo s1_file $s1_file
						echo s2_file $s2_file
						echo category $category
						echo ISC_prefix $ISC_prefix
						echo "running 3dTcorrelate"
						echo ""
						# calculate ISC using pearson, do not detrend the data, save it in .nii, do Fisher-z transformation
						3dTcorrelate -pearson -polort -1 -Fisher -automask -prefix $ISC_prefix $s1_file[0..5469] $s2_file[0..5469]
					fi
				else
					echo "s2_file $s2_file does not exist"
				fi
		done
	else
		echo "s1_file $s1_file does not exist"
	fi
done

echo ""
echo ""
echo ""
echo "INTERSUBJECT CORRELATION FINISHED"
echo ""
echo ""
echo ""

# create group mask
cd $mask_dir
rm anatomical_mask_no_wm_ventricle.nii.gz # removes old file
3dMean -prefix anatomical_mask_no_wm_ventricle.nii.gz anatomical*.nii.gz

# create file run_3dISC
cd $ISC_dir
rm run_3dISC_across_movies # removes old file
printf "3dISC -prefix ISC_across_movies -jobs 20  -model 'grp+(1|Subj1)+(1|Subj2)' -qVars grp -gltCode ave '1 0' -gltCode within_vs_between '0 2' -gltCode within '1 1' -gltCode between '1 -1' -mask ./masks/anatomical_mask_no_wm_ventricle.nii.gz -dataTable @DataTable_ISC_across_movies.txt " > ./run_3dISC_across_movies

# make file executable
chmod ug+x run_3dISC_across_movies

# calculate ISC with LME-CRE
rm    ./nuhup_output_3dISC_across_movies.out
nohup ./run_3dISC_across_movies &> ./nuhup_output_3dISC_across_movies.out &

cd /data/movie/fmri/movie_scripts
