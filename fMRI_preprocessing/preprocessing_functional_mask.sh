#!/bin/bash

################################################################################
# Mask functional data
################################################################################

# NOTE:
# This step is more cosmetic and was added b/c the next step really 'spreads' the activity out and makes everything look funky
# Also, the file sizes are about 4X smaller
# Tried autoboxing but doesn't save much space (~10MB)
# for run in 1
# do
#     3dAutobox \
#         -prefix "$data_dir"/"$perp"/media_"$run"_tshift_despike_reg_al_mni_mask_box.nii.gz \
#         -input  "$data_dir"/"$perp"/media_"$run"_tshift_despike_reg_al_mni_mask.nii.gz
# done

for perp in $perps
do
    cd "$data_dir"/"$perp"/
    total_num_runs=`ls ./media_?.nii.gz  | wc -l`
    for run in `seq 1 $total_num_runs`
    do
      rm media_"$run"_tshift_despike_reg_al_mni_mask.nii.gz
      3dcalc \
          -a media_"$run"_tshift_despike_reg_al_mni.nii.gz \
          -b anatomical_mask.nii.gz \
          -expr 'a*b' \
          -prefix media_"$run"_tshift_despike_reg_al_mni_mask.nii.gz
    done
done

################################################################################
# End
################################################################################
