#!/bin/bash

# source "$scripts_dir"/general_set_variables.sh

################################################################################
# Do Group ttests
################################################################################

# NOTES
# This script generates hrf convolved regressors and regresses them against ICA timecourses
# Annotations set in general variables
# This only works currently for N=2 annotations (e.g., words and notwords)
# To run: /data/movie/fmri/movie_scripts/individual_functional_analysis_scripts/functional_analysis_convolution_based_ic_glms_and_group_ttests.sh

################################################################################
# Set some variables
################################################################################

# Steps to run
#   make_regressors = makes annotation files and associated convovled regressors,.mat, and .con files for the FSL GLMs
#   do_regressions = run FSL GLMs using convovled regressorson ICA components, find significant ICs, and combines them
#   do_ttests = runs group level 3dttest++ on the combined IC files
steps_order="make_regressors do_regressions do_ttests"

# Redo glms?
# redo_glm="yes"
redo_glm="no"

# Participants
perps="180303JM 180308PV 180310MF 180315AL 180317LG 180322SM 180801IF 180808AF 180815FY 181203AJ 181206RU 181218MS 190114RL 190501DB 190624AO 190701SM 190813CH 191123DB 200129FK 200131SC 180919SB 181017DS 181023AS 181107LB 181121JR 181210IS 181219CS 190115EH 190116CD 190219SC 190429RB 190514AR 190520GH 190527AA 190618EP 190903SM 190907SK 200122RP 190312HT 190430HE 190604HP 190710NR 191214ZS 200217UM 191109MY 191109SR 191212SC 200127LE 200203DA 200203WD 190703SW 191101AN 191130AG 200118AC 200131MP 200201EH 180926EY 190521PC 190619TR 190704JA 191102GD 191119KD 191111MI 191125MB 191211JC 191216EC 200114MS 200204JS 180922BM 190620SA 190624MB 190701AC 190702AR 191219PR 190508LT 190522KA 190530KB 190625PT 190626EL 190702IS 191123MK 191202PO 191207KW 200111SB 200118CM 200302RR"

# Directories
# Base
base_data_dir="/data/movie/fmri/participants/adults"

# ICA directory
# After artifact removal
ica_dir="ica_artifiact_d250_media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing_ica"

# Annotations to use
annotation_name="words_and_faces"
annotation_dir="/data/movie/fmri/stimuli/annotations/words_and_faces"
annotation_1_1="words"
annotation_1_2="nowords"
annotation_2_1="faces"
annotation_2_2="nofaces"

# Cluster size and threshold for determining significant components from FSL GLM
# Cluster size
cs=20
# Threshold
# Bonforoni for 250 components and/or 4 (before faces) or 8 tests
# .01/(250*8)  = 5e-06 = 000005
thresh=000005

# Include only positive ICA activity
activity_signs="positive"

# Group ttests
ttest_dir="/data/movie/fmri/participants/adults/group/convolution_based_ic_glms_and_group_ttests"

# How to combine multiple significant ICs
combo_operation="_sum"

# Add some suffix if desired
ttest_suffix="des_dat_norm"

################################################################################
# Begin
################################################################################

for step in $steps_order
do

################################################################################
# Make convolved regressors
################################################################################

