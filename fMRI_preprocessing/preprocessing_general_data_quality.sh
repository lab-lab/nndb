#!/bin/bash

################################################################################
# Data quality information
################################################################################

# NOTE
# Checks ts length
# Checks ts interpolation amounts
# Checks that the timeseries and regressors are the same length
# Check for outliers
# 190114RL  excluded b/c no data
# Don't think it would be worth adding this as it would take too long:
# /usr/lib/afni/bin/3dFWHMx -arith -detrend -mask anatomical_mask.nii.gz -input ./media_2_tshift_despike_reg_al_mni_mask_blur6.nii.gz

out_file="participant_data_quality_information.txt"
movies="500_days 12_years_a_slave citizenfour little_miss_sunshine split star_trek the_prestige the_shawshank_redemption the_usual_suspects pulp_fiction"
echo "" >> /data/movie/fmri/movie_scripts/"$out_file"
for movie in $movies
do
  echo "****************************************************************************************************" $movie
  echo "****************************************************************************************************" $movie >> /data/movie/fmri/movie_scripts/"$out_file"
  if [ $movie == '500_days' ]
  then
    export perps="190701SM 190624AO 190501DB 181218MS 181206RU 181203AJ 180815FY 180808AF 180801IF 180329NR 180322SM 180317RC 180317LG 180315AL 180310MF 180308PV 180303JM"
  fi
  if [ $movie == '12_years_a_slave' ]
  then
    export perps=""
  fi
  if [ $movie == 'citizenfour' ]
  then
    # Doesn't exit: export perps="190211KV"
    export perps="190618EP 190527AA 190520GH 190514AR 190429RB 190219SC 190211KV 190116CD 190115EH 181219CS 181210IS 181121JR 181107LB 181023AS 181017DS 180919SB"
  fi
  if [ $movie == 'little_miss_sunshine' ]
  then
    export perps="190702IS 190626EL 190625PT 190530KB 190522KA 190508LT"
  fi
  if [ $movie == 'split' ]
  then
    export perps="190701AC 190620SA 180922BM 190702AR 190624MB"
  fi
  if [ $movie == 'star_trek' ]
  then
    export perps=""
  fi
  if [ $movie == 'the_prestige' ]
  then
    export perps="190521PC 190619TR 180926EY 190704JA"
  fi
  if [ $movie == 'the_shawshank_redemption' ]
  then
    export perps="190703SW"
  fi
  if [ $movie == 'the_usual_suspects' ]
  then
    export perps="190430HE 190604HP 190312HT 190523LM"
  fi
  if [ $movie == 'pulp_fiction' ]
  then
    export perps=""
  fi
  mov_dir="/data/movie/fmri/participants/adults/$movie"
  for perp in $perps
  do
    echo "****************************************************************************************************" $perp
    cd "$mov_dir"/"$perp"/
    echo "**************************************************" >> /data/movie/fmri/movie_scripts/"$out_file"
    echo "" >> /data/movie/fmri/movie_scripts/"$out_file"
    total_num_runs=`ls ./files/timeseries_files/media_?.nii.gz  | wc -l`
    echo $perp "Number of runs --" $total_num_runs >> /data/movie/fmri/movie_scripts/"$out_file"
    # num_orig_tps=`3dinfo ./files/timeseries_files/media_?_tshift_despike_reg.nii.gz | grep "Number of time steps =" | awk '{print $6}' | paste -sd+ | bc`
    # echo $perp "Number of original tps --" $num_orig_tps >> /data/movie/fmri/movie_scripts/"$out_file"
    # num_final_tps=`3dinfo media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing.nii.gz | grep "Number of time steps =" | awk '{print $6}' | paste -sd+`
    # echo $perp "Number of final tps --" $num_final_tps >> /data/movie/fmri/movie_scripts/"$out_file"
    # new_detrend_num=`3dinfo ./files/timeseries_files/media_?_tshift_despike_reg_al_mni_mask_blur6_{norm.nii.gz,polort.nii.gz,norm_polort.nii.gz,norm_polort_motion.nii.gz,norm_polort_motion_wm_ventricle.nii.gz} | grep detin | awk '{print $9}' | paste -sd" " | wc -w`
    # num_detrends=$((total_num_runs*5))
    # echo $perp "Number of ts with new blurring (should be N="$num_detrends") --" $new_detrend_num >> /data/movie/fmri/movie_scripts/"$out_file"
    # int_amo=`3dinfo ./files/timeseries_files/*_interpolation_amount.nii.gz | grep sub-brick | awk '{print $10}' | uniq | tr '\n' '\t'`
    # echo $perp "Interpolation amounts --" $int_amo >> /data/movie/fmri/movie_scripts/"$out_file"
    for run in `seq 1 $total_num_runs`
    do
      # num_tps_run=`3dinfo ./files/timeseries_files/media_"$run"_tshift_despike_reg.nii.gz | grep steps | awk '{print $6}'`
      # num_tps_motion=`cat files/text_files/media_"$run"_motion_demean.1D | wc -l`
      num_tps_outlier=`cat files/text_files/media_"$run"_tshift_despike_reg_al_mni_mask_outcount_10_percent_outliers.1D | wc -l`
      num_10_outliers=`cat files/text_files/media_"$run"_tshift_despike_reg_al_mni_mask_outcount_10_percent_outliers.1D | grep 0 | wc -l`
      num_05_outliers=`cat files/text_files/media_"$run"_tshift_despike_reg_al_mni_mask_outcount_5_percent_outliers.1D  | grep 0 | wc -l`
      num_motion_1=`1d_tool.py -show_mmms -infile ./files/text_files/media_"$run"_motion_demean.1D | sed -n '2p' | awk '{print substr($0, index($0, $3))}'`
      num_motion_2=`1d_tool.py -show_mmms -infile ./files/text_files/media_"$run"_motion_demean.1D | sed -n '3p' | awk '{print substr($0, index($0, $3))}'`
      num_motion_3=`1d_tool.py -show_mmms -infile ./files/text_files/media_"$run"_motion_demean.1D | sed -n '4p' | awk '{print substr($0, index($0, $3))}'`
      num_motion_4=`1d_tool.py -show_mmms -infile ./files/text_files/media_"$run"_motion_demean.1D | sed -n '5p' | awk '{print substr($0, index($0, $3))}'`
      num_motion_5=`1d_tool.py -show_mmms -infile ./files/text_files/media_"$run"_motion_demean.1D | sed -n '6p' | awk '{print substr($0, index($0, $3))}'`
      num_motion_6=`1d_tool.py -show_mmms -infile ./files/text_files/media_"$run"_motion_demean.1D | sed -n '7p' | awk '{print substr($0, index($0, $3))}'`
      num_maxdisp_delt=`1d_tool.py -show_mmms -infile ./files/text_files/media_"$run"_maxdisp_delt.1D | grep col | awk '{print substr($0, index($0, $3))}'`
      echo "" >> /data/movie/fmri/movie_scripts/"$out_file"
      # echo $perp "File lengths for run" $run "--" $num_tps_run "vs" $num_tps_motion "vs" $num_tps_outlier >> /data/movie/fmri/movie_scripts/"$out_file"
      echo $perp "Number tps w/ more than 05% outliers for run" $run "--" $num_05_outliers >> /data/movie/fmri/movie_scripts/"$out_file"
      echo $perp "Number tps w/ more than 10% outliers for run" $run "--" $num_10_outliers >> /data/movie/fmri/movie_scripts/"$out_file"
      echo $perp "Maximum displacement for run" $run "--" >> /data/movie/fmri/movie_scripts/"$out_file"
      echo $perp "                            " $num_motion_1 >> /data/movie/fmri/movie_scripts/"$out_file"
      echo $perp "                            " $num_motion_2 >> /data/movie/fmri/movie_scripts/"$out_file"
      echo $perp "                            " $num_motion_3 >> /data/movie/fmri/movie_scripts/"$out_file"
      echo $perp "                            " $num_motion_4 >> /data/movie/fmri/movie_scripts/"$out_file"
      echo $perp "                            " $num_motion_5 >> /data/movie/fmri/movie_scripts/"$out_file"
      echo $perp "                            " $num_motion_6 >> /data/movie/fmri/movie_scripts/"$out_file"
      echo $perp "Maximum displacement delta for run" $run "--"   >> /data/movie/fmri/movie_scripts/"$out_file"
      echo $perp "                            " $num_maxdisp_delt >> /data/movie/fmri/movie_scripts/"$out_file"
      echo "" >> /data/movie/fmri/movie_scripts/"$out_file"
    done
    echo "" >> /data/movie/fmri/movie_scripts/"$out_file"
    # echo "****************************************************************************************************" >> /data/movie/fmri/movie_scripts/"$out_file"
  done
done
cd /data/movie/fmri/participants/adults/

################################################################################
# End
################################################################################
