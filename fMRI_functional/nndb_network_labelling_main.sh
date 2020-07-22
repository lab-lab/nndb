#!/bin/bash

################################################################################
# Set some variables
################################################################################

# Steps to run
#   make_regressors = makes annotation files and associated convovled regressors,.mat, and .con files for the FSL GLMs
#   do_regressions = run FSL GLMs using convovled regressorson ICA components, find significant ICs, and combines them
#   do_ttests = runs group level 3dttest++ on the combined IC files
steps_order="make_regressors do_regressions do_ttests"

# redo_glm="yes"
redo_glm="no"


# Directories
# Base
base_data_dir="nndb"
cd $base_data_dir
# Participants
subjects=`ls -d -- sub*`


# ICA directory
# After artifact removal
ica_dir="$base_data_dir"/"derivatives"

# Annotations to use
annotation_name="words_and_faces"
annotation_dir="$base_data_dir"/"stimuli"
annotation_1_1="words"
annotation_1_2="nowords"
annotation_2_1="faces"
annotation_2_2="nofaces"

# Cluster size and threshold for determining significant components from FSL GLM
# Cluster size
cs=20
# Threshold
# Bonferroni for 250 components and/or 4 (before faces) or 8 tests
# .01/(250*8)  = 5e-06 = 000005
thresh=000005

# Include only positive ICA activity
activity_signs="positive"

# Group ttests
ttest_dir="nndb/group/convolution_based_ic_glms_and_group_ttests"

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
  movies="12yearsaslave 500daysofsummer backtothefuture citizenfour littlemisssunshine pulpfiction split theprestige theshawshankredemption theusualsuspects"
  for movie in $movies
  do
    if [ $movie == '12yearsaslave' ]
    then
      movie_length="7715"
    fi
    if [ $movie == '500daysofsummer' ]
    then
      export movie_length="5470"
    fi
    if [ $movie == 'backtothefuture' ]
    then
      movie_length="6674"
    fi
    if [ $movie == 'citizenfour' ]
    then
      movie_length="6804"
    fi
    if [ $movie == 'littlemisssunshine' ]
    then
      movie_length="5900"
    fi
    if [ $movie == 'pulpfiction' ]
    then
      movie_length="8882"
    fi
    if [ $movie == 'split' ]
    then
      movie_length="6739"
    fi
    if [ $movie == 'theprestige' ]
    then
      movie_length="7515"
    fi
    if [ $movie == 'theshawshankredemption' ]
    then
      movie_length="8181"
    fi
    if [ $movie == 'theusualsuspects' ]
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
      -stim_times_AM1 1 "$annotation_dir"/task-"$movie"_"$annotation_1_1"-annotation.1D 'dmUBLOCK' -stim_label 1 "$annotation_1_1" \
      -stim_times_AM1 2 "$annotation_dir"/task-"$movie"_"$annotation_1_2"-annotation.1D 'dmUBLOCK' -stim_label 2 "$annotation_1_2" \
      -stim_times_AM1 3 "$annotation_dir"/task-"$movie"_"$annotation_2_1"-annotation.1D 'dmUBLOCK' -stim_label 3 "$annotation_2_1" \
      -stim_times_AM1 4 "$annotation_dir"/task-"$movie"_"$annotation_2_2"-annotation.1D 'dmUBLOCK' -stim_label 4 "$annotation_2_2" \
      -x1D task-"$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved -x1D_stop
      # Make mat file needed by fsl
    1dcat \
      task-"$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.xmat.1D\[0] \
      task-"$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.xmat.1D\[1] \
      task-"$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.xmat.1D\[2] \
      task-"$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.xmat.1D\[3] \
    > task-"$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.mat
    # Make con file needed by fsl
    echo "/NumWaves 4"  > task-"$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con
    echo "/NumContrasts 8" >> task-"$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con
    echo "/PPheights 1 1" >> task-"$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con
    echo "/Matrix" >> task-"$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con
    echo "1 0 0 0 " >> task-"$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con
    echo "0 1 0 0 " >> task-"$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con
    echo "0 0 1 0 " >> task-"$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con
    echo "0 0 0 1 " >> task-"$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con
    echo "1 -1 0 0" >> task-"$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con
    echo "-1 1 0 0" >> task-"$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con
    echo "0 0 1 -1" >> task-"$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con
    echo "0 0 -1 1" >> task-"$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con
  done
fi


################################################################################
# Run regressions
################################################################################

# NOTES
# Runs FSL GLMs on every component
# It then filters the signifiant components out