if [[ $step = make_regressors ]]; then
  movies="12_years_a_slave 500_days_of_summer back_to_the_future citizenfour little_miss_sunshine pulp_fiction split the_prestige the_shawshank_redemption the_usual_suspects"
  for movie in $movies
  do
    if [ $movie == '12_years_a_slave' ]
    then
      movie_length="7715"
    fi
    if [ $movie == '500_days_of_summer' ]
    then
      export movie_length="5470"
    fi
    if [ $movie == 'back_to_the_future' ]
    then
      movie_length="6674"
    fi
    if [ $movie == 'citizenfour' ]
    then
      movie_length="6804"
    fi
    if [ $movie == 'little_miss_sunshine' ]
    then
      movie_length="5900"
    fi
    if [ $movie == 'pulp_fiction' ]
    then
      movie_length="8882"
    fi
    if [ $movie == 'split' ]
    then
      movie_length="6739"
    fi
    if [ $movie == 'the_prestige' ]
    then
      movie_length="7515"
    fi
    if [ $movie == 'the_shawshank_redemption' ]
    then
      movie_length="8181"
    fi
    if [ $movie == 'the_usual_suspects' ]
    then
      movie_length="6102"
    fi
    # Change to the first annotations directory
    cd "$annotation_dir"
    # Generate convolved regressors
    # Change to the second annotations directory
    3dDeconvolve \
      -polort -1 \
      -nodata "$movie_length" 1 \
      -num_stimts 4 \
      -global_times \
      -stim_times_AM1 1 "$annotation_dir"/"$movie"_"$annotation_1_1".1D 'dmUBLOCK' -stim_label 1 "$annotation_1_1" \
      -stim_times_AM1 2 "$annotation_dir"/"$movie"_"$annotation_1_2".1D 'dmUBLOCK' -stim_label 2 "$annotation_1_2" \
      -stim_times_AM1 3 "$annotation_dir"/"$movie"_"$annotation_2_1".1D 'dmUBLOCK' -stim_label 3 "$annotation_2_1" \
      -stim_times_AM1 4 "$annotation_dir"/"$movie"_"$annotation_2_2".1D 'dmUBLOCK' -stim_label 4 "$annotation_2_2" \
      -x1D "$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved -x1D_stop
      # Make mat file needed by fsl
    1dcat \
      "$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.xmat.1D\[0] \
      "$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.xmat.1D\[1] \
      "$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.xmat.1D\[2] \
      "$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.xmat.1D\[3] \
    > "$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.mat
    # Make con file needed by fsl
    echo "/NumWaves 4"  > "$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con
    echo "/NumContrasts 8" >> "$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con
    echo "/PPheights 1 1" >> "$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con
    echo "/Matrix" >> "$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con
    echo "1 0 0 0 " >> "$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con
    echo "0 1 0 0 " >> "$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con
    echo "0 0 1 0 " >> "$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con
    echo "0 0 0 1 " >> "$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con
    echo "1 -1 0 0" >> "$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con
    echo "-1 1 0 0" >> "$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con
    echo "0 0 1 -1" >> "$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con
    echo "0 0 -1 1" >> "$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con
  done
fi

# To have a look to see what the waver plots look like for a smaller number of annotations
# waver \
#   -TR 1 -WAV \
#   -tstim `cat "$annotation_file_name_1".json | jq '.[]' | sed '1~5d' | sed '4~4d' | sed '1~3d' | sed 's/,//g' | sed 'N;s/\n/:/' | sed 's/ //g' | sort -k1,1n | head -n 1000` | \
#   1dplot -stdin

################################################################################
# Run regressions
################################################################################

# NOTES
# Runs FSL GLMs on every component
# It then filters the signifiant components out

