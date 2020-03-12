#!/bin/bash

################################################################################
#  files and fix timing
################################################################################

# NOTE
# See ALL notes below for detailed descriptions as to what is being done

for perp in $perps
do
  # Change to perp directory
  cd "$data_dir"/"$perp"/
  # Remove v1 files if done
  rm *slug*.nii.gz
  rm *tp*nii.gz
  # Cycle through the
  for filename in blur"$functional_blur_amount"_norm_polort_motion_wm_ventricle norm_polort_motion_wm_ventricle blur"$functional_blur_amount"_norm_polort_motion norm_polort_motion blur"$functional_blur_amount"_norm_polort norm_polort blur"$functional_blur_amount"_polort polort blur"$functional_blur_amount"_norm norm
  do
    # NOTE
    # In v1 we add TRs where dropped - this step removed here
    # In the v1 of the movie script, we will always lose one TR when the scanner is stopped
    # We will also lose what ever bit of the movie the participant watched in that TR
    # In v2, this will be fixed by rewinding the movie the proper amount
    # So in v2 we skip to time shifting the files
    # *** Currently only works for up to 4 RUNS
    # Compensates for the fact that each run is always 100 ms (+/- a few ms) delayed
    # This is b/c of the way the script we use monitors for a pulse every 50 ms and cylces through to make sure there was no prior pulse
    # The +/- is presumably caused by system delays
    for run in `seq 1 $total_num_runs`
    do
      # NOTE
      # Run 1 gets an additional TR that is constructed above
      # It is also interpolated back as there is a delay from the movie script that is at min 100 ms
      if [ $run -eq  1 ]
      then
        # Backward interpolation amount
        # Okay to not convert to percentage b/c it will never be > 1000 (see below)
        # Make variable start
        functional_run_lost_start_actual=functional_"$run"_lost_start_"$perp"
        # Get value for start
        run_interpolation_length=`echo ".${!functional_run_lost_start_actual}"`
        # NOTE
        # Create a file for time shifting
        # Calculate fset, i.e., the file that tells tshift how much to time shift at each voxel
        # I tested this and the -1 one below was needed to shift back in time
        # The instructions for tshift, however, make it seem like it should be the opposite:
        # Creates 'fset' that contains the amount of time in percentage to shift the timeseries back.
        # The values in 'fset' are NOT in units of time, but rather are fractions of a TR to shift
        # A positive value means to shift backwards.
        # Data are already in % b/c our tr is 1000 ms
        # DAMN, need to fix for runs that go over one second!
        # For example, 1010 ms in the current script would = TR% of .10 when it should be 1.09
        # Fixed by converting to % at each step
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_interpolation_amount.nii.gz
        3dcalc \
          -a      media_"$run"_tshift_despike_reg_al_mni_mask_"$filename".nii.gz[0] \
          -datum  float -expr "-1*(step(abs(a))*"$run_interpolation_length")" \
          -prefix media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_interpolation_amount.nii.gz
        # Do time shifting using the above file
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
        3dTshift \
          -voxshift media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_interpolation_amount.nii.gz \
          -prefix   media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz \
                    media_"$run"_tshift_despike_reg_al_mni_mask_"$filename".nii.gz
      fi
      if [ $run -eq  2 ]
      then
        # NOTE
        # Set the prior run and get the backward interpolation amount
        # This number is currently supplied by Florin (from a script?)
        # Set prior run
        prior_run=`echo $(($run - 1))`
        # Make variable start
        current_run_functional_run_lost_start_actual=functional_"$run"_lost_start_"$perp"
        prior_run_functional_run_lost_start_actual=functional_"$prior_run"_lost_start_"$perp"
        # Get value for start
        current_run_functional_run_lost_start=`echo "${!current_run_functional_run_lost_start_actual}"`
        prior_run_functional_run_lost_start=`echo "${!prior_run_functional_run_lost_start_actual}"`
        # Get interp amount
        run_interpolation_length=`echo $((current_run_functional_run_lost_start + prior_run_functional_run_lost_start))`
        # Turn this into percentage
        # NOTE this step does not work if there are more than 9 runs
        run_interpolation_length=`echo ."$run_interpolation_length"`
        # NOTE
        # Create a file for time shifting
        # See run 1 above for more information
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_interpolation_amount.nii.gz
        3dcalc \
          -a      media_"$run"_tshift_despike_reg_al_mni_mask_"$filename".nii.gz[0] \
          -datum  float -expr "-1*(step(abs(a))*"$run_interpolation_length")" \
          -prefix media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_interpolation_amount.nii.gz
        # Do time shifting using the above file
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
        3dTshift \
          -voxshift media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_interpolation_amount.nii.gz \
          -prefix   media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz \
                    media_"$run"_tshift_despike_reg_al_mni_mask_"$filename".nii.gz
      fi
      if [[ $run -eq  3 ]]
      then
        # NOTE
        # Set the prior run and get the backward interpolation amount
        # Same as above but now need to account for the backward shift for runs 2+3
        # Set prior runs
        prior_run=`echo $(($run - 1))`
        prior_prior_run=`echo $(($run - 2))`
        # Make variable start
        current_run_functional_run_lost_start_actual=functional_"$run"_lost_start_"$perp"
        prior_run_functional_run_lost_start_actual=functional_"$prior_run"_lost_start_"$perp"
        prior_prior_run_functional_run_lost_start_actual=functional_"$prior_prior_run"_lost_start_"$perp"
        # Get value for start
        current_run_functional_run_lost_start=`echo "${!current_run_functional_run_lost_start_actual}"`
        prior_run_functional_run_lost_start=`echo "${!prior_run_functional_run_lost_start_actual}"`
        prior_prior_run_functional_run_lost_start=`echo "${!prior_prior_run_functional_run_lost_start_actual}"`
        # Get interp amount
        run_interpolation_length=`echo $((current_run_functional_run_lost_start + prior_run_functional_run_lost_start + prior_prior_run_functional_run_lost_start))`
        # Turn this into percentage
        # NOTE this step does not work if there are more than 9 runs
        run_interpolation_length=`echo ."$run_interpolation_length"`
        # NOTE
        # Create a file for time shifting
        # See run 1 above for more information
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_interpolation_amount.nii.gz
        3dcalc \
          -a      media_"$run"_tshift_despike_reg_al_mni_mask_"$filename".nii.gz[0] \
          -datum  float -expr "-1*(step(abs(a))*"$run_interpolation_length")" \
          -prefix media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_interpolation_amount.nii.gz
        # Do time shifting using the above file
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
        3dTshift \
          -voxshift media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_interpolation_amount.nii.gz \
          -prefix   media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz \
                    media_"$run"_tshift_despike_reg_al_mni_mask_"$filename".nii.gz
      fi
      if [[ $run -eq  4 ]]
      then
        # NOTE
        # Set the prior run and get the backward interpolation amount
        # Same as above but now need to account for the backward shift for runs 2+3
        # Set prior runs
        prior_run=`echo $(($run - 1))`
        prior_prior_run=`echo $(($run - 2))`
        prior_prior_prior_run=`echo $(($run - 3))`
        # Make variable start
        current_run_functional_run_lost_start_actual=functional_"$run"_lost_start_"$perp"
        prior_run_functional_run_lost_start_actual=functional_"$prior_run"_lost_start_"$perp"
        prior_prior_run_functional_run_lost_start_actual=functional_"$prior_prior_run"_lost_start_"$perp"
        prior_prior_prior_run_functional_run_lost_start_actual=functional_"$prior_prior_prior_run"_lost_start_"$perp"
        # Get value for start
        current_run_functional_run_lost_start=`echo "${!current_run_functional_run_lost_start_actual}"`
        prior_run_functional_run_lost_start=`echo "${!prior_run_functional_run_lost_start_actual}"`
        prior_prior_run_functional_run_lost_start=`echo "${!prior_prior_run_functional_run_lost_start_actual}"`
        prior_prior_prior_run_functional_run_lost_start=`echo "${!prior_prior_prior_run_functional_run_lost_start_actual}"`
        # Get interp amount
        run_interpolation_length=`echo $((current_run_functional_run_lost_start + prior_run_functional_run_lost_start + prior_prior_run_functional_run_lost_start + prior_prior_prior_run_functional_run_lost_start))`
        # Turn this into percentage
        # NOTE this step does not work if there are more than 9 runs
        run_interpolation_length=`echo ."$run_interpolation_length"`
        # NOTE
        # Create a file for time shifting
        # See run 1 above for more information
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_interpolation_amount.nii.gz
        3dcalc \
          -a      media_"$run"_tshift_despike_reg_al_mni_mask_"$filename".nii.gz[0] \
          -datum  float -expr "-1*(step(abs(a))*"$run_interpolation_length")" \
          -prefix media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_interpolation_amount.nii.gz
        # Do time shifting using the above file
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
        3dTshift \
          -voxshift media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_interpolation_amount.nii.gz \
          -prefix   media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz \
                    media_"$run"_tshift_despike_reg_al_mni_mask_"$filename".nii.gz
      fi
      if [[ $run -eq  5 ]]
      then
        # NOTE
        # Set the prior run and get the backward interpolation amount
        # Same as above but now need to account for the backward shift for runs 2+3
        # Set prior runs
        prior_run=`echo $(($run - 1))`
        prior_prior_run=`echo $(($run - 2))`
        prior_prior_prior_run=`echo $(($run - 3))`
        prior_prior_prior_prior_run=`echo $(($run - 4))`
        # Make variable start
        current_run_functional_run_lost_start_actual=functional_"$run"_lost_start_"$perp"
        prior_run_functional_run_lost_start_actual=functional_"$prior_run"_lost_start_"$perp"
        prior_prior_run_functional_run_lost_start_actual=functional_"$prior_prior_run"_lost_start_"$perp"
        prior_prior_prior_run_functional_run_lost_start_actual=functional_"$prior_prior_prior_run"_lost_start_"$perp"
        prior_prior_prior_prior_run_functional_run_lost_start_actual=functional_"$prior_prior_prior_prior_run"_lost_start_"$perp"
        # Get value for start
        current_run_functional_run_lost_start=`echo "${!current_run_functional_run_lost_start_actual}"`
        prior_run_functional_run_lost_start=`echo "${!prior_run_functional_run_lost_start_actual}"`
        prior_prior_run_functional_run_lost_start=`echo "${!prior_prior_run_functional_run_lost_start_actual}"`
        prior_prior_prior_run_functional_run_lost_start=`echo "${!prior_prior_prior_run_functional_run_lost_start_actual}"`
        prior_prior_prior_prior_run_functional_run_lost_start=`echo "${!prior_prior_prior_prior_run_functional_run_lost_start_actual}"`
        # Get interp amount
        run_interpolation_length=`echo $((current_run_functional_run_lost_start + prior_run_functional_run_lost_start + prior_prior_run_functional_run_lost_start + prior_prior_prior_run_functional_run_lost_start + prior_prior_prior_prior_run_functional_run_lost_start))`
        # Turn this into percentage
        # NOTE this step does not work if there are more than 9 runs
        run_interpolation_length=`echo ."$run_interpolation_length"`
        # NOTE
        # Create a file for time shifting
        # See run 1 above for more information
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_interpolation_amount.nii.gz
        3dcalc \
          -a      media_"$run"_tshift_despike_reg_al_mni_mask_"$filename".nii.gz[0] \
          -datum  float -expr "-1*(step(abs(a))*"$run_interpolation_length")" \
          -prefix media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_interpolation_amount.nii.gz
        # Do time shifting using the above file
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
        3dTshift \
          -voxshift media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_interpolation_amount.nii.gz \
          -prefix   media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz \
                    media_"$run"_tshift_despike_reg_al_mni_mask_"$filename".nii.gz
      fi
    done
  done
done

################################################################################
# End
################################################################################
