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
  # Cycle through the
  for filename in blur"$functional_blur_amount"_norm_polort_motion_wm_ventricle norm_polort_motion_wm_ventricle blur"$functional_blur_amount"_norm_polort_motion norm_polort_motion blur"$functional_blur_amount"_norm_polort norm_polort blur"$functional_blur_amount"_polort polort blur"$functional_blur_amount"_norm norm
  do
    # NOTE
    # Add TRs where dropped
    # In the v1 of the movie script, we will always lose one TR when the scanner is stopped
    # We will also lose what ever bit of the movie the participant watched in that TR
    # So, movie_timing_v1 adds the tr back on
    # It does so by:
    # 1) Getting the last tp of the run in which the movie was stopped
    # 2) Getting the first tp of the run after the movie was stopped
    # 3) Averaging these
    # This assumes that the last tr will be a lot like the prior (semi-reasonable with fMRI)
    # It also makes the transition between TRs less abrupt, more smooth so that preprocessing and various analysis are less messed up
    # It is done before normalization so it assumes the scanner values didn't change drastically b/n adjacent runs
    # Get number of runs and loop through them
    # Expect errors from this part of the loop as it will try to make a file from a run that doesn't exit - this is fine but could fix...
    total_num_runs=`ls ./media_?.nii.gz  | wc -l`
    for run in `seq 1 $total_num_runs`
    do
      # Get the last time point of the run working on
      rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_last_tp.nii.gz
      3dcalc \
        -a      media_"$run"_tshift_despike_reg_al_mni_mask_"$filename".nii.gz[$] \
        -datum  float -expr "a*step(abs(a))" \
        -prefix media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_last_tp.nii.gz
      # Get first time point of next run
      next_run=`echo $((run + 1))`
      rm media_"$next_run"_tshift_despike_reg_al_mni_mask_"$filename"_first_tp.nii.gz
      3dcalc \
        -a      media_"$next_run"_tshift_despike_reg_al_mni_mask_"$filename".nii.gz[0] \
        -datum  float -expr "a*step(abs(a))" \
        -prefix media_"$next_run"_tshift_despike_reg_al_mni_mask_"$filename"_first_tp.nii.gz
      # Average these, i.e., the last tp and first tp
      rm media_"$run"_"$next_run"_tshift_despike_reg_al_mni_mask_"$filename"_slug.nii.gz
      3dMean \
        -prefix media_"$run"_"$next_run"_tshift_despike_reg_al_mni_mask_"$filename"_slug.nii.gz \
                media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_last_tp.nii.gz \
                media_"$next_run"_tshift_despike_reg_al_mni_mask_"$filename"_first_tp.nii.gz
      # Add the new slug to the end of the run timeseries
      rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_slug.nii.gz
      3dTcat \
        -prefix media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_slug.nii.gz \
                media_"$run"_tshift_despike_reg_al_mni_mask_"$filename".nii.gz \
                media_"$run"_"$next_run"_tshift_despike_reg_al_mni_mask_"$filename"_slug.nii.gz
    done
    # NOTE
    # Now time shift files
    # *** Currently only works for up to 5 RUNS
    # Explanation:
    # The amount of time dropped in run one will determine how far back to intrpolate run 2 and so on
    # So, if the movie stopped at 1000.750
    # The last full TR was discarded
    # That means that 750 ms of the movie was watched but discarded
    # This discarded information is missing from the ts
    # To account for it, we add a tr (done above) and interpolate the next run backwards in time the amount not covered by this TR
    # So for 750 ms of movie not watched, this means there is 250 ms too much time added to the movie with our TR
    # So we shift the next run back this amount so the ts would theoretically be aligned (though in reality this is never possible)
    # If there is another run (i.e., 3+), the same logic applies
    # Except that the extra 250 ms needs to be accounted for
    # So, if the next run stopped at 2000.600
    # We will shift run 3 back (1000-600)+250 ms = 750 ms
    # If Florin's script comes up with >1000 this means we need to actually shift forward in time on the next TR whatever amount over 1000
    # So if the value is 1050, we need to shift forward 50 ms
    # However, as there are never more than 1100 (so far), we never need to do this b/c it is substracted from the 100 ms described next
    # That is, all the above is complicated by the fact that each run is always 100 ms (+/- a few ms) delayed
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
        functional_run_lost_start_actual=functional_"$run"_lost_start_"$perp"
        run_interpolation_length=`echo ".${!functional_run_lost_start_actual}"`
        # As this is the first run, and there are always at least 2 runs, must operate on slugged data set
        file_ending="_slug"
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
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz
        3dcalc \
          -a      media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending".nii.gz[0] \
          -datum  float -expr "-1*(step(abs(a))*"$run_interpolation_length")" \
          -prefix media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz
        # Do time shifting using the above file
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
        3dTshift \
          -voxshift media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz \
          -prefix   media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz \
                    media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending".nii.gz
      fi
      if [ $run -eq  2 ]
      then
        # NOTE
        # Set file ending
        # If this is the last run, it does not get a slug
        if [[ $run -eq  2 ]] && [[ $run -eq $total_num_runs ]]
        then
          file_ending=""
        else
          file_ending="_slug"
        fi
        # NOTE
        # Set the prior run and get the backward interpolation amount
        # This number is currently supplied by Florin (from a script?)
        # Set prior run
        prior_run=`echo $(($run - 1))`
        # Make variable
        current_run_functional_run_lost_start_actual=functional_"$run"_lost_start_"$perp"
        prior_run_functional_run_lost_start_actual=functional_"$prior_run"_lost_start_"$perp"
        prior_run_functional_run_lost_end_actual=functional_"$prior_run"_lost_end_"$perp"
        # Get value
        current_run_functional_run_lost_start=`echo "${!current_run_functional_run_lost_start_actual}"`
        prior_run_functional_run_lost_start=`echo "${!prior_run_functional_run_lost_start_actual}"`
        prior_run_functional_run_lost_end=`echo "${!prior_run_functional_run_lost_end_actual}"`
        # Get interp amount
        run_interpolation_length=`echo $(((1000 - prior_run_functional_run_lost_end) + (current_run_functional_run_lost_start + prior_run_functional_run_lost_start)))`
        # Turn this into percentage
        if [[ $run_interpolation_length -gt  999 ]]
        then
          run_interpolation_length=`echo 'scale=3;'$run_interpolation_length'/1000' | bc`
        else
          run_interpolation_length=`echo ."$run_interpolation_length"`
        fi
        # NOTE
        # Create a file for time shifting
        # See run 1 above for more information
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz
        3dcalc \
          -a      media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending".nii.gz[0] \
          -datum  float -expr "-1*(step(abs(a))*"$run_interpolation_length")" \
          -prefix media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz
        # Do time shifting using the above file
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
        3dTshift \
          -voxshift media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz \
          -prefix   media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz \
                    media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending".nii.gz
      fi
      if [[ $run -eq  3 ]]
      then
        # Set file ending
        if [[ $run -eq  3 ]] && [[ $run -eq $total_num_runs ]]
        then
          file_ending=""
        else
          file_ending="_slug"
        fi
        # NOTE
        # Set the prior run and get the backward interpolation amount
        # Same as above but now need to account for the backward shift for runs 2+3
        # Set prior runs
        prior_run=`echo $(($run - 1))`
        prior_prior_run=`echo $(($run - 2))`
        # Make variable
        current_run_functional_run_lost_start_actual=functional_"$run"_lost_start_"$perp"
        prior_run_functional_run_lost_start_actual=functional_"$prior_run"_lost_start_"$perp"
        prior_prior_run_functional_run_lost_start_actual=functional_"$prior_prior_run"_lost_start_"$perp"
        prior_run_functional_run_lost_end_actual=functional_"$prior_run"_lost_end_"$perp"
        prior_prior_run_functional_run_lost_end_actual=functional_"$prior_prior_run"_lost_end_"$perp"
        # Get value
        current_run_functional_run_lost_start=`echo "${!current_run_functional_run_lost_start_actual}"`
        prior_run_functional_run_lost_start=`echo "${!prior_run_functional_run_lost_start_actual}"`
        prior_prior_run_functional_run_lost_start=`echo "${!prior_prior_run_functional_run_lost_start_actual}"`
        prior_run_functional_run_lost_end=`echo "${!prior_run_functional_run_lost_end_actual}"`
        prior_prior_run_functional_run_lost_end=`echo "${!prior_prior_run_functional_run_lost_end_actual}"`
        # Get interp amount
        run_interpolation_length=`echo $(((1000 - prior_run_functional_run_lost_end) + (1000 - prior_prior_run_functional_run_lost_end) + (current_run_functional_run_lost_start + prior_run_functional_run_lost_start + prior_prior_run_functional_run_lost_start)))`
        # Turn this into percentage
        if [[ $run_interpolation_length -gt  999 ]]
        then
          run_interpolation_length=`echo 'scale=3;'$run_interpolation_length'/1000' | bc`
        else
          run_interpolation_length=`echo ."$run_interpolation_length"`
        fi
        # NOTE
        # Create a file for time shifting
        # See run 1 above for more information
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz
        3dcalc \
          -a      media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending".nii.gz[0] \
          -datum  float -expr "-1*(step(abs(a))*"$run_interpolation_length")" \
          -prefix media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz

        # Do time shifting using the above file
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
        3dTshift \
          -voxshift media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz \
          -prefix   media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz \
                    media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending".nii.gz
      fi
      if [[ $run -eq  4 ]]
      then
        # Set file ending
        if [[ $run -eq  4 ]] && [[ $run -eq $total_num_runs ]]
        then
          file_ending=""
        else
          file_ending="_slug"
        fi
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
        # Make variable end
        prior_run_functional_run_lost_end_actual=functional_"$prior_run"_lost_end_"$perp"
        prior_prior_run_functional_run_lost_end_actual=functional_"$prior_prior_run"_lost_end_"$perp"
        prior_prior_prior_run_functional_run_lost_end_actual=functional_"$prior_prior_prior_run"_lost_end_"$perp"
        # Get value for start
        current_run_functional_run_lost_start=`echo "${!current_run_functional_run_lost_start_actual}"`
        prior_run_functional_run_lost_start=`echo "${!prior_run_functional_run_lost_start_actual}"`
        prior_prior_run_functional_run_lost_start=`echo "${!prior_prior_run_functional_run_lost_start_actual}"`
        prior_prior_prior_run_functional_run_lost_start=`echo "${!prior_prior_prior_run_functional_run_lost_start_actual}"`
        # Get value for end
        prior_run_functional_run_lost_end=`echo "${!prior_run_functional_run_lost_end_actual}"`
        prior_prior_run_functional_run_lost_end=`echo "${!prior_prior_run_functional_run_lost_end_actual}"`
        prior_prior_prior_run_functional_run_lost_end=`echo "${!prior_prior_prior_run_functional_run_lost_end_actual}"`
        # Get interp amount
        # run_interpolation_length=`echo $(((1000 - prior_run_functional_run_lost_end) + (1000 - prior_prior_run_functional_run_lost_end) + (current_run_functional_run_lost_start + prior_run_functional_run_lost_start + prior_prior_run_functional_run_lost_start)))`
        run_interpolation_length=`echo $(((1000 - prior_run_functional_run_lost_end) + (1000 - prior_prior_run_functional_run_lost_end) + (1000 - prior_prior_prior_run_functional_run_lost_end) + (current_run_functional_run_lost_start + prior_run_functional_run_lost_start + prior_prior_run_functional_run_lost_start + prior_prior_prior_run_functional_run_lost_start)))`
        # Turn this into percentage
        if [[ $run_interpolation_length -gt  999 ]]
        then
          run_interpolation_length=`echo 'scale=3;'$run_interpolation_length'/1000' | bc`
        else
          run_interpolation_length=`echo ."$run_interpolation_length"`
        fi
        # NOTE
        # Create a file for time shifting
        # See run 1 above for more information
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz
        3dcalc \
          -a      media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending".nii.gz[0] \
          -datum  float -expr "-1*(step(abs(a))*"$run_interpolation_length")" \
          -prefix media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz
        # Do time shifting using the above file
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
        3dTshift \
          -voxshift media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz \
          -prefix   media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz \
                    media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending".nii.gz
      fi
      if [[ $run -eq  5 ]]
      then
        # Set file ending
        if [[ $run -eq  5 ]] && [[ $run -eq $total_num_runs ]]
        then
          file_ending=""
        else
          file_ending="_slug"
        fi
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
        # Make variable end
        prior_run_functional_run_lost_end_actual=functional_"$prior_run"_lost_end_"$perp"
        prior_prior_run_functional_run_lost_end_actual=functional_"$prior_prior_run"_lost_end_"$perp"
        prior_prior_prior_run_functional_run_lost_end_actual=functional_"$prior_prior_prior_run"_lost_end_"$perp"
        prior_prior_prior_prior_run_functional_run_lost_end_actual=functional_"$prior_prior_prior_prior_run"_lost_end_"$perp"
        # Get value for start
        current_run_functional_run_lost_start=`echo "${!current_run_functional_run_lost_start_actual}"`
        prior_run_functional_run_lost_start=`echo "${!prior_run_functional_run_lost_start_actual}"`
        prior_prior_run_functional_run_lost_start=`echo "${!prior_prior_run_functional_run_lost_start_actual}"`
        prior_prior_prior_run_functional_run_lost_start=`echo "${!prior_prior_prior_run_functional_run_lost_start_actual}"`
        prior_prior_prior_prior_run_functional_run_lost_start=`echo "${!prior_prior_prior_prior_run_functional_run_lost_start_actual}"`
        # Get value for end
        prior_run_functional_run_lost_end=`echo "${!prior_run_functional_run_lost_end_actual}"`
        prior_prior_run_functional_run_lost_end=`echo "${!prior_prior_run_functional_run_lost_end_actual}"`
        prior_prior_prior_run_functional_run_lost_end=`echo "${!prior_prior_prior_run_functional_run_lost_end_actual}"`
        prior_prior_prior_prior_run_functional_run_lost_end=`echo "${!prior_prior_prior_prior_run_functional_run_lost_end_actual}"`
        # Get interp amount
        # run_interpolation_length=`echo $(((1000 - prior_run_functional_run_lost_end) + (1000 - prior_prior_run_functional_run_lost_end) + (current_run_functional_run_lost_start + prior_run_functional_run_lost_start + prior_prior_run_functional_run_lost_start)))`
        run_interpolation_length=`echo $(((1000 - prior_run_functional_run_lost_end) + (1000 - prior_prior_run_functional_run_lost_end) + (1000 - prior_prior_prior_run_functional_run_lost_end) + (1000 - prior_prior_prior_prior_run_functional_run_lost_end) + (current_run_functional_run_lost_start + prior_run_functional_run_lost_start + prior_prior_run_functional_run_lost_start + prior_prior_prior_run_functional_run_lost_start + prior_prior_prior_prior_run_functional_run_lost_start)))`
        # Turn this into percentage
        if [[ $run_interpolation_length -gt  999 ]]
        then
          run_interpolation_length=`echo 'scale=3;'$run_interpolation_length'/1000' | bc`
        else
          run_interpolation_length=`echo ."$run_interpolation_length"`
        fi
        # NOTE
        # Create a file for time shifting
        # See run 1 above for more information
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz
        3dcalc \
          -a      media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending".nii.gz[0] \
          -datum  float -expr "-1*(step(abs(a))*"$run_interpolation_length")" \
          -prefix media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz
        # Do time shifting using the above file
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
        3dTshift \
          -voxshift media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz \
          -prefix   media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz \
                    media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending".nii.gz
      fi
    done
  done
done

################################################################################
# End
################################################################################