if [[ $step = do_regressions ]]; then
  for perp in $perps
  do
    # 12 Years A Slave
    if [ $perp == '191123MK' ] || [ $perp == '191202PO' ] || [ $perp == '190805EM' ] || [ $perp == '191207KW' ] || [ $perp == '200111SB' ] || [ $perp == '200118CM' ] || [ $perp == '200302RR' ]
    then
      export movie="12_years_a_slave"
      export movie_length="7715"
    fi
    # 500 Days of Summer
    if [ $perp == '190701SM' ] || [ $perp == '190624AO' ] || [ $perp == '190501DB' ] || [ $perp == '190114RL' ] || [ $perp == '181218MS' ] || [ $perp == '181206RU' ] || [ $perp == '181203AJ' ] || [ $perp == '180815FY' ] || [ $perp == '180808AF' ] || [ $perp == '180801IF' ] || [ $perp == '180329NR' ] || [ $perp == '180322SM' ] || [ $perp == '180317RC' ] || [ $perp == '180317LG' ] || [ $perp == '180315AL' ] || [ $perp == '180310MF' ] || [ $perp == '180308PV' ] || [ $perp == '180303JM' ] || [ $perp == '190905SS' ] || [ $perp == '190813CH' ] || [ $perp == '191123DB' ] || [ $perp == '200129FK' ] || [ $perp == '200131SC' ]
    then
      export movie="500_days"
      export movie_length="5470"
    fi
    # Back to the Future
    if [ $perp == '191111MI' ] || [ $perp == '191125MB' ] || [ $perp == '191211JC' ] || [ $perp == '191216EC' ] || [ $perp == '200204JS' ] || [ $perp == '200114MS' ]
    then
      export movie="back_to_the_future"
      export movie_length="6674"
    fi
    # CitizenFour
    if [ $perp == '190618EP' ] || [ $perp == '190527AA' ] || [ $perp == '190520GH' ] || [ $perp == '190514AR' ] || [ $perp == '190429RB' ] || [ $perp == '190219SC' ] || [ $perp == '190211KV' ] || [ $perp == '190116CD' ] || [ $perp == '190115EH' ] || [ $perp == '181219CS' ] || [ $perp == '181210IS' ] || [ $perp == '181121JR' ] || [ $perp == '181107LB' ] || [ $perp == '181023AS' ] || [ $perp == '181017DS' ] || [ $perp == '180919SB' ] || [ $perp == '190903SM' ] || [ $perp == '190907SK' ] || [ $perp == '200122RP' ]
    then
      export movie="citizenfour"
      export movie_length="6804"
    fi
    # Little Miss Sunshine
    if [ $perp == '190702IS' ] || [ $perp == '190626EL' ] || [ $perp == '190625PT' ] || [ $perp == '190530KB' ] || [ $perp == '190522KA' ] || [ $perp == '190508LT' ]
    then
      export movie="little_miss_sunshine"
      export movie_length="5900"
    fi
    # Pulp Fiction
    if [ $perp == '191109MY' ] || [ $perp == '191109SR' ] || [ $perp == '191212SC' ] || [ $perp == '200203WD' ] || [ $perp == '200203DA' ] || [ $perp == '200127LE' ]
    then
      export movie="pulp_fiction"
      export movie_length="8882"
    fi
    # Split
    if [ $perp == '191219PR' ] || [ $perp == '190702AR' ] || [ $perp == '190701AC' ] || [ $perp == '190620SA' ] || [ $perp == '190624MB' ] || [ $perp == '180922BM' ]
    then
      export movie="split"
      export movie_length="6739"
    fi
    # The Prestige
    if [ $perp == '191102GD' ] || [ $perp == '191119KD' ] || [ $perp == '190704JA' ] || [ $perp == '190619TR' ] || [ $perp == '190521PC' ] || [ $perp == '180926EY' ]
    then
      export movie="the_prestige"
      export movie_length="7515"
    fi
    # The Shawshank Redemption
    if [ $perp == '191101AN' ] || [ $perp == '191130AG' ] || [ $perp == '200118AC' ] || [ $perp == '200131MP' ] || [ $perp == '200201EH' ] || [ $perp == '190703SW' ]
    then
      export movie="the_shawshank_redemption"
      export movie_length="8181"
    fi
    # The Usual Suspects
    if [ $perp == '191214ZS' ] || [ $perp == '190710NR' ] || [ $perp == '190604HP' ] || [ $perp == '200217UM' ] || [ $perp == '190430HE' ] || [ $perp == '190312HT' ]
    then
      export movie="the_usual_suspects"
      export movie_length="6102"
    fi
    # Change directory
    data_dir="$base_data_dir"/"$movie"

    if [ $movie == '500_days' ]
    then
      movie_name="500_days_of_summer"
    else
      movie_name="$movie"
    fi
    cd "$data_dir"/"$perp"/
    mkdir "$ica_dir"/fsl_glms 2>/dev/null
    cd    "$ica_dir"/fsl_glms
    cp    "$annotation_dir"/"$movie_name"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.mat ./
    cp    "$annotation_dir"/"$movie_name"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con ./
    ic=1
    num_ic=`ls -lhGd "$data_dir"/"$perp"/"$ica_dir"/report/t*.txt | wc -l` 2>/dev/null
    if [ $redo_glm == "yes" ]
    then
      while [ $ic -le $num_ic ]
      do
        echo "################################################################################"
        echo "# "$perp": Doing GLM on Independent Component "$ic" for "$movie_name""
        echo "################################################################################"
        1dcat "$data_dir"/"$perp"/"$ica_dir"/report/t"$ic".txt\[0] > t"$ic"_eigen.txt
        fsl_glm -i t"$ic"_eigen.txt \
          -d "$movie_name"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.mat \
          -c "$movie_name"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con \
          -o "$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved_ic"$ic" \
          --out_z="$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved_z_table_ic"$ic" \
          --out_p="$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved_pvalue_table_ic"$ic"
        ic=$((ic + 1))
      done
    fi
    # Get significant components
    # Run the following in Rscript to get signifiant componants
    echo "################################################################################"
    echo "# "$perp": Getting Signifiant ICs from GLM for "$movie_name""
    echo "################################################################################"
    Rscript --vanilla /data/movie/fmri/movie_scripts/individual_functional_analysis_scripts/nndb_network_labelling_sig.R "$annotation_1_1" "$annotation_1_2" "$annotation_2_1" "$annotation_2_2" "$thresh"
    # mkdir ./files/ 2>/dev/null
    mkdir ./temp_zstats
    cd    ./temp_zstats
    for activity_sign in $activity_signs
    do
      for prefix in "$annotation_1_1" "$annotation_1_2" "$annotation_2_1" "$annotation_2_2" "$annotation_1_1"_vs_"$annotation_1_2" "$annotation_1_2"_vs_"$annotation_1_1" "$annotation_2_1"_vs_"$annotation_2_2" "$annotation_2_2"_vs_"$annotation_2_1"
      do
        echo "################################################################################"
        echo "# "$perp": Clustering signifiant ICs for "$movie_name" for "$prefix""
        echo "################################################################################"
        ICs=$(cat ../"$prefix".1D)
        for IC in $ICs
        do
          rm ./thresh_zstat"$IC".nii.gz 2>/dev/null
          cp "$data_dir"/"$perp"/"$ica_dir"/stats/thresh_zstat"$IC".nii.gz ./
          rm "$prefix"_clust_"$cs"_"$activity_sign"_"$thresh"_ic"$IC".nii.gz 2>/dev/null
          if [ $activity_sign == "positive" ]
          then
            3dmerge \
              -2clip -1000000000 0 -dxyz=1 -1clust 1.01 "$cs" \
              -prefix ./"$prefix"_clust_"$cs"_positive_"$thresh"_ic"$IC".nii.gz \
                      ./thresh_zstat"$IC".nii.gz >/dev/null 2>&1
          else
            3dmerge \
              -2clip  0 1000000000 -dxyz=1 -1clust 1.01 "$cs" \
              -prefix ./"$prefix"_clust_"$cs"_negative_"$thresh"_ic"$IC".nii.gz \
                      ./thresh_zstat"$IC".nii.gz >/dev/null 2>&1
          fi
        done
        echo "################################################################################"
        echo "# "$perp": Combining signifiant ICs for "$movie_name" for "$prefix""
        echo "################################################################################"
        rm ../"$prefix"_clust_"$cs"_"$activity_sign"_"$thresh"_sum.nii.gz 2>/dev/null
        3dMean \
          -sum \
          -prefix ../"$prefix"_clust_"$cs"_"$activity_sign"_"$thresh"_sum.nii.gz \
                   ./"$prefix"_clust_"$cs"_"$activity_sign"_"$thresh"_ic*.nii.gz >/dev/null 2>&1
        rm thresh_zstat*
        rm "$prefix"_clust_"$cs"_"$activity_sign"_"$thresh"_ic*.nii.gz 2>/dev/null
      done
      cd ../
      rm -rf ./temp_zstats
      # mv t*_eigen.txt     ./files/
      # mv *_convolved_*ic* ./files/
    done
  done
