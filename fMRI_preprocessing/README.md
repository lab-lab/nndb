## Scripts to analysis e-fMRI data from full length movie watching @ LAB Lab, UCL

We've collated a series of scripts to process participant data from ecological functional magnetic resonance imaging (e-fMRI) of movies. The scripts are not yet functioning as a pipeline. More information to follow.

Currently the order in which to run the scripts is as follows:
```
1. general_set_variables.sh
2. preprocessing_general_set_up_directories.sh
3. preprocessing_anatomical_uniformity.sh
4. preprocessing_anatomical_skull_strip.sh
5. preprocessing_anatomical_nonlinearly_align_to_mni.sh
6. preprocessing_anatomical_freesurfer.sh
7. preprocessing_functional_slice_timing.sh
8. preprocessing_functional_despike.sh
9. preprocessing_functional_volume_registration.sh
10. preprocessing_functional_align_to_aligned_anatomical.sh
11. preprocessing_functional_align_to_mni_anatomical.sh
12. preprocessing_anatomical_functional_masks.sh
13. preprocessing_functional_mask.sh
14. preprocessing_functional_spatially_smooth.sh
15. preprocessing_functional_detrend_normalize.sh
16. preprocessing_functional_timing.sh
17. preprocessing_functional_concatenate.sh
18. preprocessing_general_move_files.sh
```
The scripts above should be run through `preprocessing_master.sh `. Please check the master script for more info. 
NB: Some subjects needed slight variations of scripts due to re-localising or timing issues. Please see the `subject_fixes.sh` script for info before running preprocessing.
The very final step is the ICA artifact removal, which was performed manually in our study. The noise removal script can be found in `preprocessing_functional_ica_based_artifact_cleansing.sh`. Please make sure to first run ICA with the command below, and add the subject ID and noise components to the script `preprocessing_functional_ica_based_artifact_cleansing.sh` before running it. 

```
### script to run ICA on individual subjects ####

# Insert sub-ID and task
sub="sub-XX"
task="XXX"

num_dim="250" # ICA over 250 dimensions
timeseries_file="$sub"_task-"$task"_bold_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing
cd ./"$sub"/func/

# run melodic for ICA
melodic \
    --dim="$num_dim" --tr=1.0 --nobet --report --Oall \
    --outdir=ica_artifiact_d"$num_dim"_"$timeseries_file" \
    --mask="$sub"_T1w_mask.nii.gz \
    --bgimage="$sub"_T1w_mask.nii.gz \
    --in="$timeseries_file".nii.gz
```
