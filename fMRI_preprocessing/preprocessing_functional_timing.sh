#!/bin/bash

################################################################################
#  Fix movie timing
################################################################################

# NOTE
# This syncronizes the scans to the movie
# This is necessary b/c the scanner needed to be stopped every hour and the participants sometimes requested a break.
#   1) When the scanner is started or stopped, the mriplayer script continues to check if there TTL pulses are really coming for 100 ms
#   2) If the scanner is stopped, the entire TR being collected is dropped
# There were a number of mriplayer scripts
# v1 - Simply started and stopped the movie
# v2 - Rewound to account for the missed time when the scanner was dropped but mistakenly fast-forwarded sometimes
# v3 - Rewound
# The below deals with the timing of all these as they all require some form of interpolation
# NOTE - I have now carefully checked these and I think all prior versions of the timing script can be deleted
# It is very complicated to fix the timining so see ALL notes below for detailed descriptions as to what is being done
# There are some redundancies in the script that could be fixed to save time, e.g., interpolation images are done for all filenames though they really only need to be done once
# NOTE - This script currently only words for up to 6 runs
# NOTE - For perps with 5 or 6, this script only works correctly for the movie script that correctly always rewinds (or incorrectly always fastforwards). If something else is needed, it needts to be hand coded in (as there are too many possible combinations of true & false to write them all in)
# NOTE - Left off by duplicating slug_ and not slug interpolation files because I think either might be needed now
# NOTE - to check time:
# ll files/timeseries_files/*blur*_wm_ventricle*interpolation_amount.nii.gz
# 3dinfo files/timeseries_files/*blur*_wm_ventricle*interpolation_amount.nii.gz | grep brick

################################################################################
#  Start
################################################################################

