#!/bin/bash

################################################################################
# Convert Freesurfer inflation to SUMA format
################################################################################

# NOTE
# This step must be done before masks can be made and detrending done
# I think this step needs to be done in the /usr/local/freesurfer etc dir
# To look at the results of this step:
# cd
# suma -spec ./freesurfer/SUMA/"$perp"_both.spec -sv ./anatomical_avg.aw.nii.gz
# See bottom for some other ways to possibly normalize by converting to z (doesn't work as written) and/or % signal change

for perp in $perps
do

    cd "$data_dir"/"$perp"/

    # Run SUMA
    rm -rf ./freesurfer/SUMA
    @SUMA_Make_Spec_FS \
     -fspath freesurfer/ \
     -ld 141 -set_space MNI -GNIFTI \
     -sid "$perp"
    # Compress files
    gzip freesurfer/SUMA/*nii

################################################################################
# Make wm and csf masks
################################################################################

# NOTE
# For numeric freesurfer roi codes see:
# https://surfer.nmr.mgh.harvard.edu/fswiki/FsTutorial/AnatomicalROI/FreeSurferColorLUT
    # Move in files if needed
    mv files/timeseries_files/media_?_tshift_despike_reg_al_mni.nii.gz ./
    mv files/timeseries_files/media_?_tshift_despike_reg_al_mni_mask.nii.gz ./
    # Make ventricle mask
    rm ventricle_mask.nii.gz
    3dcalc \
        -a ./freesurfer/SUMA/aparc.a2009s+aseg.nii.gz \
        -expr 'step(equals(a,4)+equals(a,14)+equals(a,15)+equals(a,43)+equals(a,72)+equals(a,213))' \
        -prefix ventricle_mask.nii.gz
    # Resample ventricle mask
    rm ventricle_mask_resample.nii.gz
    3dresample \
        -rmode NN \
        -master ./media_1_tshift_despike_reg_al_mni.nii.gz \
        -input  ./ventricle_mask.nii.gz \
        -prefix ventricle_mask_resample.nii.gz
    # Make white matter mask
    rm wm_mask.nii.gz
    3dcalc \
        -a ./freesurfer/SUMA/aparc.a2009s+aseg.nii.gz \
        -expr 'step(equals(a,41)+equals(a,46)+equals(a,2)+equals(a,7)+equals(a,177))' \
        -prefix wm_mask.nii.gz
    # Resample white matter mask
    rm wm_mask_resample.nii.gz
    3dresample \
        -rmode NN \
        -master ./media_1_tshift_despike_reg_al_mni.nii.gz \
        -input  ./wm_mask.nii.gz \
        -prefix wm_mask_resample.nii.gz

################################################################################
# Erode masks and make a new anatomical mask
################################################################################

# NOTE
# For calculating the wm and ventricle regressors, I think we should use:
# wm_mask_resample_erode.nii.gz
# ventricle_mask_resample.nii.gz
# This is because the venticle erosion doesn't leave enough ventricle...

   # Erode masks
   for mask_type in wm ventricle
   do
     rm "$mask_type"_mask_resample_erode.nii.gz
     3dcalc \
        -a "$mask_type"_mask_resample.nii.gz \
        -b a+i \
        -c a-i \
        -d a+j \
        -e a-j \
        -f a+k \
        -g a-k \
        -expr 'a*(1-amongst(0,b,c,d,e,f,g))' \
        -prefix "$mask_type"_mask_resample_erode.nii.gz
    done
    # Make a new anatomy mask
    rm anatomical_mask_no_wm_ventricle.nii.gz
    3dcalc \
        -a anatomical_mask.nii.gz \
        -b wm_mask_resample_erode.nii.gz \
        -c ventricle_mask_resample_erode.nii.gz \
        -expr 'step(a-(b+c))' \
        -prefix anatomical_mask_no_wm_ventricle.nii.gz
    # Make regressors
    total_num_runs=`ls ./media_?.nii.gz  | wc -l`
    for run in `seq 1 $total_num_runs`
    do
        rm ./files/text_files/media_"$run"_wm.1D
        3dmaskave \
            -quiet \
            -mask wm_mask_resample_erode.nii.gz \
                  media_"$run"_tshift_despike_reg_al_mni_mask.nii.gz \
                  > ./files/text_files/media_"$run"_wm.1D
        rm ./files/text_files/media_"$run"_ventricle.1D
        3dmaskave \
            -quiet \
            -mask ventricle_mask_resample.nii.gz \
                  media_"$run"_tshift_despike_reg_al_mni_mask.nii.gz \
                  > ./files/text_files/media_"$run"_ventricle.1D
    done

################################################################################
# Make outlier/censor files
################################################################################

# NOTE
# Outliers considered anything where more than 10% of voxels are

    total_num_runs=`ls ./media_?.nii.gz  | wc -l`
    for run in `seq 1 $total_num_runs`
    do
      num_timepoints=`3dinfo media_"$run"_tshift_despike_reg_al_mni_mask.nii.gz | grep "Number of time steps" | awk '{print $6}'`
      polort=`ccalc -i "1+int($num_timepoints*$tr)/150"`
      echo "***** polort =" $polort "*****"
      # Get fraction of outliers
      3dToutcount \
        -polort "$polort" -legendre -fraction \
        -mask anatomical_mask.nii.gz \
        media_"$run"_tshift_despike_reg_al_mni_mask.nii.gz \
        > ./files/text_files/media_"$run"_tshift_despike_reg_al_mni_mask_outcount.1D
       # Make 1D file
       # NOTE the 1D file is 1s for keep 0s for censor
       1deval \
        -a ./files/text_files/media_"$run"_tshift_despike_reg_al_mni_mask_outcount.1D \
        -expr 'equals((step(a-0.10)+1),1)' \
        > ./files/text_files/media_"$run"_tshift_despike_reg_al_mni_mask_outcount_10_percent_outliers.1D
       1deval \
        -a ./files/text_files/media_"$run"_tshift_despike_reg_al_mni_mask_outcount.1D \
        -expr 'equals((step(a-0.05)+1),1)' \
        > ./files/text_files/media_"$run"_tshift_despike_reg_al_mni_mask_outcount_5_percent_outliers.1D
    done

################################################################################
# Demean motion and wm/ventricle file
################################################################################

# NOTE
# This step prevents jumps across runs from affecting detrending

    total_num_runs=`ls ./media_?.nii.gz  | wc -l`
    for run in `seq 1 $total_num_runs`
    do
      1d_tool.py -overwrite -infile ./files/text_files/media_"$run"_motion.1D    \
        -set_nruns 1 -demean -write ./files/text_files/media_"$run"_motion_demean.1D
      1d_tool.py -overwrite -infile ./files/text_files/media_"$run"_wm.1D        \
        -set_nruns 1 -demean -write ./files/text_files/media_"$run"_wm_demean.1D
      1d_tool.py -overwrite -infile ./files/text_files/media_"$run"_ventricle.1D \
        -set_nruns 1 -demean -write ./files/text_files/media_"$run"_ventricle_demean.1D
    done

################################################################################
# Detrend and/or normalize (aka scale) functional data
################################################################################

# NOTE
# This step makes too many files that might be useless
    # Move in files if needed
    mv files/timeseries_files/media_?.nii.gz ./
    total_num_runs=`ls ./media_?.nii.gz  | wc -l`
    for run in `seq 1 $total_num_runs`
    do
        # Calculate a good polort number
        # 3dDeconvolve used: "-polort A": default is floor(1 + TR*nVOLS / 150) (from https://afni.nimh.nih.gov/pub/dist/doc/program_help/afni_restproc.py.html)
        # But this https://afni.nimh.nih.gov/afni/community/board/read.php?1,150673,150676#msg-150676 says:
        # 3dDeconvolve polort A uses A = 1 + floor(run_duration/150),where run_duration is in second
        # Those are the same b/c of the 1 sec TR
        num_timepoints=`3dinfo media_"$run"_tshift_despike_reg_al_mni_mask.nii.gz | grep "Number of time steps" | awk '{print $6}'`
        polort=`ccalc -i "1+int($num_timepoints*$tr)/150"`
        echo "***** polort =" $polort "*****"
        for blur in "" _blur"$functional_blur_amount"
        do
          # Move in files if needed
          mv files/timeseries_files/media_"$run"_tshift_despike_reg_al_mni_mask"$blur".nii.gz ./
          # Norm only
          # This one probably best suited for 3dDeconvolve
          # Can't use 3dDetrend here b/c detrend desperately wants to detrend something
          rm media_"$run"_tshift_despike_reg_al_mni_mask"$blur"_norm.nii.gz
          rm files/timeseries_files/media_"$run"_tshift_despike_reg_al_mni_mask"$blur"_norm.nii.gz
          3dTnorm \
            -prefix media_"$run"_tshift_despike_reg_al_mni_mask"$blur"_norm.nii.gz \
                    media_"$run"_tshift_despike_reg_al_mni_mask"$blur".nii.gz
          # Polort only
          rm media_"$run"_tshift_despike_reg_al_mni_mask"$blur"_polort.nii.gz
          rm files/timeseries_files/media_"$run"_tshift_despike_reg_al_mni_mask"$blur"_polort.nii.gz
          3dDetrend \
            -polort "$polort" \
            -prefix media_"$run"_tshift_despike_reg_al_mni_mask"$blur"_polort.nii.gz \
                    media_"$run"_tshift_despike_reg_al_mni_mask"$blur".nii.gz
          # Norm and polort
          rm media_"$run"_tshift_despike_reg_al_mni_mask"$blur"_norm_polort.nii.gz
          rm files/timeseries_files/media_"$run"_tshift_despike_reg_al_mni_mask"$blur"_norm_polort.nii.gz
          3dDetrend \
            -normalize \
            -polort "$polort" \
            -prefix media_"$run"_tshift_despike_reg_al_mni_mask"$blur"_norm_polort.nii.gz \
                    media_"$run"_tshift_despike_reg_al_mni_mask"$blur".nii.gz
          # Norm, polort, and motion
          rm media_"$run"_tshift_despike_reg_al_mni_mask"$blur"_norm_polort_motion.nii.gz
          rm files/timeseries_files/media_"$run"_tshift_despike_reg_al_mni_mask"$blur"_norm_polort_motion.nii.gz
          3dDetrend \
              -normalize \
              -polort "$polort" \
              -vector files/text_files/media_"$run"_"$move_type_for_detrend"_demean.1D \
              -prefix media_"$run"_tshift_despike_reg_al_mni_mask"$blur"_norm_polort_motion.nii.gz \
                      media_"$run"_tshift_despike_reg_al_mni_mask"$blur".nii.gz
          # Norm, polort, motion, and csf/wm
          rm media_"$run"_tshift_despike_reg_al_mni_mask"$blur"_norm_polort_motion_wm_ventricle.nii.gz
          rm files/timeseries_files/media_"$run"_tshift_despike_reg_al_mni_mask"$blur"_norm_polort_motion_wm_ventricle.nii.gz
          3dDetrend \
              -normalize \
              -polort "$polort" \
              -vector files/text_files/media_"$run"_"$move_type_for_detrend"_demean.1D \
              -vector files/text_files/media_"$run"_wm_demean.1D \
              -vector files/text_files/media_"$run"_ventricle_demean.1D \
              -prefix media_"$run"_tshift_despike_reg_al_mni_mask"$blur"_norm_polort_motion_wm_ventricle.nii.gz \
                      media_"$run"_tshift_despike_reg_al_mni_mask"$blur".nii.gz
        done
    done
done

################################################################################
# End
################################################################################
