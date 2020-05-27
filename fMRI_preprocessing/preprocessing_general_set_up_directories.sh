#!/bin/bash

################################################################################
# Set up directories, move files/dirs, compress
################################################################################

# NOTE

for subject in $participants
do

  cd "$subject"/

  # Make directory structure for both sessions
  mkdir files/
  mkdir files/text_files/
  mkdir files/anatomical_files/
  mkdir files/timeseries_files/
  
done

################################################################################
# End
################################################################################