fi

################################################################################
# Group ttests
################################################################################

if [[ $step = do_ttests ]]; then
  # Change to group directory
  cd "$ttest_dir"
  # Make a mask
  3dMean \
    -prefix ./anatomical_mask_no_wm_ventricle.nii.gz \
    ../../*/*/anatomical_mask_no_wm_ventricle.nii.gz
  # Do one way ttests
  # for prefix in "$annotation_1_1" "$annotation_1_2" "$annotation_2_1" "$annotation_2_2" "$annotation_1_1"_vs_"$annotation_1_2" "$annotation_1_2"_vs_"$annotation_1_1" "$annotation_2_1"_vs_"$annotation_2_2" "$annotation_2_2"_vs_"$annotation_2_1"
  for prefix in "$annotation_1_1"_vs_"$annotation_1_2" "$annotation_1_2"_vs_"$annotation_1_1" "$annotation_2_1"_vs_"$annotation_2_2" "$annotation_2_2"_vs_"$annotation_2_1"
  do
    for activity_sign in $activity_signs
    do
      num=`ll /data/movie/fmri/participants/adults/*/*/"$ica_dir"/fsl_glms/"$prefix"_clust_"$cs"_"$activity_sign"_"$thresh""$combo_operation".nii.gz | wc -l`
      echo "**************************************************" $prefix "has" $num "files"
    done
  done
  # for prefix in "$annotation_1_1" "$annotation_1_2" "$annotation_2_1" "$annotation_2_2" "$annotation_1_1"_vs_"$annotation_1_2" "$annotation_1_2"_vs_"$annotation_1_1" "$annotation_2_1"_vs_"$annotation_2_2" "$annotation_2_2"_vs_"$annotation_2_1"
  for prefix in "$annotation_1_1"_vs_"$annotation_1_2" "$annotation_1_2"_vs_"$annotation_1_1" "$annotation_2_1"_vs_"$annotation_2_2" "$annotation_2_2"_vs_"$annotation_2_1"
  do
    for activity_sign in $activity_signs
    do
      rm ./"$activity_sign"_"$prefix"_clust_"$cs"_"$thresh"_sum_1sample_ttest"$combo_operation"_"$ttest_suffix".nii.gz
      3dttest++ \
        -prefix ./"$activity_sign"_"$prefix"_clust_"$cs"_"$thresh"_sum_1sample_ttest"$combo_operation"_"$ttest_suffix".nii.gz \
        -mask anatomical_mask_no_wm_ventricle.nii.gz  \
        -zskip 10 -AminusB \
        -setA \
        /data/movie/fmri/participants/adults/*/*/"$ica_dir"/fsl_glms/"$prefix"_clust_"$cs"_"$activity_sign"_"$thresh""$combo_operation".nii.gz
    done
  done
  # Do paired ttests
  # for activity_sign in $activity_signs
  # do
  #   rm ./"$activity_sign"_"$annotation_1_1"_vs_"$annotation_1_2"_clust_"$cs"_"$thresh"_sum_2sample_ttest"$combo_operation"_"$ttest_suffix".nii.gz
  #   3dttest++ \
  #     -prefix ./# "$activity_sign"_"$annotation_1_1"_vs_"$annotation_1_2"_clust_"$cs"_"$thresh"_sum_2sample_ttest"$combo_operation"_"$ttest_suffix".nii.gz \
  #     -mask anatomical_mask_no_wm_ventricle.nii.gz  \
  #     -zskip 10 -AminusB \
  #     -setA \
  #     /data/movie/fmri/participants/adults/*/*/"$ica_dir"/fsl_glms/"$annotation_1_1"_clust_"$cs"_"$activity_sign"_"$thresh""$combo_operation".nii.gz # \
  #     -setB \
  #     /data/movie/fmri/participants/adults/*/*/"$ica_dir"/fsl_glms/"$annotation_1_2"_clust_"$cs"_"$activity_sign"_"$thresh""$combo_operation".nii.gz
  #   rm ./"$activity_sign"_"$annotation_2_1"_vs_"$annotation_2_2"_clust_"$cs"_"$thresh"_sum_2sample_ttest"$combo_operation"_"$ttest_suffix".nii.gz
  #   3dttest++ \
  #     -prefix ./# "$activity_sign"_"$annotation_2_1"_vs_"$annotation_2_2"_clust_"$cs"_"$thresh"_sum_2sample_ttest"$combo_operation"_"$ttest_suffix".nii.gz \
  #     -mask anatomical_mask_no_wm_ventricle.nii.gz  \
  #     -zskip 10 -AminusB \
  #     -setA \
  #     /data/movie/fmri/participants/adults/*/*/"$ica_dir"/fsl_glms/"$annotation_2_1"_clust_"$cs"_"$activity_sign"_"$thresh""$combo_operation".nii.gz # \
  #     -setB \
  #     /data/movie/fmri/participants/adults/*/*/"$ica_dir"/fsl_glms/"$annotation_2_2"_clust_"$cs"_"$activity_sign"_"$thresh""$combo_operation".nii.gz
  # done
fi

################################################################################
# END
################################################################################

done