if [[ $step = do_regressions ]]; then
  for sub in $subjects
  do
    # 12 Years A Slave
    if [ $sub == 'sub-81' ] || [ $sub == 'sub-82' ] || [ $sub == 'sub-83' ] || [ $sub == 'sub-84' ] || [ $sub == 'sub-85' ] || [ $sub == 'sub-86' ]
    then
      export movie="12yearsaslave"
      export movie_length="7715"
    fi
    # 500 Days of Summer
    if [ $sub == 'sub-1' ] || [ $sub == 'sub-2' ] || [ $sub == 'sub-3' ] || [ $sub == 'sub-4' ] || [ $sub == 'sub-5' ] || [ $sub == 'sub-6' ] || [ $sub == 'sub-7' ] || [ $sub == 'sub-8' ] || [ $sub == 'sub-9' ] || [ $sub == 'sub-10' ] || [ $sub == 'sub-11' ] || [ $sub == 'sub-12' ] || [ $sub == 'sub-13' ] || [ $sub == 'sub-14' ] || [ $sub == 'sub-15' ] || [ $sub == 'sub-16' ] || [ $sub == 'sub-17' ] || [ $sub == 'sub-18' ] || [ $sub == 'sub-19' ] || [ $sub == 'sub-20' ]
    then
      export movie="500daysofsummer"
      export movie_length="5470"
    fi
    # Back to the Future
    if [ $sub == 'sub-63' ] || [ $sub == 'sub-64' ] || [ $sub == 'sub-65' ] || [ $sub == 'sub-66' ] || [ $sub == 'sub-67' ] || [ $sub == 'sub-68' ]
    then
      export movie="backtothefuture"
      export movie_length="6674"
    fi
    # CitizenFour
    if [ $sub == 'sub-21' ] || [ $sub == 'sub-22' ] || [ $sub == 'sub-23' ] || [ $sub == 'sub-24' ] || [ $sub == 'sub-25' ] || [ $sub == 'sub-26' ] || [ $sub == 'sub-27' ] || [ $sub == 'sub-28' ] || [ $sub == 'sub-29' ] || [ $sub == 'sub-30' ] || [ $sub == 'sub-31' ] || [ $sub == 'sub-32' ] || [ $sub == 'sub-33' ] || [ $sub == 'sub-34' ] || [ $sub == 'sub-35' ] || [ $sub == 'sub-36' ] || [ $sub == 'sub-37' ] || [ $sub == 'sub-38' ]
    then
      export movie="citizenfour"
      export movie_length="6804"
    fi
    # Little Miss Sunshine
    if [ $sub == 'sub-75' ] || [ $sub == 'sub-76' ] || [ $sub == 'sub-77' ] || [ $sub == 'sub-78' ] || [ $sub == 'sub-79' ] || [ $sub == 'sub-80' ]
    then
      export movie="littlemisssunshine"
      export movie_length="5900"
    fi
    # Pulp Fiction
    if [ $sub == 'sub-45' ] || [ $sub == 'sub-46' ] || [ $sub == 'sub-47' ] || [ $sub == 'sub-48' ] || [ $sub == 'sub-49' ] || [ $sub == 'sub-50' ]
    then
      export movie="pulpfiction"
      export movie_length="8882"
    fi
    # Split
    if [ $sub == 'sub-69' ] || [ $sub == 'sub-70' ] || [ $sub == 'sub-71' ] || [ $sub == 'sub-72' ] || [ $sub == 'sub-73' ] || [ $sub == 'sub-74' ]
    then
      export movie="split"
      export movie_length="6739"
    fi
    # The Prestige
    if [ $sub == 'sub-57' ] || [ $sub == 'sub-58' ] || [ $sub == 'sub-59' ] || [ $sub == 'sub-60' ] || [ $sub == 'sub-61' ] || [ $sub == 'sub-62' ]
    then
      export movie="theprestige"
      export movie_length="7515"
    fi
    # The Shawshank Redemption
    if [ $sub == 'sub-51' ] || [ $sub == 'sub-52' ] || [ $sub == 'sub-53' ] || [ $sub == 'sub-54' ] || [ $sub == 'sub-55' ] || [ $sub == 'sub-56' ]
    then
      export movie="theshawshankredemption"
      export movie_length="8181"
    fi
    # The Usual Suspects
    if [ $sub == 'sub-39' ] || [ $sub == 'sub-40' ] || [ $sub == 'sub-41' ] || [ $sub == 'sub-42' ] || [ $sub == 'sub-43' ] || [ $sub == 'sub-44' ]
    then
      export movie="theusualsuspects"
      export movie_length="6102"
    fi
    # Change directory
    cd "$ica_dir"/"$sub"/func
    mkdir "$ica_dir"/"$sub"/func/fsl_glms 2>/dev/null
    cd    "$ica_dir"/"$sub"/func/fsl_glms
    cp    "$annotation_dir"/task-"$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.mat ./
    cp    "$annotation_dir"/task-"$movie"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con ./
    ic=1
    num_ic=`ls -lhGd "$ica_dir"/"$sub"/func/report/t*.txt | wc -l` 2>/dev/null  ##### THIS IS NOT AVAILABLE, NEED TO RUN ICA LOCALLY #####
    if [ $redo_glm == "yes" ]
    then
      while [ $ic -le $num_ic ]
      do
        echo "################################################################################"
        echo "# "$sub": Doing GLM on Independent Component "$ic" for "$movie""
        echo "################################################################################"
        1dcat "$ica_dir"/"$sub"/func/report/t"$ic".txt\[0] > t"$ic"_eigen.txt     ##### THIS IS NOT AVAILABLE, NEED TO RUN ICA LOCALLY #####
        fsl_glm -i t"$ic"_eigen.txt \
          -d task-"$movie_name"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.mat \
          -c task-"$movie_name"_"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved.con \
          -o task-"$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved_ic"$ic" \
          --out_z="$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved_z_table_ic"$ic" \
          --out_p="$annotation_1_1"_"$annotation_1_2"_"$annotation_2_1"_"$annotation_2_2"_convolved_pvalue_table_ic"$ic"
        ic=$((ic + 1))
      done
    fi
    # Get significant components
    # Run the following in Rscript to get signifiant componants
    echo "################################################################################"
    echo "# "$sub": Getting Significant ICs from GLM for "$movie""
    echo "################################################################################"
    Rscript --vanilla nndb/fMRI_functional/nndb_network_labelling_sig.R "$annotation_1_1" "$annotation_1_2" "$annotation_2_1" "$annotation_2_2" "$thresh"
    # mkdir ./files/ 2>/dev/null
    mkdir ./temp_zstats
    cd    ./temp_zstats
    for activity_sign in $activity_signs
    do
      for prefix in "$annotation_1_1" "$annotation_1_2" "$annotation_2_1" "$annotation_2_2" "$annotation_1_1"_vs_"$annotation_1_2" "$annotation_1_2"_vs_"$annotation_1_1" "$annotation_2_1"_vs_"$annotation_2_2" "$annotation_2_2"_vs_"$annotation_2_1"
      do
        echo "################################################################################"
        echo "# "$sub": Clustering signifiant ICs for "$movie" for "$prefix""
        echo "################################################################################"
        ICs=$(cat ../"$prefix".1D)
        for IC in $ICs
        do
          rm ./thresh_zstat"$IC".nii.gz 2>/dev/null
          cp "$ica_dir"/"$sub"/func/stats/thresh_zstat"$IC".nii.gz ./
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
        echo "# "$sub": Combining signifiant ICs for "$movie_name" for "$prefix""
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
    -prefix ./avg_T1w_mask.nii.gz \
    "$ica_dir"/sub-*/anat/sub-*_T1w_mask.nii.gz
  # Do one way ttests
  # for prefix in "$annotation_1_1" "$annotation_1_2" "$annotation_2_1" "$annotation_2_2" "$annotation_1_1"_vs_"$annotation_1_2" "$annotation_1_2"_vs_"$annotation_1_1" "$annotation_2_1"_vs_"$annotation_2_2" "$annotation_2_2"_vs_"$annotation_2_1"
  for prefix in "$annotation_1_1"_vs_"$annotation_1_2" "$annotation_1_2"_vs_"$annotation_1_1" "$annotation_2_1"_vs_"$annotation_2_2" "$annotation_2_2"_vs_"$annotation_2_1"
  do
    for activity_sign in $activity_signs
    do
      num=`ll "$ica_dir"/"$sub"/func/fsl_glms/"$prefix"_clust_"$cs"_"$activity_sign"_"$thresh""$combo_operation".nii.gz | wc -l`
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
        -mask avg_T1w_mask.nii.gz  \
        -zskip 10 -AminusB \
        -setA \
        "$ica_dir"/"$sub"/func/fsl_glms/"$prefix"_clust_"$cs"_"$activity_sign"_"$thresh""$combo_operation".nii.gz
    done
  done

fi

################################################################################
# END
################################################################################

done