for perp in $perps
do
  # Change to perp directory
  cd "$data_dir"/"$perp"/
  # Cycle through the
  for filename in blur"$functional_blur_amount"_norm_polort_motion_wm_ventricle norm_polort_motion_wm_ventricle blur"$functional_blur_amount"_norm_polort_motion norm_polort_motion blur"$functional_blur_amount"_norm_polort norm_polort blur"$functional_blur_amount"_polort polort blur"$functional_blur_amount"_norm norm
  do
    # Move in files if already moved
    mv files/timeseries_files/media_?.nii.gz ./
    mv files/timeseries_files/media_?_tshift_despike_reg_al_mni_mask_"$filename".nii.gz ./
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
      rm files/timeseries_files/media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_last_tp.nii.gz
      3dcalc \
        -a      media_"$run"_tshift_despike_reg_al_mni_mask_"$filename".nii.gz[$] \
        -datum  float -expr "a*step(abs(a))" \
        -prefix media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_last_tp.nii.gz
      # Get first time point of next run
      next_run=`echo $((run + 1))`
      rm media_"$next_run"_tshift_despike_reg_al_mni_mask_"$filename"_first_tp.nii.gz
      rm files/timeseries_files/media_"$next_run"_tshift_despike_reg_al_mni_mask_"$filename"_first_tp.nii.gz
      3dcalc \
        -a      media_"$next_run"_tshift_despike_reg_al_mni_mask_"$filename".nii.gz[0] \
        -datum  float -expr "a*step(abs(a))" \
        -prefix media_"$next_run"_tshift_despike_reg_al_mni_mask_"$filename"_first_tp.nii.gz
      # Average these, i.e., the last tp and first tp
      rm media_"$run"_"$next_run"_tshift_despike_reg_al_mni_mask_"$filename"_slug.nii.gz
      rm files/timeseries_files/media_"$run"_"$next_run"_tshift_despike_reg_al_mni_mask_"$filename"_slug.nii.gz
      3dMean \
        -prefix media_"$run"_"$next_run"_tshift_despike_reg_al_mni_mask_"$filename"_slug.nii.gz \
                media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_last_tp.nii.gz \
                media_"$next_run"_tshift_despike_reg_al_mni_mask_"$filename"_first_tp.nii.gz
      # Add the new slug to the end of the run timeseries
      rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_slug.nii.gz
      rm files/timeseries_files/media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_slug.nii.gz
      3dTcat \
        -prefix media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_slug.nii.gz \
                media_"$run"_tshift_despike_reg_al_mni_mask_"$filename".nii.gz \
                media_"$run"_"$next_run"_tshift_despike_reg_al_mni_mask_"$filename"_slug.nii.gz
      # Also add to the last run
      if [[ $run -eq $total_num_runs ]]
      then
        3dTcat \
          -prefix media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_slug.nii.gz \
                  media_"$run"_tshift_despike_reg_al_mni_mask_"$filename".nii.gz \
                  media_"$run"_tshift_despike_reg_al_mni_mask_"$filename".nii.gz[$]
      fi
    done
    # NOTE
    # Now time shift files
    # *** Currently only works for up to 6 RUNS
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
        # See whether run 2 was rewound
        functional_2_rewind_value_actual=functional_2_rewind_"$perp"
        functional_2_rewind_value=`echo "${!functional_2_rewind_value_actual}"`
        # If is the first run, and there are always at least 2 runs, must operate on slugged data set if not rewound
        # See whether to add a slug based on next run
        if [[ $functional_2_rewind_value == "true" ]]
        then
          file_ending=""
        else
          file_ending="_slug"
        fi
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
        rm files/timeseries_files/media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz
        3dcalc \
          -a      media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending".nii.gz[0] \
          -datum  float -expr "-1*(step(abs(a))*"$run_interpolation_length")" \
          -prefix media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz
        # Do time shifting using the above file
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
        rm files/timeseries_files/media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
        3dTshift \
          -voxshift media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz \
          -prefix   media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz \
                    media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending".nii.gz
      fi
      if [ $run -eq  2 ]
      then
        # NOTE
        # Set file ending
        # If this is the last run or run 3 was rewound, it does not get a slug
        # See whether runs 2 and/or 3 was rewound:
        functional_2_rewind_value_actual=functional_2_rewind_"$perp"
        functional_2_rewind_value=`echo "${!functional_2_rewind_value_actual}"`
        functional_3_rewind_value_actual=functional_3_rewind_"$perp"
        functional_3_rewind_value=`echo "${!functional_3_rewind_value_actual}"`
        # See whether to add a slug based on next run
        # if [[ $run -eq  2 ]] && [[ $run -eq $total_num_runs ]] || [[ $functional_3_rewind_value == "true" ]]
        # then
        #   file_ending=""
        # else
        #   file_ending="_slug"
        # fi
        if [[ $run -eq  2 ]] && [[ $run -eq $total_num_runs ]] || [[ $functional_3_rewind_value == "false" ]]
        then
           file_ending="_slug"
        else
           file_ending=""
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
        # If run 2 was rewound, then just take the values from the general_set_variables.sh (should be a small number)
        # You do not subtract 1000 in this case because you didn't add a slug and do not need to interpolate backwards
        if [[ $functional_2_rewind_value == "true" ]]
        then
          # Get interp amount if fuctional run 2 was rewound
          run_interpolation_length=`echo $(((prior_run_functional_run_lost_end) + (current_run_functional_run_lost_start + prior_run_functional_run_lost_start)))`
        else
          # Get interp amount if fuctional run 2 was not rewound
          run_interpolation_length=`echo $(((1000 - prior_run_functional_run_lost_end) + (current_run_functional_run_lost_start + prior_run_functional_run_lost_start)))`
        fi
        # Turn this into percentage
        # if [[ $run_interpolation_length -gt  999 ]]
        # then
        #   run_interpolation_length=`echo 'scale=3;'$run_interpolation_length'/1000' | bc`
        # else
        #   run_interpolation_length=`echo ."$run_interpolation_length"`
        # fi
        run_interpolation_length=`echo 'scale=3;'$run_interpolation_length'/1000' | bc`
        # NOTE
        # Create a file for time shifting
        # See run 1 above for more information
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz
        rm files/timeseries_files/media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz
        3dcalc \
          -a      media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending".nii.gz[0] \
          -datum  float -expr "-1*(step(abs(a))*"$run_interpolation_length")" \
          -prefix media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz
        # Do time shifting using the above file
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
        rm files/timeseries_files/media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
        3dTshift \
          -voxshift media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz \
          -prefix   media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz \
                    media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending".nii.gz
      fi
      if [[ $run -eq  3 ]]
      then
        # See whether runs 2, 3, and/or 4 was rewound
        functional_2_rewind_value_actual=functional_2_rewind_"$perp"
        functional_2_rewind_value=`echo "${!functional_2_rewind_value_actual}"`
        functional_3_rewind_value_actual=functional_3_rewind_"$perp"
        functional_3_rewind_value=`echo "${!functional_3_rewind_value_actual}"`
        functional_4_rewind_value_actual=functional_4_rewind_"$perp"
        functional_4_rewind_value=`echo "${!functional_4_rewind_value_actual}"`
        # See whether to add a slug based on next run
        # if [[ $run -eq  3 ]] && [[ $run -eq $total_num_runs ]] || [[ $functional_4_rewind_value == "true" ]]
        # then
        #   file_ending=""
        # else
        #   file_ending="_slug"
        # fi
        if [[ $run -eq  3 ]] && [[ $run -eq $total_num_runs ]] || [[ $functional_4_rewind_value == "false" ]]
        then
           file_ending="_slug"
        else
           file_ending=""
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
        if [[ $functional_2_rewind_value == "false" ]] && [[ $functional_3_rewind_value == "false" ]]
        then
          run_interpolation_length=`echo $(((1000 - prior_run_functional_run_lost_end) + (1000 - prior_prior_run_functional_run_lost_end) + (current_run_functional_run_lost_start + prior_run_functional_run_lost_start + prior_prior_run_functional_run_lost_start)))`
        fi
        if [[ $functional_2_rewind_value == "true" ]] && [[ $functional_3_rewind_value == "true" ]]
        then
          run_interpolation_length=`echo $(((prior_run_functional_run_lost_end) + (prior_prior_run_functional_run_lost_end) + (current_run_functional_run_lost_start + prior_run_functional_run_lost_start + prior_prior_run_functional_run_lost_start)))`
        fi
        if [[ $functional_2_rewind_value == "false" ]] && [[ $functional_3_rewind_value == "true" ]]
        then
          run_interpolation_length=`echo $(((prior_run_functional_run_lost_end) + (1000 - prior_prior_run_functional_run_lost_end) + (current_run_functional_run_lost_start + prior_run_functional_run_lost_start + prior_prior_run_functional_run_lost_start)))`
        fi
        if [[ $functional_2_rewind_value == "true" ]] && [[ $functional_3_rewind_value == "false" ]]
        then
          run_interpolation_length=`echo $(((1000 - prior_run_functional_run_lost_end) + (prior_prior_run_functional_run_lost_end) + (current_run_functional_run_lost_start + prior_run_functional_run_lost_start + prior_prior_run_functional_run_lost_start)))`
        fi
        # Turn this into percentage
        # if [[ $run_interpolation_length -gt  999 ]]
        # then
        #   run_interpolation_length=`echo 'scale=3;'$run_interpolation_length'/1000' | bc`
        # else
        #   run_interpolation_length=`echo ."$run_interpolation_length"`
        # fi
        run_interpolation_length=`echo 'scale=3;'$run_interpolation_length'/1000' | bc`
        # NOTE
        # Create a file for time shifting
        # See run 1 above for more information
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz
        rm files/timeseries_files/media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz
        3dcalc \
          -a      media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending".nii.gz[0] \
          -datum  float -expr "-1*(step(abs(a))*"$run_interpolation_length")" \
          -prefix media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
        rm files/timeseries_files/media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
        3dTshift \
          -voxshift media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz \
          -prefix   media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz \
                    media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending".nii.gz
      fi
      if [[ $run -eq  4 ]]
      then
        # Set file ending
        # See whether runs 2, 3, 4, and/or 5 was rewound
        functional_2_rewind_value_actual=functional_2_rewind_"$perp"
        functional_2_rewind_value=`echo "${!functional_2_rewind_value_actual}"`
        functional_3_rewind_value_actual=functional_3_rewind_"$perp"
        functional_3_rewind_value=`echo "${!functional_3_rewind_value_actual}"`
        functional_4_rewind_value_actual=functional_4_rewind_"$perp"
        functional_4_rewind_value=`echo "${!functional_4_rewind_value_actual}"`
        functional_5_rewind_value_actual=functional_5_rewind_"$perp"
        functional_5_rewind_value=`echo "${!functional_5_rewind_value_actual}"`
        # See whether to add a slug based on next run
        # if [[ $run -eq  4 ]] && [[ $run -eq $total_num_runs ]] || [[ $functional_5_rewind_value == "true" ]]
        # then
        #   file_ending=""
        # else
        #   file_ending="_slug"
        # fi
        if [[ $run -eq  4 ]] && [[ $run -eq $total_num_runs ]] || [[ $functional_5_rewind_value == "false" ]]
        then
           file_ending="_slug"
        else
           file_ending=""
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
        if [[ $functional_2_rewind_value == "false" ]] && [[ $functional_3_rewind_value == "false" ]] && [[ $functional_4_rewind_value == "false" ]]
        then
          run_interpolation_length=`echo $(((1000 - prior_run_functional_run_lost_end) + (1000 - prior_prior_run_functional_run_lost_end) + (1000 - prior_prior_prior_run_functional_run_lost_end) + (current_run_functional_run_lost_start + prior_run_functional_run_lost_start + prior_prior_run_functional_run_lost_start + prior_prior_prior_run_functional_run_lost_start)))`
        fi
        if [[ $functional_2_rewind_value == "true" ]] && [[ $functional_3_rewind_value == "true" ]] && [[ $functional_4_rewind_value == "true" ]]
        then
          run_interpolation_length=`echo $(((prior_run_functional_run_lost_end) + (prior_prior_run_functional_run_lost_end) + (prior_prior_prior_run_functional_run_lost_end) + (current_run_functional_run_lost_start + prior_run_functional_run_lost_start + prior_prior_run_functional_run_lost_start + prior_prior_prior_run_functional_run_lost_start)))`
        fi
        if [[ $functional_2_rewind_value == "false" ]] && [[ $functional_3_rewind_value == "false" ]] && [[ $functional_4_rewind_value == "true" ]]
        then
          run_interpolation_length=`echo $(((prior_run_functional_run_lost_end) + (1000 - prior_prior_run_functional_run_lost_end) + (1000 - prior_prior_prior_run_functional_run_lost_end) + (current_run_functional_run_lost_start + prior_run_functional_run_lost_start + prior_prior_run_functional_run_lost_start + prior_prior_prior_run_functional_run_lost_start)))`
        fi
        if [[ $functional_2_rewind_value == "false" ]] && [[ $functional_3_rewind_value == "true" ]] && [[ $functional_4_rewind_value == "false" ]]
        then
          run_interpolation_length=`echo $(((1000 - prior_run_functional_run_lost_end) + (prior_prior_run_functional_run_lost_end) + (1000 - prior_prior_prior_run_functional_run_lost_end) + (current_run_functional_run_lost_start + prior_run_functional_run_lost_start + prior_prior_run_functional_run_lost_start + prior_prior_prior_run_functional_run_lost_start)))`
        fi
        if [[ $functional_2_rewind_value == "true" ]] && [[ $functional_3_rewind_value == "false" ]] && [[ $functional_4_rewind_value == "false" ]]
        then
          run_interpolation_length=`echo $(((1000 - prior_run_functional_run_lost_end) + (1000 - prior_prior_run_functional_run_lost_end) + (prior_prior_prior_run_functional_run_lost_end) + (current_run_functional_run_lost_start + prior_run_functional_run_lost_start + prior_prior_run_functional_run_lost_start + prior_prior_prior_run_functional_run_lost_start)))`
        fi
        if [[ $functional_2_rewind_value == "false" ]] && [[ $functional_3_rewind_value == "true" ]] && [[ $functional_4_rewind_value == "true" ]]
        then
          run_interpolation_length=`echo $(((prior_run_functional_run_lost_end) + (prior_prior_run_functional_run_lost_end) + (1000 - prior_prior_prior_run_functional_run_lost_end) + (current_run_functional_run_lost_start + prior_run_functional_run_lost_start + prior_prior_run_functional_run_lost_start + prior_prior_prior_run_functional_run_lost_start)))`
        fi
        if [[ $functional_2_rewind_value == "true" ]] && [[ $functional_3_rewind_value == "true" ]] && [[ $functional_4_rewind_value == "false" ]]
        then
          run_interpolation_length=`echo $(((1000 - prior_run_functional_run_lost_end) + (prior_prior_run_functional_run_lost_end) + (prior_prior_prior_run_functional_run_lost_end) + (current_run_functional_run_lost_start + prior_run_functional_run_lost_start + prior_prior_run_functional_run_lost_start + prior_prior_prior_run_functional_run_lost_start)))`
        fi
        if [[ $functional_2_rewind_value == "true" ]] && [[ $functional_3_rewind_value == "false" ]] && [[ $functional_4_rewind_value == "true" ]]
        then
          run_interpolation_length=`echo $(((prior_run_functional_run_lost_end) + (1000 - prior_prior_run_functional_run_lost_end) + ( prior_prior_prior_run_functional_run_lost_end) + (current_run_functional_run_lost_start + prior_run_functional_run_lost_start + prior_prior_run_functional_run_lost_start + prior_prior_prior_run_functional_run_lost_start)))`
        fi
        # Turn this into percentage
        # if [[ $run_interpolation_length -gt  999 ]]
        # then
        #   run_interpolation_length=`echo 'scale=3;'$run_interpolation_length'/1000' | bc`
        # else
        #   run_interpolation_length=`echo ."$run_interpolation_length"`
        # fi
        run_interpolation_length=`echo 'scale=3;'$run_interpolation_length'/1000' | bc`
        # NOTE
        # Create a file for time shifting
        # See run 1 above for more information
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz
        rm files/timeseries_files/media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz
        3dcalc \
          -a      media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending".nii.gz[0] \
          -datum  float -expr "-1*(step(abs(a))*"$run_interpolation_length")" \
          -prefix media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
        rm files/timeseries_files/media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
        3dTshift \
          -voxshift media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz \
          -prefix   media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz \
                    media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending".nii.gz
      fi
      # 200320 - Added as some of our movies are long and have more than 4 runs
      if [[ $run -eq  5 ]]
      then
        # Set file ending
        # See whether runs 2, 3, 4, 5, and/or 6 was rewound
        functional_2_rewind_value_actual=functional_2_rewind_"$perp"
        functional_2_rewind_value=`echo "${!functional_2_rewind_value_actual}"`
        functional_3_rewind_value_actual=functional_3_rewind_"$perp"
        functional_3_rewind_value=`echo "${!functional_3_rewind_value_actual}"`
        functional_4_rewind_value_actual=functional_4_rewind_"$perp"
        functional_4_rewind_value=`echo "${!functional_4_rewind_value_actual}"`
        functional_5_rewind_value_actual=functional_5_rewind_"$perp"
        functional_5_rewind_value=`echo "${!functional_5_rewind_value_actual}"`
        functional_6_rewind_value_actual=functional_6_rewind_"$perp"
        functional_6_rewind_value=`echo "${!functional_6_rewind_value_actual}"`
        # See whether to add a slug based on next run
        # if [[ $run -eq  4 ]] && [[ $run -eq $total_num_runs ]] || [[ $functional_5_rewind_value == "true" ]]
        # then
        #   file_ending=""
        # else
        #   file_ending="_slug"
        # fi
        if [[ $run -eq  5 ]] && [[ $run -eq $total_num_runs ]] || [[ $functional_6_rewind_value == "false" ]]
        then
           file_ending="_slug"
        else
           file_ending=""
        fi
        # NOTE
        # Set the prior run and get the backward interpolation amount
        # Same as above but now need to account for the backward shift for runs 2+3+4
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
        # NOTE: This only works for the correctly working rewinding movie script or the case when nothing was rewound.
        if [[ $functional_2_rewind_value == "false" ]] && [[ $functional_3_rewind_value == "false" ]] && [[ $functional_4_rewind_value == "false" ]] && [[ $functional_5_rewind_value == "false" ]]
        then
          run_interpolation_length=`echo $(((1000 - prior_run_functional_run_lost_end) + (1000 - prior_prior_run_functional_run_lost_end) + (1000 - prior_prior_prior_run_functional_run_lost_end) + (1000 - prior_prior_prior_prior_run_functional_run_lost_end) + (current_run_functional_run_lost_start + prior_run_functional_run_lost_start + prior_prior_run_functional_run_lost_start + prior_prior_prior_run_functional_run_lost_start + prior_prior_prior_prior_run_functional_run_lost_start)))`
        fi
        if [[ $functional_2_rewind_value == "true" ]] && [[ $functional_3_rewind_value == "true" ]] && [[ $functional_4_rewind_value == "true" ]] && [[ $functional_5_rewind_value == "true" ]]
        then
          run_interpolation_length=`echo $(((prior_run_functional_run_lost_end) + (prior_prior_run_functional_run_lost_end) + (prior_prior_prior_run_functional_run_lost_end) + (prior_prior_prior_prior_run_functional_run_lost_end) + (current_run_functional_run_lost_start + prior_run_functional_run_lost_start + prior_prior_run_functional_run_lost_start + prior_prior_prior_run_functional_run_lost_start + prior_prior_prior_prior_run_functional_run_lost_start)))`
        fi
        # Turn this into percentage
        # if [[ $run_interpolation_length -gt  999 ]]
        # then
        #   run_interpolation_length=`echo 'scale=3;'$run_interpolation_length'/1000' | bc`
        # else
        #   run_interpolation_length=`echo ."$run_interpolation_length"`
        # fi
        run_interpolation_length=`echo 'scale=3;'$run_interpolation_length'/1000' | bc`
        # NOTE
        # Create a file for time shifting
        # See run 1 above for more information
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz
        rm files/timeseries_files/media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz
        3dcalc \
          -a      media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending".nii.gz[0] \
          -datum  float -expr "-1*(step(abs(a))*"$run_interpolation_length")" \
          -prefix media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
        rm files/timeseries_files/media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
        3dTshift \
          -voxshift media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz \
          -prefix   media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz \
                    media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending".nii.gz
      fi
      if [[ $run -eq  6 ]]
      then
        # Set file ending
        # See whether runs 2, 3, 4, 5, 6, and/or 7 was rewound
        functional_2_rewind_value_actual=functional_2_rewind_"$perp"
        functional_2_rewind_value=`echo "${!functional_2_rewind_value_actual}"`
        functional_3_rewind_value_actual=functional_3_rewind_"$perp"
        functional_3_rewind_value=`echo "${!functional_3_rewind_value_actual}"`
        functional_4_rewind_value_actual=functional_4_rewind_"$perp"
        functional_4_rewind_value=`echo "${!functional_4_rewind_value_actual}"`
        functional_5_rewind_value_actual=functional_5_rewind_"$perp"
        functional_5_rewind_value=`echo "${!functional_5_rewind_value_actual}"`
        functional_6_rewind_value_actual=functional_6_rewind_"$perp"
        functional_6_rewind_value=`echo "${!functional_6_rewind_value_actual}"`
        functional_7_rewind_value_actual=functional_7_rewind_"$perp"
        functional_7_rewind_value=`echo "${!functional_7_rewind_value_actual}"`
        # See whether to add a slug based on next run
        # if [[ $run -eq  4 ]] && [[ $run -eq $total_num_runs ]] || [[ $functional_5_rewind_value == "true" ]]
        # then
        #   file_ending=""
        # else
        #   file_ending="_slug"
        # fi
        if [[ $run -eq  6 ]] && [[ $run -eq $total_num_runs ]] || [[ $functional_7_rewind_value == "false" ]]
        then
           file_ending="_slug"
        else
           file_ending=""
        fi
        # NOTE
        # Set the prior run and get the backward interpolation amount
        # Same as above but now need to account for the backward shift for runs 2+3+4
        # Set prior runs
        prior_run=`echo $(($run - 1))`
        prior_prior_run=`echo $(($run - 2))`
        prior_prior_prior_run=`echo $(($run - 3))`
        prior_prior_prior_prior_run=`echo $(($run - 4))`
        prior_prior_prior_prior_prior_run=`echo $(($run - 5))`
        # Make variable start
        current_run_functional_run_lost_start_actual=functional_"$run"_lost_start_"$perp"
        prior_run_functional_run_lost_start_actual=functional_"$prior_run"_lost_start_"$perp"
        prior_prior_run_functional_run_lost_start_actual=functional_"$prior_prior_run"_lost_start_"$perp"
        prior_prior_prior_run_functional_run_lost_start_actual=functional_"$prior_prior_prior_run"_lost_start_"$perp"
        prior_prior_prior_prior_run_functional_run_lost_start_actual=functional_"$prior_prior_prior_prior_run"_lost_start_"$perp"
        prior_prior_prior_prior_prior_run_functional_run_lost_start_actual=functional_"$prior_prior_prior_prior_prior_run"_lost_start_"$perp"
        # Make variable end
        prior_run_functional_run_lost_end_actual=functional_"$prior_run"_lost_end_"$perp"
        prior_prior_run_functional_run_lost_end_actual=functional_"$prior_prior_run"_lost_end_"$perp"
        prior_prior_prior_run_functional_run_lost_end_actual=functional_"$prior_prior_prior_run"_lost_end_"$perp"
        prior_prior_prior_prior_run_functional_run_lost_end_actual=functional_"$prior_prior_prior_prior_run"_lost_end_"$perp"
        prior_prior_prior_prior_prior_run_functional_run_lost_end_actual=functional_"$prior_prior_prior_prior_prior_run"_lost_end_"$perp"
        # Get value for start
        current_run_functional_run_lost_start=`echo "${!current_run_functional_run_lost_start_actual}"`
        prior_run_functional_run_lost_start=`echo "${!prior_run_functional_run_lost_start_actual}"`
        prior_prior_run_functional_run_lost_start=`echo "${!prior_prior_run_functional_run_lost_start_actual}"`
        prior_prior_prior_run_functional_run_lost_start=`echo "${!prior_prior_prior_run_functional_run_lost_start_actual}"`
        prior_prior_prior_prior_run_functional_run_lost_start=`echo "${!prior_prior_prior_prior_run_functional_run_lost_start_actual}"`
        prior_prior_prior_prior_prior_run_functional_run_lost_start=`echo "${!prior_prior_prior_prior_prior_run_functional_run_lost_start_actual}"`
        # Get value for end
        prior_run_functional_run_lost_end=`echo "${!prior_run_functional_run_lost_end_actual}"`
        prior_prior_run_functional_run_lost_end=`echo "${!prior_prior_run_functional_run_lost_end_actual}"`
        prior_prior_prior_run_functional_run_lost_end=`echo "${!prior_prior_prior_run_functional_run_lost_end_actual}"`
        prior_prior_prior_prior_run_functional_run_lost_end=`echo "${!prior_prior_prior_prior_run_functional_run_lost_end_actual}"`
        prior_prior_prior_prior_prior_run_functional_run_lost_end=`echo "${!prior_prior_prior_prior_prior_run_functional_run_lost_end_actual}"`
        # Get interp amount
        # NOTE: This only works for the correctly working rewinding movie script or the case when nothing was rewound.
        if [[ $functional_2_rewind_value == "false" ]] && [[ $functional_3_rewind_value == "false" ]] && [[ $functional_4_rewind_value == "false" ]] && [[ $functional_5_rewind_value == "false" ]] && [[ $functional_6_rewind_value == "false" ]]
        then
          run_interpolation_length=`echo $(((1000 - prior_run_functional_run_lost_end) + (1000 - prior_prior_run_functional_run_lost_end) + (1000 - prior_prior_prior_run_functional_run_lost_end) + (1000 - prior_prior_prior_prior_run_functional_run_lost_end) + (1000 - prior_prior_prior_prior_prior_run_functional_run_lost_end) + (current_run_functional_run_lost_start + prior_run_functional_run_lost_start + prior_prior_run_functional_run_lost_start + prior_prior_prior_run_functional_run_lost_start + prior_prior_prior_prior_run_functional_run_lost_start + prior_prior_prior_prior_prior_run_functional_run_lost_start)))`
        fi
        if [[ $functional_2_rewind_value == "true" ]] && [[ $functional_3_rewind_value == "true" ]] && [[ $functional_4_rewind_value == "true" ]] && [[ $functional_5_rewind_value == "true" ]] && [[ $functional_6_rewind_value == "true" ]]
        then
          run_interpolation_length=`echo $(((prior_run_functional_run_lost_end) + (prior_prior_run_functional_run_lost_end) + (prior_prior_prior_run_functional_run_lost_end) + (prior_prior_prior_prior_run_functional_run_lost_end) + (prior_prior_prior_prior_prior_run_functional_run_lost_end) + (current_run_functional_run_lost_start + prior_run_functional_run_lost_start + prior_prior_run_functional_run_lost_start + prior_prior_prior_run_functional_run_lost_start + prior_prior_prior_prior_run_functional_run_lost_start + prior_prior_prior_prior_prior_run_functional_run_lost_start)))`
        fi
        # Turn this into percentage
        # if [[ $run_interpolation_length -gt  999 ]]
        # then
        #   run_interpolation_length=`echo 'scale=3;'$run_interpolation_length'/1000' | bc`
        # else
        #   run_interpolation_length=`echo ."$run_interpolation_length"`
        # fi
        run_interpolation_length=`echo 'scale=3;'$run_interpolation_length'/1000' | bc`
        # NOTE
        # Create a file for time shifting
        # See run 1 above for more information
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz
        rm files/timeseries_files/media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz
        3dcalc \
          -a      media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending".nii.gz[0] \
          -datum  float -expr "-1*(step(abs(a))*"$run_interpolation_length")" \
          -prefix media_"$run"_tshift_despike_reg_al_mni_mask_"$filename""$file_ending"_interpolation_amount.nii.gz
        rm media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
        rm files/timeseries_files/media_"$run"_tshift_despike_reg_al_mni_mask_"$filename"_timing.nii.gz
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
