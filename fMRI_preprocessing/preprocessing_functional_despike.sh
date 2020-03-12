#!/bin/bash

################################################################################
# Despike the functional data
################################################################################

# NOTE
# TODO: Copy in any  participant abnormalities from screen output. For example:
# ove001: ++ FINAL: 56140416 data points, 2013636 edits [3.587%], 136722 big edits [0.244%]

for perp in $perps
do
    cd "$data_dir"/"$perp"/
    total_num_runs=`ls ./media_?.nii.gz  | wc -l`
    for run in `seq 1 $total_num_runs`
    do
      rm media_"$run"_tshift_despike.nii.gz
      3dDespike \
        -NEW \
        -prefix media_"$run"_tshift_despike.nii.gz \
        media_"$run"_tshift.nii.gz
    done
done

################################################################################
# End
################################################################################
