#!/bin/bash

# Written by Sarah Aliko

################################################################################
# Set experiment specific variables
################################################################################

# NOTE
# Variables manually set below
# If any special changes in the scripts were required for any given participant, they will be noted below.
# For now you can only analyze participants from one film at a time

#############################
# Directories
#############################

# Stimuli (to bee made available on openneuro soon)
export media_dir="/stimulus"
export deriv_dir="/derivatives"


################################################################################
# Participant(s)
################################################################################

# Began using movieplayer v1 (on 12-04-2019); This had an error that caused the movie to fastforward
# Began movieplayer v2 (on 25-06-2019); This fixed the v1 error
# See 'timing' below for each participant for specific information

# NOTE: un-hash the subjects you want to export for a movie. For now, only one movie at a time can
# be analysed. Will be updated soon

# 12 Years a Slave (N=6)
# export participants="sub-81 sub-82 sub-83 sub-84 sub-85 sub-86"

# 500 Days of Summer (N=20)
# export participants="sub-1 sub-2 sub-3 sub-4 sub-5 sub-6 sub-7 sub-8 sub-9 sub-10 sub-11 sub-12 sub-13 sub-14 sub-15 sub-16 sub-17 sub-18 sub-19 sub-20"

# Back to the Future (N=6)
#export participants="sub-63 sub-64 sub-65 sub-66 sub-67 sub-68"

# Citizenfour (N=18)
# export participants="sub-21 sub-22 sub-23 sub-24 sub-25 sub-26 sub-27 sub-28 sub-29 sub-30 sub-31 sub-32 sub-33 sub-34 sub-35 sub-36 sub-37 sub-38"

# Little Miss Sunshine (N=6)
# export participants="sub-75 sub-76 sub-77 sub-78 sub-79 sub-80"

# Pulp Fiction (N=6)
# export participants="sub-45 sub-46 sub-47 sub-48 sub-49 sub-50"

# Split (N=6)
# export participants="sub-69 sub-70 sub-71 sub-72 sub-73 sub-74"

# The Prestige (N=6)
# export participants="sub-57 sub-58 sub-59 sub-60 sub-61 sub-62"

# The Shawshank Redemption (N=6)
# export participants="sub-51 sub-52 sub-53 sub-54 sub-55 sub-56"

# The Usual Suspects (N=6)
# export participants="sub-39 sub-40 sub-41 sub-42 sub-43 sub-44"

################################################################################
# Preprocessing variables
################################################################################

#############################
# General parameters
#############################

export anatomical_blur_amount="1"
export functional_blur_amount="6"
export tr="1"
export move_type_for_detrend="motion"

#############################
# Set movies
#############################

# NOTE
# N=10 movies from 10 genres
# 01) 12 Years A Slave
# 02) 500 Days of Summer
# 03) CitizenFour
# 04) Back to the Future
# 05) Little Miss Sunshine
# 06) Pulp Fiction
# 07) Split
# 08) The Prestige
# 09) The Shawshank Redemption
# 10) The Usual Suspects

########### 12 Years A Slave ##########
# Genre = historical
# Length = 7715
# Rounding down from 7716 to 7715
for subject in $participants
do
  if [ $subject == 'sub-81' ] || [ $subject == 'sub-82' ] || [ $subject == 'sub-83' ] || [ $subject == 'sub-84' ] || [ $subject == 'sub-85' ] || [ $subject == 'sub-86' ]
  then
    export movie="12yearsaslave"
    export movie_length="7715"
  fi
done

########## 500 Days of Summer ##########
# Genre = romance
# Length = 5471
# Rounding down from 5471 to 5470
for subject in $participants
do
  if [ $subject == 'sub-1' ] || [ $subject == 'sub-2' ] || [ $subject == 'sub-3' ] || [ $subject == 'sub-4' ] || [ $subject == 'sub-5' ] || [ $subject == 'sub-6' ] || [ $subject == 'sub-7' ] || [ $subject == 'sub-8' ] || [ $subject == 'sub-9' ] || [ $subject == 'sub-10' ] || [ $subject == 'sub-11' ] || [ $subject == 'sub-12' ] || [ $subject == 'sub-13' ] || [ $subject == 'sub-14' ] || [ $subject == 'sub-15' ] || [ $subject == 'sub-16' ] || [ $subject == 'sub-17' ] || [ $subject == 'sub-18' ] || [ $subject == 'sub-19' ] || [ $subject == 'sub-20' ]
  then
    export movie="500daysofsummer"
    export movie_length="5470"
  fi
done

########## Back to the Future ##########
# Genre = sci-fi
# Length = 6675
# Rounding down from 6675 to 6674
for subject in $participants
do
  if [ $subject == 'sub-63' ] || [ $subject == 'sub-64' ] || [ $subject == 'sub-65' ] || [ $subject == 'sub-66' ] || [ $subject == 'sub-67' ] || [ $subject == 'sub-68' ]
  then
    export movie="backtothefuture"
    export movie_length="6674"
  fi
done

########## CitizenFour ##########
# Genre = documentary
# Length = 6805
# Rounding down from 6805 to 6804
for subject in $participants
do
  if [ $subject == 'sub-21' ] || [ $subject == 'sub-22' ] || [ $subject == 'sub-23' ] || [ $subject == 'sub-24' ] || [ $subject == 'sub-25' ] || [ $subject == 'sub-26' ] || [ $subject == 'sub-27' ] || [ $subject == 'sub-28' ] || [ $subject == 'sub-29' ] || [ $subject == 'sub-30' ] || [ $subject == 'sub-31' ] || [ $subject == 'sub-32' ] || [ $subject == 'sub-33' ] || [ $subject == 'sub-34' ] || [ $subject == 'sub-35' ] || [ $subject == 'sub-36' ] || [ $subject == 'sub-37' ] || [ $subject == 'sub-38' ]
  then
    export movie="citizenfour"
    export movie_length="6804"
  fi
done

########## Little Miss Sunshine ##########
# Genre = comedy
# Length = 5901
# Rounding down from 5901 to 5900
for subject in $participants
do
  if [ $subject == 'sub-75' ] || [ $subject == 'sub-76' ] || [ $subject == 'sub-77' ] || [ $subject == 'sub-78' ] || [ $subject == 'sub-79' ] || [ $subject == 'sub-80' ]
  then
    export movie="littlemisssunshine"
    export movie_length="5900"
  fi
done

########## Split ##########
# Genre = horror
# Length = 6740
# Rounding down from 6740 to 6739
for subject in $participants
do
  if [ $subject == 'sub-69' ] || [ $subject == 'sub-70' ] || [ $subject == 'sub-71' ] || [ $subject == 'sub-72' ] || [ $subject == 'sub-73' ] || [ $subject == 'sub-74' ]
  then
    export movie="split"
    export movie_length="6739"
  fi
done

########## The Prestige ##########
# Genre = thriller
# Length = 7516
# Rounding down from 7516 to 7515
for subject in $participants
do
  if [ $subject == 'sub-57' ] || [ $subject == 'sub-58' ] || [ $subject == 'sub-59' ] || [ $subject == 'sub-60' ] || [ $subject == 'sub-61' ] || [ $subject == 'sub-62' ]
  then
    export movie="theprestige"
    export movie_length="7515"
  fi
done

########## The Shawshank Redemption ##########
# Genre = drama
# Length = 8182
# Rounding down from 8182 to 8181
for subject in $participants
do
  if [ $subject == 'sub-51' ] || [ $subject == 'sub-52' ] || [ $subject == 'sub-53' ] || [ $subject == 'sub-54' ] || [ $subject == 'sub-55' ] || [ $subject == 'sub-56' ]
  then
    export movie="theshawshankredemption"
    export movie_length="8181"
  fi
done

########## The Usual Suspects ##########
# Genre = crime
# Length = 6103
# Rounding down from 6103 to 6102
for subject in $participants
do
  if [ $subject == 'sub-39' ] || [ $subject == 'sub-40' ] || [ $subject == 'sub-41' ] || [ $subject == 'sub-42' ] || [ $subject == 'sub-43' ] || [ $subject == 'sub-44' ]
  then
    export movie="theusualsuspects"
    export movie_length="6102"
  fi
done

########## Pulp Fiction ##########
# Genre = action
# Length = 8883
# Rounding down from 8883 to 8882
for subject in $participants
do
  if [ $subject == 'sub-45' ] || [ $subject == 'sub-46' ] || [ $subject == 'sub-47' ] || [ $subject == 'sub-48' ] || [ $subject == 'sub-49' ] || [ $subject == 'sub-50' ]
  then
    export movie="pulpfiction"
    export movie_length="8882"
  fi
done

#############################
# sub-1
#############################

# TaskName
# 500daysofsummer
# Done with v1 of movieplayer, so no rewind times
# This subject originnally had 4 runs, but the last run (04) was only 3TRs long.
# Instead, add 3 TRs to run-03, because many scripts do not work on really short runs.
# Please see subject-specific script for fixes

# Timing info
# NB: functional_4 will be ignored in preprocessing scripts since run-04 does not exist
# period1 689 108
# period2 872 108
# period3 337 109
# period4 424 112
# 1520082623590
# 1520082713929 start
# 1520082891510 pause 1
# 1520083079211 start
# 1520086378975 pause 2
# 1520086527460 start
# 1520088516688 pause 3
# 1520089052466 start
# 1520089055778 ended
export functional_1_lost_start_sub-1="108"
export functional_2_lost_start_sub-1="108"
export functional_3_lost_start_sub-1="109"
export functional_4_lost_start_sub-1="112"
export functional_1_lost_end_sub-1="689"
export functional_2_lost_end_sub-1="872"
export functional_3_lost_end_sub-1="337"
export functional_4_lost_end_sub-1="424"

#############################
# sub-2
#############################

# TaskName
# 500daysofsummer
# Done with v1 of movieplayer, so no rewind times

# Timing info
# period1 775 108
# period2 789 110
# period3 729 109
# 1520529752602
# 1520529814439 start
# 1520531224106 pause 1
# 1520531284685 start
# 1520533143364 pause 2
# 1520533251786 start
# 1520535453406 ended
export functional_1_lost_start_sub-2="108"
export functional_2_lost_start_sub-2="110"
export functional_3_lost_start_sub-2="109"
export functional_1_lost_end_sub-2="775"
export functional_2_lost_end_sub-2="789"
export functional_3_lost_end_sub-2="729"

#############################
# sub-3
#############################

# TaskName
# 500daysofsummer
# Done with v1 of movieplayer, so no rewind times

# Timing info
# period 1 372 108
# period 2 938 109
# 1520677873746
# 1520677910873 start
# 1520681179137 pause 1
# 1520681263140 start
# 1520683464969 ended
export functional_1_lost_start_sub-3="108"
export functional_2_lost_start_sub-3="109"
export functional_1_lost_end_sub-3="372"
export functional_2_lost_end_sub-3="938"

#############################
# sub-4
#############################

# TaskName
# 500daysofsummer
# Done with v1 of movieplayer, so no rewind times

# Timing info
# period 1 996 108
# period 2 322 109
# period 3 914 110
# 1521134741648
# 1521134801721 start
# 1521138069609 pause 1
# 1521138119540 start
# 1521140235753 pause 2
# 1521140338878 start
# 1521140424682 ended
export functional_1_lost_start_sub-4="108"
export functional_2_lost_start_sub-4="109"
export functional_3_lost_start_sub-4="110"
export functional_1_lost_end_sub-4="996"
export functional_2_lost_end_sub-4="322"
export functional_3_lost_end_sub-4="914"

#############################
# sub-5
#############################

# TaskName
# 500daysofsummer
# Done with v1 of movieplayer, so no rewind times

# Timing info
# period 1 192 109
# period 2 1083 110
# 1521290539489
# 1521290596240 start
# 1521293864323 pause 1
# 1521293916719 start
# 1521296118692 ended
export functional_1_lost_start_sub-5="109"
export functional_2_lost_start_sub-5="110"
export functional_1_lost_end_sub-5="192"
export functional_2_lost_end_sub-5="1083"

#############################
# sub-6
#############################

# TaskName
# 500daysofsummer
# Done with v1 of movieplayer, so no rewind times

# Timing info
# period 1 1003 108
# period 2 271 110
# 1521739878532
# 1521739956844 start
# 1521743224739 pause 1
# 1521743410652 start
# 1521745612813 ended
export functional_1_lost_start_sub-6="108"
export functional_2_lost_start_sub-6="110"
export functional_1_lost_end_sub-6="1003"
export functional_2_lost_end_sub-6="271"

#############################
# sub-7
#############################

# TaskName
# 500daysofsummer
# Done with v1 of movieplayer, so no rewind times/end epoch

# Timing info
# 1533142658484
# 1533142711633 start
# 1533145982345 pause 1
# 1533146110873 start
# period 1 832 120
# period 2 119 120
export functional_1_lost_start_sub-7="120"
export functional_2_lost_start_sub-7="120"
export functional_1_lost_end_sub-7="832"
export functional_2_lost_end_sub-7="119"

#############################
# sub-8
#############################

# TaskName
# 500daysofsummer
# Done with v1 of movieplayer, so no rewind times/end epoch

# Timing info
# 1533747162359
# 1533747197311 start
# 1533750465321 pause 1
# 1533750540017 start
# period 1 130 120
# period 2 120 120
export functional_1_lost_start_sub-8="120"
export functional_2_lost_start_sub-8="120"
export functional_1_lost_end_sub-8="130"
export functional_2_lost_end_sub-8="120"

#############################
# sub-9
#############################

# TaskName
# 500daysofsummer
# Done with v1 of movieplayer, so no rewind times/end epoch

# Timing info
# 1534351164943
# 1534351189954 start
# 1534354459094 pause 1
# 1534354568419 start
# period 1 260 120
# period 2 299 120
export functional_1_lost_start_sub-9="120"
export functional_2_lost_start_sub-9="120"
export functional_1_lost_end_sub-9="260"
export functional_2_lost_end_sub-9="299"

#############################
# sub-10
#############################

# TaskName
# 500daysofsummer
# Done with v1 of movieplayer, so no rewind times/end epoch

# Timing info
# period1 145 108
# period2 1086 108
# period3 109 109
# 1543860593187
# 1543860630384 start
# 1543863898421 pause 1
# 1543864108336 start
# 1543864124314 pause 2
# 1543864223274 start
export functional_1_lost_start_sub-10="108"
export functional_2_lost_start_sub-10="108"
export functional_3_lost_start_sub-10="109"
export functional_1_lost_end_sub-10="145"
export functional_2_lost_end_sub-10="1086"
export functional_3_lost_end_sub-10="109"

#############################
# sub-11
#############################

# TaskName
# 500daysofsummer
# Done with v1 of movieplayer, so no rewind times/end epoch
# This subject had to be manually-aligned. Please see the subject-specific script for fixes

# Timing info
# period 1 1026 112
# period 2 873 109
# period 3 109 109
# 1544116797985
# 1544117027078 start
# 1544117221992 pause 1
# 1544117288170 start
# 1544120361934 pause 2
# 1544120450377 start
export functional_1_lost_start_sub-11="112"
export functional_2_lost_start_sub-11="109"
export functional_3_lost_start_sub-11="109"
export functional_1_lost_end_sub-11="1026"
export functional_2_lost_end_sub-11="873"
export functional_3_lost_end_sub-11="109"

#############################
# sub-12
#############################

# TaskName
# 500daysofsummer
# Done with v1 of movieplayer, so no rewind times/end epoch

# Timing info
# period1 603 111
# period2 111 111
# 1545153475043
# 1545153552788 start
# 1545156821280 pause 1
# 1545157031812 start
export functional_1_lost_start_sub-12="111"
export functional_2_lost_start_sub-12="111"
export functional_1_lost_end_sub-12="603"
export functional_2_lost_end_sub-12="111"

#############################
# sub-13
#############################

# TaskName
# 500daysofsummer

# Timing info
# Done with first movieplayer script, so no rewind times/end epoch
# period 1 810 113
# period 2 110 110
# 1547486443590
# 1547486666595 start
# 1547489938292 pause 1
# 1547490004192 start
export functional_1_lost_start_sub-13="113"
export functional_2_lost_start_sub-13="110"
export functional_1_lost_end_sub-13="810"
export functional_2_lost_end_sub-13="110"
export functional_1_rewind_sub-13="false"
export functional_2_rewind_sub-13="false"
export functional_3_rewind_sub-13="false"

#############################
# sub-14
#############################

# TaskName
# 500daysofsummer
# Done with wrong v2 of movieplayer, so it fast-forwards

# Timing info
# period 1 561 120
# mperiod 2 451 116
# 1556727507176
# 1556727676277 start
# 1556730944718 pause 1
# 1556731036222 rewind .549 start
# rewind 1 561+549 = 1110
export functional_1_lost_start_190501DB="120"
export functional_2_lost_start_190501DB="116"
export functional_1_lost_end_190501DB="1110"
export functional_2_lost_end_190501DB="451"
export functional_1_rewind_190501DB="false"
export functional_2_rewind_190501DB="false"
export functional_3_rewind_190501DB="false"

#############################
# sub-15
#############################

# TaskName
# 500daysofsummer
# Done with wrong v2 of movieplayer, so it fast-forwards

# Timing info
# period 1 178 121
# period 2 119 119
# 1561379279235
# 1561379439158 start
# 1561382707215 pause 1
# 1561382765122 rewind .165 start
# rewind 1 178+165 = 343
export functional_1_lost_start_sub-15="121"
export functional_2_lost_start_sub-15="119"
export functional_1_lost_end_sub-15="343"
export functional_2_lost_end_sub-15="119"
export functional_1_rewind_sub-15="false"
export functional_2_rewind_sub-15="false"
export functional_3_rewind_sub-15="false"

#############################
# sub-16
#############################

# TaskName
# 500daysofsummer

# Timing info
# period 1 680 127
# period 2 713 121
# period 3 123 123
# 1561998045787
# 1561998221944 start
# 1561999956497 pause 1
# 1562000242614 rewind -.661 start
# 1562001776206 pause 2
# 1562002548642 rewind -.700 start
# rewind 1 680-661 = 19
# rewind 2 713-700 = 13
export functional_1_lost_start_sub-16="127"
export functional_2_lost_start_sub-16="121"
export functional_3_lost_start_sub-16="123"
export functional_1_lost_end_sub-16="19"
export functional_2_lost_end_sub-16="13"
export functional_3_lost_end_sub-16="123"
export functional_1_rewind_sub-16="false"
export functional_2_rewind_sub-16="true"
export functional_3_rewind_sub-16="true"
export functional_4_rewind_sub-16="false"

#############################
# sub-17
#############################

# TaskName
# 500daysofsummer

# Timing info
# period 1 922 124
# period 2 124 124
# 1565712977059
# 1565713227109 start
# 1565716494907 pause 1
# 1565716676077 rewind -.906 start
# rewind 1 922-906 = 16
export functional_1_lost_start_sub-17="124"
export functional_2_lost_start_sub-17="124"
export functional_1_lost_end_sub-17="16"
export functional_2_lost_end_sub-17="124"
export functional_1_rewind_sub-17="false"
export functional_2_rewind_sub-17="true"
export functional_3_rewind_sub-17="false"

#############################
# sub-18
#############################

# TaskName
# 500daysofsummer

# Timing info
# period 1 296 118
# period 2 128 128
# 1574521828350
# 1574522106741 start
# 1574525374919 pause 1
# 1574525434960 rewind -.286 start
# rewind 1 296-286 = 10
export functional_1_lost_start_sub-18="118"
export functional_2_lost_start_sub-18="128"
export functional_1_lost_end_sub-18="10"
export functional_2_lost_end_sub-18="128"
export functional_1_rewind_sub-18="false"
export functional_2_rewind_sub-18="true"
export functional_3_rewind_sub-18="false"

#############################
# sub-19
#############################

# TaskName
# 500daysofsummer

# Timing info
# period 1 972 129
# period 2 130 130
# 1580319766579
# 1580319828531 start
# 1580323096374 pause 1
# 1580323161040 rewind -.951 start
# rewind 1 972-951 = 21
export functional_1_lost_start_sub-19="129"
export functional_2_lost_start_sub-19="130"
export functional_1_lost_end_sub-19="21"
export functional_2_lost_end_sub-19="130"
export functional_1_rewind_sub-19="false"
export functional_2_rewind_sub-19="true"
export functional_3_rewind_sub-19="false"

#############################
# sub-20
#############################

# TaskName
# 500daysofsummer

# Timing info
# period 1 384 126
# period 2 131 131
# 1580474360495
# 1580474528172 start
# 1580477796430 pause 1
# 1580477863021 rewind -.366 start
# rewind 1 384-366 = 18
export functional_1_lost_start_sub-20="126"
export functional_2_lost_start_sub-20="131"
export functional_1_lost_end_sub-20="18"
export functional_2_lost_end_sub-20="131"
export functional_1_rewind_sub-20="false"
export functional_2_rewind_sub-20="true"
export functional_3_rewind_sub-20="false"

#############################
# sub-21
#############################

# TaskName
# citizenfour
# Done with v1 of movieplayer, so no rewind times

# Timing info
# period 1 546 108
# period 2 670 110
# period 3 897 109
# period 4 108 108
# 1537376956004
# 1537377045229 start
# 1537378007667 pause 1
# 1537378097332 start
# 1537380252892 pause 2
# 1537380313134 start
# 1537381087922 pause 3
# 1537381224678 start
# 1537381224678 ended
export functional_1_lost_start_sub-21="108"
export functional_2_lost_start_sub-21="110"
export functional_3_lost_start_sub-21="109"
export functional_4_lost_start_sub-21="108"
export functional_1_lost_end_sub-21="546"
export functional_2_lost_end_sub-21="670"
export functional_3_lost_end_sub-21="897"
export functional_4_lost_end_sub-21="108"

#############################
# sub-22
#############################

# TaskName
# citizenfour
# Done with v1 of movieplayer, so no rewind times

# Timing info
# period 1 110 109
# period 2 853 109
# period 3 842 109
# 1539794129603
# 1539794196106 start
# 1539797311107 pause 1
# 1539797386658 start
# 1539799912402 pause 2
# 1539799963558 start
# 1539801127291 ended
export functional_1_lost_start_sub-22="109"
export functional_2_lost_start_sub-22="109"
export functional_3_lost_start_sub-22="109"
export functional_1_lost_end_sub-22="110"
export functional_2_lost_end_sub-22="853"
export functional_3_lost_end_sub-22="842"

#############################
# sub-23
############################

# TaskName
# citizenfour
# Done with v1 of movieplayer, so no rewind times

# Timing info
# period 1 468 125
# period 2 584 109
# period 3 500 110
# period 4 455 109
# 1540311590063
# 1540312328736 start
# 1540315444079 pause 1
# 1540315552846 start
# 1540315870321 pause 2
# 1540315933039 start
# 1540318575429 pause 3
# 1540318630517 start
# 1540319359863 ended
export functional_1_lost_start_sub-23="125"
export functional_2_lost_start_sub-23="109"
export functional_3_lost_start_sub-23="110"
export functional_4_lost_start_sub-23="109"
export functional_1_lost_end_sub-23="468"
export functional_2_lost_end_sub-23="584"
export functional_3_lost_end_sub-23="500"
export functional_4_lost_end_sub-23="455"

#############################
# sub-24
#############################

# TaskName
# citizenfour
# Done with v1 of movieplayer, so no rewind times
# This subject had to be manually-aligned. Please see the subject-specific script for fixes

# Timing info
# period 1 1034 108
# period 2 871 109
# period 3 356 108
# period 4 734 110
# 1541611241251
# 1541611323129 start
# 1541612013055 pause 1
# 1541612169100 start
# 1541614594862 pause 2
# 1541614669987 start
# 1541617242235 pause 3
# 1541617319299 start
# 1541618435923 ended
export functional_1_lost_start_sub-24="108"
export functional_2_lost_start_sub-24="109"
export functional_3_lost_start_sub-24="108"
export functional_4_lost_start_sub-24="110"
export functional_1_lost_end_sub-24="1034"
export functional_2_lost_end_sub-24="871"
export functional_3_lost_end_sub-24="356"
export functional_4_lost_end_sub-24="734"

#############################
# sub-25
############################

# TaskName
# citizenfour
# Done with v1 of movieplayer, so no rewind times

# Timing info
# period 1 508 114
# period 2 315 107
# period 3 1092 109
# 1542823142243
# 1542823489263 start
# 1542826605657 pause 1
# 1542826773216 start
# 1542829345424 pause 2
# 1542829416429 start
# 1542830532412 ended
export functional_1_lost_start_sub-25="114"
export functional_2_lost_start_sub-25="107"
export functional_3_lost_start_sub-25="109"
export functional_1_lost_end_sub-25="508"
export functional_2_lost_end_sub-25="315"
export functional_3_lost_end_sub-25="1092"

#############################
# sub-26
#############################

# TaskName
# citizenfour
# Done with v1 of movieplayer, so no rewind times

# Timing info
# period 1 427 110
# period 2 396 109
# period 3 1102 110
# 1544465993760
# 1544466125025 start
# 1544469241342 pause 1
# 1544469304232 start
# 1544471837519 pause 2
# 1544471888469 start
# 1544473043461 ended
export functional_1_lost_start_sub-26="110"
export functional_2_lost_start_sub-26="109"
export functional_3_lost_start_sub-26="110"
export functional_1_lost_end_sub-26="427"
export functional_2_lost_end_sub-26="396"
export functional_3_lost_end_sub-26="1102"

#############################
# sub-27
#############################

# TaskName
# citizenfour
# Done with v1 of movieplayer, so no rewind times

# Timing info
# period 1 834 113
# period 2 856 111
# period 3 346 110
# 1545239594605
# 1545239719217 start
# 1545242834938 pause 1
# 1545242896658 start
# 1545245431403 pause 2
# 1545245625108 start
# 1545246779344 ended
export functional_1_lost_start_sub-27="113"
export functional_2_lost_start_sub-27="111"
export functional_3_lost_start_sub-27="110"
export functional_1_lost_end_sub-27="834"
export functional_2_lost_end_sub-27="856"
export functional_3_lost_end_sub-27="346"

#############################
# sub-28
#############################

# TaskName
# citizenfour
# Done with v1 of movieplayer, so no rewind times

# Timing info
# period 1 518 108
# period 2 794 109
# period 3 527 110
# period 4 119 108
# period 5 1080 110
# 1547573446667
# 1547573616913 start
# 1547574123323 pause 1
# 1547574221182 start
# 1547576107867 pause 2
# 1547576833293 start
# 1547577558710 pause 3
# 1547577639414 start
# 1547580213425 pause 4
# 1547580267941 start
# 1547581379911 ended
export functional_1_lost_start_sub-28="108"
export functional_2_lost_start_sub-28="109"
export functional_3_lost_start_sub-28="110"
export functional_4_lost_start_sub-28="108"
export functional_5_lost_start_sub-28="110"
export functional_1_lost_end_sub-28="518"
export functional_2_lost_end_sub-28="794"
export functional_3_lost_end_sub-28="527"
export functional_4_lost_end_sub-28="119"
export functional_5_lost_end_sub-28="1080"

#############################
# sub-29
#############################

# TaskName
# citizenfour
# Done with v1 of movieplayer, so no rewind times

# Timing info
# period 1 875 112
# period 2 363 109
# period 3 697 109
# 1547658694944
# 1547658832400 start
# 1547661948163 pause 1
# 1547662017206 start
# 1547664593460 pause 2
# 1547664658517 start
# 1547665771105 ended
export functional_1_lost_start_sub-29="112"
export functional_2_lost_start_sub-29="109"
export functional_3_lost_start_sub-29="109"
export functional_1_lost_end_sub-29="875"
export functional_2_lost_end_sub-29="363"
export functional_3_lost_end_sub-29="697"

#############################
# sub-30
#############################

# TaskName
# citizenfour
# Done with v1 of movieplayer, so no rewind times
# Final run is 3 TRs short. Add these TRs to run-03
# Please see subject-specific script for fixes

# Timing info
# period 1 870 110
# period 2 405 110
# period 3 559 111
# 1550596731908
# 1550596944609 start
# 1550600061369 pause 1
# 1550600139411 start
# 1550602673706 pause 2
# 1550602744615 start
# 1550603896063 pause 3
export functional_1_lost_start_sub-30="110"
export functional_2_lost_start_sub-30="110"
export functional_3_lost_start_sub-30="111"
export functional_1_lost_end_sub-30="870"
export functional_2_lost_end_sub-30="405"
export functional_3_lost_end_sub-30="559"

#############################
# sub-31
#############################

# TaskName
# citizenfour
# Done with wrong v2 of movieplayer, so it fast-forwards

# Timing info
# period 1 230 122
# period 2 761 120
# period 3 561 123
# 1556555622947
# 1556555652826 start
# 1556558768934 pause 1
# 1556558828699 rewind .216 start
# 1556561362340 pause 2
# 1556561423911 rewind -.749 start
# 1556562577349 ended
# rewind 1 230+216 = 446
# rewind 2 761-749 = 12
export functional_1_lost_start_sub-31="122"
export functional_2_lost_start_sub-31="120"
export functional_3_lost_start_sub-31="123"
export functional_1_lost_end_sub-31="446"
export functional_2_lost_end_sub-31="12"
export functional_3_lost_end_sub-31="561"
export functional_1_rewind_sub-31="false"
export functional_2_rewind_sub-31="false"
export functional_3_rewind_sub-31="true"
export functional_4_rewind_sub-31="false"

#############################
# sub-32
#############################

# TaskName
# citizenfour
# Done with wrong v2 of movieplayer, so it fast-forwards

# Timing info
# period 1 696 117
# period 2 153 116
# period 3 580 119
# 1557851078563
# 1557851215252 start
# 1557854332831 pause 1
# 1557854539566 rewind .687 start
# 1557857069603 pause 2
# 1557857127860 rewind .145 start
# 1557858282321 ended
# rewind 1 696+687 = 1383
# rewind 2 153+145 = 298
export functional_1_lost_start_sub-32="117"
export functional_2_lost_start_sub-32="116"
export functional_3_lost_start_sub-32="119"
export functional_1_lost_end_sub-32="1383"
export functional_2_lost_end_sub-32="298"
export functional_3_lost_end_sub-32="580"
export functional_1_rewind_sub-32="false"
export functional_2_rewind_sub-32="false"
export functional_3_rewind_sub-32="false"
export functional_4_rewind_sub-32="false"

#############################
# sub-33
#############################

# TaskName
# citizenfour
# Done with wrong v2 of movieplayer, so it fast-forwards

# Timing info
# period 1 167 117
# period 2 348 117
# period 3 1091 117
# 1558370835747
# 1558370906120 start
# 1558374024170 pause 1
# 1558374182044 rewind .158 start
# 1558376751275 pause 2
# 1558376800226 rewind .339 start
# 1558377915200 ended
# rewind 1 167+158 = 325
# rewind 2 348+339 = 687
export functional_1_lost_start_sub-33="117"
export functional_2_lost_start_sub-33="117"
export functional_3_lost_start_sub-33="117"
export functional_1_lost_end_sub-33="325"
export functional_2_lost_end_sub-33="687"
export functional_3_lost_end_sub-33="1091"
export functional_1_rewind_sub-33="false"
export functional_2_rewind_sub-33="false"
export functional_3_rewind_sub-33="false"
export functional_4_rewind_sub-33="false"

#############################
# sub-34
#############################

# TaskName
# citizenfour
# Done with wrong v2 of movieplayer, so it fast-forwards

# Timing info
# period 1 600 122
# period 2 256 123
# period 3 529 121
# 1558974773808
# 1558974841808 start
# 1558977602286 pause 1
# 1558978415355 rewind -.586 start
# 1558981342488 pause 2
# 1558981416342 rewind .241 start
# 1558982531750 ended
# rewind 1 600-586 = 14
# rewind 2 256+241 = 497
export functional_1_lost_start_sub-34="122"
export functional_2_lost_start_sub-34="123"
export functional_3_lost_start_sub-34="121"
export functional_1_lost_end_sub-34="14"
export functional_2_lost_end_sub-34="497"
export functional_3_lost_end_sub-34="529"
export functional_1_rewind_sub-34="false"
export functional_2_rewind_sub-34="true" 
export functional_3_rewind_sub-34="false"
export functional_4_rewind_sub-34="false"

#############################
# sub-35
#############################

# TaskName
# citizenFour
# Done with wrong v2 of movieplayer, so it fast-forwards

# Timing info
# period 1 172 121
# period 2 824 117
# period 3 544 118
# 1560876392054
# 1560876544027 start
# 1560879660078 pause 1
# 1560879849784 rewind .159 start
# 1560882391491 pause 2
# 1560882451146 rewind -.815 start
# 1560883596572 ended
# rewind 1 172+159 = 331
# rewind 2 824-815 = 9
export functional_1_lost_start_sub-35="121"
export functional_2_lost_start_sub-35="117"
export functional_3_lost_start_sub-35="118"
export functional_1_lost_end_sub-35="331"
export functional_2_lost_end_sub-35="9"
export functional_3_lost_end_sub-35="544"
export functional_1_rewind_sub-35="false"
export functional_2_rewind_sub-35="false"
export functional_3_rewind_sub-35="true"
export functional_4_rewind_sub-35="false"

#############################
# sub-36
#############################

# TaskName
# citizenfour

# Timing info
# period 1 614 130
# period 2 402 126
# period 3 1056 125
# 1567528130580
# 1567528264953 start
# 1567531380437 pause 1
# 1567531465886 rewind -.592 start
# 1567534037162 pause 2
# 1567534091303 rewind -.384 start
# 1567535208234 ended
# rewind 1 614-592 = 22
# rewind 2 402-384 = 18
export functional_1_lost_start_sub-36="130"
export functional_2_lost_start_sub-36="126"
export functional_3_lost_start_sub-36="125"
export functional_1_lost_end_sub-36="22"
export functional_2_lost_end_sub-36="18"
export functional_3_lost_end_sub-36="1056"
export functional_1_rewind_sub-36="false"
export functional_2_rewind_sub-36="true"
export functional_3_rewind_sub-36="true"
export functional_4_rewind_sub-36="false"

#############################
# sub-37
#############################

# TaskName
# citizenfour

# Timing info
# period 1 419 121
# period 2 574 117
# period 3 602 125
# 1567841087473
# 1567841243041 start
# 1567843899339 pause 1
# 1567844358913 rewind -.406 start
# 1567847389370 pause 2
# 1567847446336 rewind -.565 start
# 1567848563813 ended
# rewind 1 419-406 = 13
# rewind 2 574-565 = 9
export functional_1_lost_start_sub-37="121"
export functional_2_lost_start_sub-37="117"
export functional_3_lost_start_sub-37="125"
export functional_1_lost_end_sub-37="13"
export functional_2_lost_end_sub-37="9"
export functional_3_lost_end_sub-37="602"
export functional_1_rewind_sub-37="false"
export functional_2_rewind_sub-37="true"
export functional_3_rewind_sub-37="true"
export functional_4_rewind_sub-37="false"

#############################
# sub-38
#############################

# TaskName
# citizenfour

# Timing info
# period 1 690 130
# period 2 537 125
# period 3 374 124
# period 4 554 124
# 1579713745577
# 1579713911271 start
# 1579715907831 pause 1
# 1579716073282 rewind -.668 start
# 1579717192694 pause 2
# 1579717283799 rewind -.520 start
# 1579719818049 pause 3
# 1579719887600 rewind -.358 start
# 1579721041030 ended
# rewind 1 690-668 = 22
# rewind 2 537-520 = 17
# rewind 3 374-358 = 16
export functional_1_lost_start_sub-38="130"
export functional_2_lost_start_sub-38="125"
export functional_3_lost_start_sub-38="124"
export functional_4_lost_start_sub-38="124"
export functional_1_lost_end_sub-38="22"
export functional_2_lost_end_sub-38="17"
export functional_3_lost_end_sub-38="16"
export functional_4_lost_end_sub-38="554"
export functional_1_rewind_sub-38="false"
export functional_2_rewind_sub-38="true"
export functional_3_rewind_sub-38="true"
export functional_4_rewind_sub-38="true"
export functional_5_rewind_sub-38="false"

#############################
# sub-39
#############################

# TaskName
# theusualsuspects
# Done with v1 of movieplayer, so no rewind times

# Timing info
# period 1 385 113
# period 2 170 111
# 1552410551954
# 1552410709708 start
# 1552414247980 pause 1
# 1552414414618 start
# 1552416978677 ended
export functional_1_lost_start_sub-39="113"
export functional_2_lost_start_sub-39="111"
export functional_1_lost_end_sub-39="385"
export functional_2_lost_end_sub-39="170"

#############################
# sub-40
#############################

# TaskName
# theusualsuspects
# Done with wrong v2 of movieplayer, so it fast-forwards
# The file is about 6 TRs short
# All preprocessing gets to the end, so just add the TRs before the concatenation step
# Please see subject-specific script for fixes

# Timing info
# period 1 126 118
# period 2 612 116
# 1556642994987
# 1556643061297 start
# 1556646343305 pause 1
# 1556646410754 rewind .116 start
# 1556649225250 ended
# rewind 1 126+116 = 242
export functional_1_lost_start_sub-40="118"
export functional_2_lost_start_sub-40="116"
export functional_1_lost_end_sub-40="242"
export functional_2_lost_end_sub-40="612"
export functional_1_rewind_sub-40="false" 
export functional_2_rewind_sub-40="false" 
export functional_3_rewind_sub-40="false"

#############################
# sub-41
#############################

# TaskName
# theusualsuspects

# Timing info
# period 1 906 117
# period 1 934 119
# 1559664569955
# 1559664742658 start
# 1559668024447 pause 1
# 1559668081215 rewind -.897 start
# 1559670902030 ended
# rewind 1 906-897 = 9
export functional_1_lost_start_sub-41="117"
export functional_2_lost_start_sub-41="119"
export functional_1_lost_end_sub-41="9"
export functional_2_lost_end_sub-41="934"
export functional_1_rewind_sub-41="false" 
export functional_2_rewind_sub-41="true" 
export functional_3_rewind_sub-41="false"

#############################
# sub-42
#############################

# NOTE
# the_usual_suspects

# Timing info
# Done with first movieplayer script so no rewind times
# period 1 908 116
# period 2 643 107
# 1562777627919
# 1562777779715 start
# 1562781323507 pause 1
# 1562781894854 start
# 1562784453390 ended
export functional_1_lost_start_sub-42="116"
export functional_2_lost_start_sub-42="107"
export functional_1_lost_end_sub-42="908"
export functional_2_lost_end_sub-42="643"
export functional_1_rewind_sub-42="false"
export functional_2_rewind_sub-42="false"
export functional_3_rewind_sub-42="false"

#############################
# sub-43
#############################

# TaskName
# theusualsuspects

# Timing info
# period 1 225 131
# period 2 1040 126
# 1576324133981
# 1576324457459 start
# 1576327740553 pause 1
# 1576327907569 rewind -.202 start
# 1576330726483 ended
# rewind 1 225-202 = 23
export functional_1_lost_start_sub-43="131"
export functional_2_lost_start_sub-43="126"
export functional_1_lost_end_sub-43="23"
export functional_2_lost_end_sub-43="1040"
export functional_1_rewind_sub-43="false"
export functional_2_rewind_sub-43="true"
export functional_3_rewind_sub-43="false"

#############################
# sub-44
#############################

# TaskName
# theusualsuspects

# Timing info
# period 1 181 129
# period 2 999 126
# 1581935166686
# 1581935267784 start
# 1581938565836 pause 1
# 1581938635412 rewind -.160 start
# 1581941439285 ended
# rewind 1 181-160=21
export functional_1_lost_start_sub-44="129"
export functional_2_lost_start_sub-44="126"
export functional_1_lost_end_sub-44="21"
export functional_2_lost_end_sub-44="999"
export functional_1_rewind_sub-44="false"
export functional_2_rewind_sub-44="true"
export functional_3_rewind_sub-44="false"

#############################
# sub-45
#############################

# TaskName
# pulpfiction

# Timing info
# period 1 816 130
# period 2 388 123
# period 3 923 114
# period 4 531 123
# period 5 467 125
# 1573299370084
# 1573299494445 start
# 1573302364131 pause 1
# 1573302478611 rewind -.794 start
# 1573304361876 pause 2
# 1573305191770 rewind -.373 start
# 1573306853579 pause 3
# 1573306906774 rewind -.917 start
# 1573309239182 pause 4
# 1573309328303 rewind -.516 start
# 1573309463645 ended
# rewind 1 816-794 = 22
# rewind 2 388-373 = 15
# rewind 3 923-917 = 6
# rewind 4 531-516 = 15
export functional_1_lost_start_sub-45="130"
export functional_2_lost_start_sub-45="123"
export functional_3_lost_start_sub-45="114"
export functional_4_lost_start_sub-45="123"
export functional_5_lost_start_sub-45="125"
export functional_1_lost_end_sub-45="22"
export functional_2_lost_end_sub-45="15"
export functional_3_lost_end_sub-45="6"
export functional_4_lost_end_sub-45="15"
export functional_5_lost_end_sub-45="467"
export functional_1_rewind_sub-45="false"
export functional_2_rewind_sub-45="true"
export functional_3_rewind_sub-45="true"
export functional_4_rewind_sub-45="true"
export functional_5_rewind_sub-45="true"
export functional_6_rewind_sub-45="false"

#############################
# sub-46
#############################

# TaskName
# pulpfiction

# Timing info
# period 1 610 124
# period 2 335 129
# period 3 707 129
# period 4 97 128
# period 5 840 128
# period 6 442 123
# 1573313743640
# 1573313828279 start
# 1573316697765 pause 1
# 1573316754284 rewind -.594 start
# 1573318637490 pause 2
# 1573318693809 rewind -.314 start
# 1573320363387 pause 3
# 1573320414125 rewind -.686 start
# 1573321596094 pause 4
# 1573321686623 rewind -1.077 start
# 1573321718334 pause 5
# 1573322318291 rewind -.819 start
# 1573323564610 ended
# rewind 1 610-594 = 16
# rewind 2 335-314 = 21
# rewind 3 707-686 = 21
# rewind 4 97-1077 = 980
# rewind 5 840-819 = 21
export functional_1_lost_start_sub-46="124"
export functional_2_lost_start_sub-46="129"
export functional_3_lost_start_sub-46="129"
export functional_4_lost_start_sub-46="128"
export functional_5_lost_start_sub-46="128"
export functional_6_lost_start_sub-46="123"
export functional_1_lost_end_sub-46="16"
export functional_2_lost_end_sub-46="21"
export functional_3_lost_end_sub-46="21"
export functional_4_lost_end_sub-46="980"
export functional_5_lost_end_sub-46="21"
export functional_6_lost_end_sub-46="442"
export functional_1_rewind_sub-46="false"
export functional_2_rewind_sub-46="true"
export functional_3_rewind_sub-46="true"
export functional_4_rewind_sub-46="true"
export functional_5_rewind_sub-46="true"
export functional_6_rewind_sub-46="true"
export functional_7_rewind_sub-46="false"

#############################
# sub-47
#############################

# TaskName
# pulp_fiction

# Timing info
# period 1 710 124
# period 2 495 122
# period 3 804 127
# period 4 569 128
# period 5 291 127
# period 6 639 129
# 1576170754418
# 1576170892944 start
# 1576170929530 pause 1
# 1576170981302 rewind -.694 start
# 1576173813675 pause 2
# 1576173874692 rewind -.481 start
# 1576173880369 pause 3
# 1576173943661 rewind -.785 start
# 1576175820102 pause 4
# 1576175874030 rewind -.549 start
# 1576177536194 pause 5
# 1576177585538 rewind -.272 start
# 1576180053048 ended
# rewind 1 710-694 = 16
# rewind 2 495-481 = 14
# rewind 3 804-785 = 19
# rewind 4 569-549 = 20
# rewind 5 291-272 = 19
export functional_1_lost_start_sub-47="124"
export functional_2_lost_start_sub-47="122"
export functional_3_lost_start_sub-47="127"
export functional_4_lost_start_sub-47="128"
export functional_5_lost_start_sub-47="127"
export functional_6_lost_start_sub-47="129"
export functional_1_lost_end_sub-47="16"
export functional_2_lost_end_sub-47="14"
export functional_3_lost_end_sub-47="19"
export functional_4_lost_end_sub-47="20"
export functional_5_lost_end_sub-47="19"
export functional_6_lost_end_sub-47="639"
export functional_1_rewind_sub-47="false"
export functional_2_rewind_sub-47="true"
export functional_3_rewind_sub-47="true"
export functional_4_rewind_sub-47="true"
export functional_5_rewind_sub-47="true"
export functional_6_rewind_sub-47="true"
export functional_7_rewind_sub-47="false"

#############################
# sub-48
#############################

# TaskName
# pulpfiction

# Timing info
# period 1 927 135
# period 2 279 119
# period 3 752 125
# period 4 802 116
# 1580145428268
# 1580145741597 start
# 1580148611389 pause 1
# 1580149437364 rewind -.900 start
# 1580151320524 pause 2
# 1580151478175 rewind -.268 start
# 1580153147802 pause 3
# 1580153698174 rewind -.735 start
# 1580156157860 ended
# rewind 1 927-900 = 27
# rewind 2 279-268 = 11
# rewind 3 752-735 = 17
export functional_1_lost_start_sub-48="135"
export functional_2_lost_start_sub-48="119"
export functional_3_lost_start_sub-48="125"
export functional_4_lost_start_sub-48="116"
export functional_1_lost_end_sub-48="27"
export functional_2_lost_end_sub-48="11"
export functional_3_lost_end_sub-48="17"
export functional_4_lost_end_sub-48="802"
export functional_1_rewind_sub-48="false"
export functional_2_rewind_sub-48="true"
export functional_3_rewind_sub-48="true"
export functional_4_rewind_sub-48="true"
export functional_5_rewind_sub-48="false"

#############################
# sub-49
#############################

# TaskName
# pulpfiction

# Timing info
# period 1 1019 129
# period 2 489 129
# period 3 807 128
# period 4 318 127
# 1580736833741
# 1580736973696 start
# 1580739843586 pause 1
# 1580739901167 rewind -.998 start
# 1580741784527 pause 2
# 1580741834462 rewind -.468 start
# 1580743504141 pause 3
# 1580743556623 rewind -.787 start
# 1580746015814 ended
# rewind 1 1019-998 = 21
# rewind 2 489-468 = 21
# rewind 3 807-787 = 20
export functional_1_lost_start_sub-49="129"
export functional_2_lost_start_sub-49="129"
export functional_3_lost_start_sub-49="128"
export functional_4_lost_start_sub-49="127"
export functional_1_lost_end_sub-49="21"
export functional_2_lost_end_sub-49="21"
export functional_3_lost_end_sub-49="20"
export functional_4_lost_end_sub-49="318"
export functional_1_rewind_sub-49="false"
export functional_2_rewind_sub-49="true"
export functional_3_rewind_sub-49="true"
export functional_4_rewind_sub-49="true"
export functional_5_rewind_sub-49="false"

#############################
# sub-50
#############################

# TaskName
# pulpfiction

# Timing info
# period 1 219 124
# period 2 678 127
# period 3 531 129
# period 4 278 124
# 1580752314801
# 1580752429500 start
# 1580755299595 pause 1
# 1580755353174 rewind -.203 start
# 1580757234725 pause 2
# 1580757281062 rewind -.659 start
# 1580758951464 pause 3
# 1580759001093 rewind -.510 start
# 1580761460247 ended
# rewind 1 219-203 = 16
# rewind 2 678-659 = 19
# rewind 3 531-510 = 21
export functional_1_lost_start_sub-50="124"
export functional_2_lost_start_sub-50="127"
export functional_3_lost_start_sub-50="129"
export functional_4_lost_start_sub-50="124"
export functional_1_lost_end_sub-50="16"
export functional_2_lost_end_sub-50="19"
export functional_3_lost_end_sub-50="21"
export functional_4_lost_end_sub-50="278"
export functional_1_rewind_sub-50="false"
export functional_2_rewind_sub-50="true"
export functional_3_rewind_sub-50="true"
export functional_4_rewind_sub-50="true"
export functional_5_rewind_sub-50="false"

#############################
# sub-51
#############################

# TaskName
# theshawshankredemption
# This subject had a short first scan that contained 4 files (TR=700ms), meaning 2800ms at the
# beginning need to be replaced
# Please check file with subject-specific scripts for how this can be fixed

# Timing info 
# TR700: period 1 304 123
# period 2 371 126
# period 3 1018 125
# period 4 948 126
# period 5 350 128
# TR700: 1562171331099 pause 1
# TR700: 1562171365262 rewind -.289 start
# 1562174122507 pause 2
# 1562174178176 rewind -.353 start
# 1562176028069 pause 3
# 1562176081374 rewind -1.001 start
# 1562177635196 pause 4
# 1562177685886 rewind -.930 start
# 1562179705108 ended
# TR700: rewind 1 304-289 = 15
# rewind 2 371-353 = 18
# rewind 3 1018-1001 = 17
# rewind 4 948-930 = 18
# Original would have been:
# export functional_1_lost_start_sub-51="126"
# However, we will add the delay from the start and end of TR700
# ((126+123)+(304-289)) = 264 = cumulative delay time lost at start for periods 1&2 + rewind delay
# And we will add three TRs to the start of the run to account for the four dropped 700 ms TRs (i.e., 2800 ms).
# This is 200 ms too long, so need to also account for this by 'rewinding' the ts:
# ((126+123)+(304-289))+(3000-2800) = 464
# So the original 126 gets replaces with 464
export functional_1_lost_start_sub-51="464"
export functional_2_lost_start_sub-51="125"
export functional_3_lost_start_sub-51="126"
export functional_4_lost_start_sub-51="128"
export functional_1_lost_end_sub-51="18"
export functional_2_lost_end_sub-51="17"
export functional_3_lost_end_sub-51="18"
export functional_4_lost_end_sub-51="350"
export functional_1_rewind_sub-51="false"
export functional_2_rewind_sub-51="true"
export functional_3_rewind_sub-51="true"
export functional_4_rewind_sub-51="true"
export functional_5_rewind_sub-51="false"

#############################
# sub-52
#############################

# TaskName
# theshawshankredemption

# Timing info
# period 1 61 130
# period 2 524 126
# period 3 471 125
# period 4 771 126
# 1572629561694
# 1572629678079 start
# 1572632436010 pause 1
# 1572632504351 rewind -1.039 start
# 1572634361749 pause 2
# 1572634415848 rewind -.506 start
# 1572635887194 pause 3
# 1572635961577 rewind -.454 start
# 1572638056222 ended
# rewind 1 61-1039 = 978
# rewind 2 524-506 = 18
# rewind 3 471-454  17
export functional_1_lost_start_sub-52="130"
export functional_2_lost_start_sub-52="126"
export functional_3_lost_start_sub-52="125"
export functional_3_lost_start_sub-52="126"
export functional_1_lost_end_sub-52="978"
export functional_2_lost_end_sub-52="18"
export functional_3_lost_end_sub-52="17"
export functional_4_lost_end_sub-52="771"
export functional_1_rewind_sub-52="false"
export functional_2_rewind_sub-52="true"
export functional_3_rewind_sub-52="true"
export functional_4_rewind_sub-52="true"
export functional_5_rewind_sub-52="false"

#############################
# sub-53
#############################

# TaskName
# theshawshankredemption

# Timing info
# period 1 728 129
# period 2 1032 126
# period 3 653 120
# period 4 803 128
# period 5 841 120
# 1575114779710
# 1575114878218 start
# 1575114917817 pause 1
# 1575114988139 rewind -.707 start
# 1575117707045 pause 2
# 1575117824037 rewind -1.014 start
# 1575119680570 pause 3
# 1575119737387 rewind -.641 start
# 1575121285062 pause 4
# 1575121340001 rewind -.783 start
# 1575123247499 pause 5
# 1575123297497 rewind -.606 start
# 1575123408218 ended
# rewind 1 728-707 = 21
# rewind 2 1032-1014 = 18
# rewind 3 653-641 = 12
# rewind 4 803-783 = 20
# rewind 5 625-606 = 19
export functional_1_lost_start_sub-53="129"
export functional_2_lost_start_sub-53="126"
export functional_3_lost_start_sub-53="120"
export functional_4_lost_start_sub-53="128"
export functional_5_lost_start_sub-53="127"
export functional_6_lost_start_sub-53="120"
export functional_1_lost_end_sub-53="21"
export functional_2_lost_end_sub-53="18"
export functional_3_lost_end_sub-53="12"
export functional_4_lost_end_sub-53="20"
export functional_5_lost_end_sub-53="19"
export functional_6_lost_end_sub-53="841"
export functional_1_rewind_sub-53="false"
export functional_2_rewind_sub-53="true"
export functional_3_rewind_sub-53="true"
export functional_4_rewind_sub-53="true"
export functional_5_rewind_sub-53="true"
export functional_6_rewind_sub-53="true"
export functional_7_rewind_sub-53="false"

#############################
# sub-54
#############################

# TaskName
# theshawshankredemption

# Timing info
# period 1 666 125
# period 2 1069 125
# period 3 197 127
# period 4 411 127
# 1579346105320
# 1579346247646 start
# 1579349005187 pause 1
# 1579349089656 rewind -.649 start
# 1579350960600 pause 2
# 1579351017244 rewind -1.052 start
# 1579352552314 pause 3
# 1579352604853 rewind -.178 start
# 1579354622137 ended
# rewind 1 666-649 = 17
# rewind 2 1069-1052 = 17
# rewind 3 197-178 = 19
export functional_1_lost_start_sub-54="125"
export functional_2_lost_start_sub-54="125"
export functional_3_lost_start_sub-54="127"
export functional_4_lost_start_sub-54="127"
export functional_1_lost_end_sub-54="17"
export functional_2_lost_end_sub-54="17"
export functional_3_lost_end_sub-54="19"
export functional_4_lost_end_sub-54="411"
export functional_1_rewind_sub-54="false"
export functional_2_rewind_sub-54="true"
export functional_3_rewind_sub-54="true"
export functional_4_rewind_sub-54="true"
export functional_5_rewind_sub-54="false"

#############################
# sub-55
#############################

# TaskName
# theshawshankredemption

# Timing info
# period 1 269 122
# period 2 820 126
# period 3 1095 124
# period 4 376 130
# 1580491031349
# 1580491214543 start
# 1580493971690 pause 1
# 1580494040440 rewind -.255 start
# 1580495575134 pause 2
# 1580495712693 rewind -.802 start
# 1580497581664 pause 3
# 1580497710294 rewind -1.079 start
# 1580499729540 ended
# rewind 1 269-255 = 14
# rewind 2 820-802 = 18
# rewind 3 1095-1079 = 16
export functional_1_lost_start_sub-55="122"
export functional_2_lost_start_sub-55="126"
export functional_3_lost_start_sub-55="124"
export functional_3_lost_start_sub-55="130"
export functional_1_lost_end_sub-55="14"
export functional_2_lost_end_sub-55="18"
export functional_3_lost_end_sub-55="16"
export functional_4_lost_end_sub-55="376"
export functional_1_rewind_sub-55="false"
export functional_2_rewind_sub-55="true"
export functional_3_rewind_sub-55="true"
export functional_4_rewind_sub-55="true"
export functional_5_rewind_sub-55="false"

#############################
# sub-56
#############################

# TaskName
# theshawshankredemption

# Timing info
# period 1 633 126
# period 2 707 130
# period 3 732 126
# period 4 861 126
# 1580573814762
# 1580573931445 start
# 1580576688952 pause 1
# 1580576744182 rewind -.615 start
# 1580578594759 pause 2
# 1580578639295 rewind -.685 start
# 1580580191901 pause 3
# 1580580245264 rewind -.714 start
# 1580582264999 ended
# rewind 1 633-615 = 18
# rewind 2 707-685 = 22
# rewind 3 732-714 = 18
export functional_1_lost_start_sub-56="126"
export functional_2_lost_start_sub-56="130"
export functional_3_lost_start_sub-56="126"
export functional_4_lost_start_sub-56="126"
export functional_1_lost_end_sub-56="18"
export functional_2_lost_end_sub-56="22"
export functional_3_lost_end_sub-56="18"
export functional_4_lost_end_sub-56="861"
export functional_1_rewind_sub-56="false"
export functional_2_rewind_sub-56="true"
export functional_3_rewind_sub-56="true"
export functional_4_rewind_sub-56="true"
export functional_5_rewind_sub-56="false"

#############################
# sub-57
#############################

# TaskName
# theprestige
# Done with v1 of movieplayer, so no rewind times/end epoch

# Timing info
# period 1 516 110
# period 2 270 112
# period 3 111 111
# 1537978619708
# 1537978808086 start
# 1537981385492 pause 1
# 1537981439308 start
# 1537983781466 pause 2
# 1537983838259 start
export functional_1_lost_start_sub-57="110"
export functional_2_lost_start_sub-57="112"
export functional_3_lost_start_sub-57="111"
export functional_1_lost_end_sub-57="516"
export functional_2_lost_end_sub-57="270"
export functional_3_lost_end_sub-57="111"

#############################
# sub-58
#############################

# TaskName
# theprestige
# Done with wrong v2 of movieplayer, so it fast-forwards

# Timing info
# period 1 775 122
# period 2 357 119
# period 3 163 125
# 1558456231481
# 1558456389239 start
# 1558458929892 pause 1
# 1558459011938 rewind .775 start
# 1558461387176 pause 2
# 1558461450975 rewind -.346 start
# 1558464048013 ended
# rewind 1 775+775 = 1550
# rewind 2 357-346 = 11
export functional_1_lost_start_sub-58="122"
export functional_2_lost_start_sub-58="119"
export functional_3_lost_start_sub-58="125"
export functional_1_lost_end_sub-58="1550"
export functional_2_lost_end_sub-58="11"
export functional_3_lost_end_sub-58="163"
export functional_1_rewind_sub-58="false"
export functional_2_rewind_sub-58="false"
export functional_3_rewind_sub-58="true"
export functional_4_rewind_sub-58="false"

#############################
# sub-59
#############################

# TaskName
# theprestige

# Timing info
# period 1 424 124
# period 2 241 123
# period 3 1039 123
# period 4 1101 123
# 1560961357526
# 1560961505888 start
# 1560964075188 pause 1
# 1560964168889 rewind -.408 start
# 1560965258007 pause 2
# 1560965318405 rewind -.226 start
# 1560966598321 pause 3
# 1560966661793 rewind -1.024 start
# 1560969237771 ended
# rewind 1 424-408 = 16
# rewind 2 241-226 = 15
# rewind 3 1039-1024 = 15
export functional_1_lost_start_sub-59="124"
export functional_2_lost_start_sub-59="123"
export functional_3_lost_start_sub-59="123"
export functional_4_lost_start_sub-59="123"
export functional_1_lost_end_sub-59="16"
export functional_2_lost_end_sub-59="15"
export functional_3_lost_end_sub-59="15"
export functional_4_lost_end_sub-59="1101"
export functional_1_rewind_sub-59="false"
export functional_2_rewind_sub-59="true" 
export functional_3_rewind_sub-59="true"
export functional_4_rewind_sub-59="true"
export functional_5_rewind_sub-59="false"

#############################
# sub-60
#############################

# TaskName
# theprestige

# Timing info
# period 1 741 125
# period 2 736 126
# period 3 775 128
# 1562257999507
# 1562258145514 start
# 1562260702130 pause 1
# 1562260780401 rewind -.724 start
# 1562263144011 pause 2
# 1562263240495 rewind -.718 start
# 1562265835142 ended
# rewind 1 741-724 = 17
# rewind 2 736-718 = 18
export functional_1_lost_start_sub-60="125"
export functional_2_lost_start_sub-60="126"
export functional_3_lost_start_sub-60="128"
export functional_1_lost_end_sub-60="17"
export functional_2_lost_end_sub-60="18"
export functional_3_lost_end_sub-60="775"
export functional_1_rewind_sub-60="false" 
export functional_2_rewind_sub-60="true"  
export functional_3_rewind_sub-60="true"  
export functional_4_rewind_sub-60="false" 

#############################
# sub-61
#############################

# TaskName
# theprestige

# Timing info
# period 1 779 132
# period 2 639 126
# period 3 391 126
# 1572693246416
# 1572693423234 start
# 1572695999881 pause 1
# 1572696056630 rewind -.755 start
# 1572698393143 pause 2
# 1572698453454 rewind -.621 start
# 1572701054719 ended
# rewind 1 779-755 = 24
# rewind 2 639-621 = 18
export functional_1_lost_start_sub-61="132"
export functional_2_lost_start_sub-61="126"
export functional_3_lost_start_sub-61="126"
export functional_1_lost_end_sub-61="24"
export functional_2_lost_end_sub-61="18"
export functional_3_lost_end_sub-61="391"
export functional_1_rewind_sub-61="false"
export functional_2_rewind_sub-61="true"
export functional_3_rewind_sub-61="true"
export functional_4_rewind_sub-61="false"

#############################
# sub-62
#############################

# TaskName
# theprestige

# Timing info
# period 1 234 130
# period 2 489 130
# 1574184756650
# 1574184869051 start
# 1574187441155 pause 1
# 1574187572025 rewind -.212 start
# 1574190448309 pause 2
# 1574190606364 rewind -.392 start
# 1574192671723 ended
# rewind 1 234-212 =
# rewind 2 489-392 =
export functional_1_lost_start_sub-62="130"
export functional_2_lost_start_sub-62="130"
export functional_1_lost_end_sub-62=""
export functional_2_lost_end_sub-62=""
export functional_1_rewind_sub-62="false"
export functional_2_rewind_sub-62="true"
export functional_3_rewind_sub-62="false"

#############################
# sub-63
#############################

# TaskName
# backtothefuture

# Timing info
# period 1 687 131
# period 2 229 129
# period 3 771 125
# period 4 611 131
# 1573493222821
# 1573493499917 start
# 1573494959473 pause 1
# 1573495026450 rewind -.664 start
# 1573495723550 pause 2
# 1573495795753 rewind -.208 start
# 1573498885399 pause 3
# 1573498931225 rewind -.754 start
# 1573500358705 ended
# rewind 1 687-664 = 23
# rewind 2 229-208 = 21
# rewind 3 771-754 = 17
export functional_1_lost_start_sub-63="131"
export functional_2_lost_start_sub-63="129"
export functional_3_lost_start_sub-63="125"
export functional_4_lost_start_sub-63="131"
export functional_1_lost_end_sub-63="23"
export functional_2_lost_end_sub-63="21"
export functional_3_lost_end_sub-63="17"
export functional_4_lost_end_sub-63="611"
export functional_1_rewind_sub-63="false"
export functional_2_rewind_sub-63="true"
export functional_3_rewind_sub-63="true"
export functional_4_rewind_sub-63="true"
export functional_5_rewind_sub-63="false"

#############################
# sub-64
#############################

# TaskName
# backtothefuture

# Timing info
# period 1 707 129
# period 2 416 126
# 1574701976077
# 1574702193477 start
# 1574705722055 pause 1
# 1574705775903 rewind -.686 start
# 1574708922193 ended
# rewind 1 707-686 =21
export functional_1_lost_start_sub-64="129"
export functional_2_lost_start_sub-64="126"
export functional_1_lost_end_sub-64="21"
export functional_2_lost_end_sub-64="416"
export functional_1_rewind_sub-64="false"
export functional_2_rewind_sub-64="true"
export functional_3_rewind_sub-64="false"

#############################
# sub-65
#############################

# TaskName
# backtothefuture

# Timing info
# period 1 205 125
# period 2 627 126
# period 3 831 126
# period 4 291 128
# 1576084851256
# 1576085015874 start
# 1576085321954 pause 1
# 1576085383565 rewind -.188 start
# 1576088643066 pause 2
# 1576088706077 rewind -.609 start
# 1576091681782 pause 3
# 1576091733709 rewind -.813 start
# 1576091865872 ended
# rewind 1 205-188 = 17
# rewind 2 627-609 = 18
# rewind 3 831-813 = 18
export functional_1_lost_start_sub-65="125"
export functional_2_lost_start_sub-65="126"
export functional_3_lost_start_sub-65="126"
export functional_4_lost_start_sub-65="128"
export functional_1_lost_end_sub-65="17"
export functional_2_lost_end_sub-65="18"
export functional_3_lost_end_sub-65="18"
export functional_4_lost_end_sub-65="291"
export functional_1_rewind_sub-65="false"
export functional_2_rewind_sub-65="true"
export functional_3_rewind_sub-65="true"
export functional_4_rewind_sub-65="true"
export functional_5_rewind_sub-65="false"

#############################
# sub-66
#############################

# TaskName
# backtothefuture

# Timing info
# period 1 707 122
# period 2 626 125
# 1576516913988
# 1576517167065 start
# 1576520733650 pause 1
# 1576520923293 rewind -.693 start
# 1576524031794 ended
# rewind 1 707-693 = 14
export functional_1_lost_start_sub-66="122"
export functional_2_lost_start_sub-66="125"
export functional_1_lost_end_sub-66="14"
export functional_2_lost_end_sub-66="626"
export functional_1_rewind_sub-66="false"
export functional_2_rewind_sub-66="true"
export functional_3_rewind_sub-66="false"

#############################
# sub-67
#############################

# TaskName
# backtothefuture

# Timing info
# period 1 858 131
# period 2 505 127
# 1579022214962
# 1579022399492 start
# 1579025966219 pause 1
# 1579026025644 rewind -.835 start
# 1579029134022 ended
# rewind 1 858-835 = 23
export functional_1_lost_start_sub-67="131"
export functional_2_lost_start_sub-67="127"
export functional_1_lost_end_sub-67="23"
export functional_2_lost_end_sub-67="505"
export functional_1_rewind_sub-67="false"
export functional_2_rewind_sub-67="true"
export functional_3_rewind_sub-67="false"

#############################
# sub-68
#############################

# TaskName
# backtothefuture

# Timing info
# period 1 130 122
# period 2 467 125
# period 3 464 128
# period 4 833 127
# period 5 177 125
# 1580836833529
# 1580836988544 start
# 1580838160552 pause 1
# 1580838276892 rewind -.116 start
# 1580841389234 pause 2
# 1580841476766 rewind -.450 start
# 1580842439102 pause 3
# 1580842499105 rewind -.444 start
# 1580842713811 pause 4
# 1580842773518 rewind -.814 start
# 1580843985570 ended
# rewind 1 130-116 = 14
# rewind 2 467-450 = 17
# rewind 3 464-444 = 20
# rewind 4 833-814 = 19
export functional_1_lost_start_sub-68="122"
export functional_2_lost_start_sub-68="125"
export functional_3_lost_start_sub-68="128"
export functional_4_lost_start_sub-68="127"
export functional_5_lost_start_sub-68="125"
export functional_1_lost_end_sub-68="14"
export functional_2_lost_end_sub-68="17"
export functional_3_lost_end_sub-68="20"
export functional_4_lost_end_sub-68="19"
export functional_5_lost_end_sub-68="177"
export functional_1_rewind_sub-68="false"
export functional_2_rewind_sub-68="true"
export functional_3_rewind_sub-68="true"
export functional_4_rewind_sub-68="true"
export functional_5_rewind_sub-68="true"
export functional_6_rewind_sub-68="false"

#############################
# sub-69
#############################

# TaskName
# split
# Done with v1 of movieplayer, so no rewind times/end epoch

# Timing info
# period 1 467 110
# period 2 361 109
# period 3 109 109
# 1537626429778
# 1537626641442 start
# 1537629465799 pause 1
# 1537629748705 start
# 1537631398957 pause 2
# 1537631469655 start
export functional_1_lost_start_sub-69="110"
export functional_2_lost_start_sub-69="109"
export functional_3_lost_start_sub-69="109"
export functional_1_lost_end_sub-69="467"
export functional_2_lost_end_sub-69="361"
export functional_3_lost_end_sub-69="109"

#############################
# sub-70
#############################

# TaskName
# split
# Done with wrong v2 of movieplayer, so it fast-forwards

# Timing info
# period 1 412 122
# period 2 1037 124
# period 3 483 124
# 1561047167879
# 1561047320345 start
# 1561050142635 pause 1
# 1561050266242 rewind .398 start
# 1561051913155 pause 2
# 1561051965898 rewind -1.021 start
# 1561054234257 ended
# rewind 1 412+398 = 810
# rewind 2 1037-1021 = 16
export functional_1_lost_start_sub-70="122"
export functional_2_lost_start_sub-70="124"
export functional_3_lost_start_sub-70="124"
export functional_1_lost_end_sub-70="810"
export functional_2_lost_end_sub-70="16"
export functional_3_lost_end_sub-70="483"
export functional_1_rewind_sub-70="false" 
export functional_2_rewind_sub-70="false"
export functional_3_rewind_sub-70="true"
export functional_4_rewind_sub-70="false"

#############################
# sub-71
#############################

# TaskName
# split
# Done with wrong v2 of movieplayer, so it fast-forwards
# The file is about 3 TRs short
# All preprocessing gets to the end, so just add the TRs before the concatenation step
# Please see subject-specific script for fixes

# Timing info
# period 1 569 122
# period 2 927 121
# period 3 842 123
# period 4 790 121
# 1561392850525
# 1561393012036 start
# 1561394387483 pause 1
# 1561394436256 rewind .555 start
# 1561395885062 pause 2
# 1561395939223 rewind -.914 start
# 1561397583942 pause 3
# 1561397645554 rewind .827 start
# 1561399912223 ended
# rewind 1 569+555 = 1124
# rewind 2 927-914 = 13
# rewind 3 842+827 = 1669
export functional_1_lost_start_sub-71="122"
export functional_2_lost_start_sub-71="121"
export functional_3_lost_start_sub-71="123"
export functional_4_lost_start_sub-71="121"
export functional_1_lost_end_sub-71="1124"
export functional_2_lost_end_sub-71="13"
export functional_3_lost_end_sub-71="1669"
export functional_4_lost_end_sub-71="790"
export functional_1_rewind_sub-71="false" 
export functional_2_rewind_sub-71="false"
export functional_3_rewind_sub-71="true"
export functional_4_rewind_sub-71="false"
export functional_5_rewind_sub-71="false"

#############################
# sub-72
#############################

# TaskName
# split

# Timing info
# period 1 306 117
# period 2 984 119
# period 3 353 118
# 1561977226331
# 1561977334281 start
# 1561980159470 pause 1
# 1561980228411 rewind -.297 start
# 1561981975276 pause 2
# 1561982025217 rewind -.973 start
# 1561984191452 ended
# rewind 1 306-297 = 9
# rewind 2 984-973 = 11
export functional_1_lost_start_sub-72="117"
export functional_2_lost_start_sub-72="119"
export functional_3_lost_start_sub-72="118"
export functional_1_lost_end_sub-72="9"
export functional_2_lost_end_sub-72="11"
export functional_3_lost_end_sub-72="353"
export functional_1_rewind_sub-72="false" 
export functional_2_rewind_sub-72="true" 
export functional_3_rewind_sub-72="true" 
export functional_4_rewind_sub-72="false"

#############################
# sub-73
#############################

# TaskName
# split
# During the scan there was a technical issue with Arduino wires, which detected 8 extra pauses
# that did not happen while the scanner was still going. Time fixes are shown below
# but please use the subject-specific scripts for accurate fixing of the timings

# Timing info
# period 1 863 121
# period 2 518 118
# period 3 895 119
# 1562067904578
# 1562068057347 start
# 1562070412212 pause 1 (2355 sec elapsed: TR 2355)
# 1562070420338 rewind -.973 start (8 sec elapsed : TR 2363) # remove TRs 2355:2363
# 1562070624891 pause 2 (205 sec elapsed: TR 2568)
# 1562070633018 rewind -.661 start (8 sec elapsed : TR 2576) # remove TRs 2568:2576 
# 1562070898089 pause 3 (265 sec elapsed : TR 2841) END RUN 1
# 1562071045465 rewind -.179 start 
# 1562071131199 pause 4 (86 sec elapsed: TR 86)
# 1562071139330 rewind -.842 start (8 sec elapsed: TR 94) # remove TRs 86:94
# 1562071826373 pause 5 (687 sec elapsed: TR 781)
# 1562071834554 rewind -.151 start (9 sec elapsed: TR 790) # remove TRs 781:790
# 1562072467262 pause 6 (632 sec elapsed: TR 1422)
# 1562072475444 rewind -.816 start (8 sec elapsed: TR 1430) # remove TRs 1422:1430
# 1562072712865 pause 7 (238 sec elapsed: TR 1668) END RUN 2
# 1562072838677 rewind -.529 start 
# 1562074279642 pause 8 (1441 sec elapsed: TR 1441)
# 1562074287769 rewind -1.073 start (8 sec elapsed: TR 1449) # remove TRs 1441:1449
# 1562075116453 ended (828 sec elapsed: TR 2277) END RUN 3
# rewind 1 863-179 = 684
# rewind 2 518-529 = 11
export functional_1_lost_start_sub-73="121"
export functional_2_lost_start_sub-73="118"
export functional_3_lost_start_sub-73="119"
export functional_1_lost_end_sub-73="684"
export functional_2_lost_end_sub-73="11"
export functional_3_lost_end_sub-73="895"
export functional_1_rewind_sub-73="false"
export functional_2_rewind_sub-73="true"
export functional_3_rewind_sub-73="true"
export functional_4_rewind_sub-73="false"
export functional_1_lost_start_sub-73="117"
export functional_2_lost_start_sub-73="119"
export functional_3_lost_start_sub-73="118"
export functional_1_lost_end_sub-73="9"
export functional_2_lost_end_sub-73="11"
export functional_3_lost_end_sub-73="802"
export functional_1_rewind_sub-73="false"
export functional_2_rewind_sub-73="true"
export functional_3_rewind_sub-73="true"
export functional_4_rewind_sub-73="false"

#############################
# sub-74
#############################

# TaskName
# split

# Timing info
# period 1 144 122
# period 2 540 126
# 1576776813687
# 1576777087021 start
# 1576779917932 pause 1
# 1576780093391 rewind -1.019 start
# 1576781723413 pause 2
# 1576781807367 rewind -.130 start
# 1576784084781 ended
# rewind 1 144-1019 =
# rewind 2 540-130 =
export functional_1_lost_start_sub-74="122"
export functional_2_lost_start_sub-74="126"
export functional_1_lost_end_sub-74=""
export functional_2_lost_end_sub-74=""
export functional_1_rewind_sub-74="false"
export functional_2_rewind_sub-74="true"
export functional_3_rewind_sub-74="false"

#############################
# sub-75
#############################

# TaskName
# littlemisssunshine
# Done with wrong v2 of movieplayer, so it fast-forwards

# Timing info
# period 1 226 116
# period 2 772 116
# period 3 925 120
# 1557335718668
# 1557335843622 start
# 1557337687732 pause 1
# 1557337954350 rewind .218 start
# 1557339024006 pause 2
# 1557339095846 rewind -.764 start
# 1557342081651 ended
# rewind 1 226+218 = 444
# rewind 2 772-764 = 8
export functional_1_lost_start_sub-75="116"
export functional_2_lost_start_sub-75="116"
export functional_3_lost_start_sub-75="120"
export functional_1_lost_end_sub-75="444"
export functional_2_lost_end_sub-75="8"
export functional_3_lost_end_sub-75="925"
export functional_1_rewind_sub-75="false"
export functional_2_rewind_sub-75="false"
export functional_3_rewind_sub-75="true"
export functional_4_rewind_sub-75="false"

#############################
# sub-76
#############################

# TaskName
# littlemisssunshine
# Done with wrong v2 of movieplayer, so it fast-forwards

# Timing info 
# period 1 1095 120
# period 2 248 119
# period 3 656 116
# period 4 708 117
# 1558542566588
# 1558542714667 start
# 1558543082642 pause 1
# 1558543141048 rewind -1.083 start
# 1558545565177 pause 2
# 1558545638187 rewind .237 start
# 1558547406727 pause 3
# 1558547510826 rewind .648 start
# 1558548848417 ended
# rewind 1 1095-1083 = 12
# rewind 2 248+237 = 485
# rewind 3 656+648 = 1304
export functional_1_lost_start_sub-76="120"
export functional_2_lost_start_sub-76="119"
export functional_3_lost_start_sub-76="116"
export functional_4_lost_start_sub-76="117"
export functional_1_lost_end_sub-76="12"
export functional_2_lost_end_sub-76="485"
export functional_3_lost_end_sub-76="1304"
export functional_4_lost_end_sub-76="708"
export functional_1_rewind_sub-76="false"
export functional_2_rewind_sub-76="true"
export functional_3_rewind_sub-76="false" 
export functional_4_rewind_sub-76="false" 
export functional_5_rewind_sub-76="false"

#############################
# sub-77
#############################

# TaskName
# littlemisssunshine

# Timing info
# period 1 891 115
# period 2 672 117
# 1559232843703
# 1559233007598 start
# 1559235740374 pause 1
# 1559235971926 rewind -.884 start
# 1559239139481 ended
# rewind 1 891-884 = 7
export functional_1_lost_start_sub-77="115"
export functional_2_lost_start_sub-77="117"
export functional_1_lost_end_sub-77="7"
export functional_2_lost_end_sub-77="672"
export functional_1_rewind_sub-77="false"
export functional_2_rewind_sub-77="true"
export functional_3_rewind_sub-77="false"

#############################
# sub-78
#############################

# TaskName
# littlemisssunshine

# Timing info
# period 1 535 123
# period 2 585 123
# 1561479816694
# 1561479851068 start
# 1561482767480 pause 1
# 1561482820331 rewind -.520 start
# 1561485803793 ended
# rewind 1 535-520 = 15
export functional_1_lost_start_sub-78="123"
export functional_2_lost_start_sub-78="123"
export functional_1_lost_end_sub-78="15"
export functional_2_lost_end_sub-78="585"
export functional_1_rewind_sub-78="false" 
export functional_2_rewind_sub-78="true" 
export functional_3_rewind_sub-78="false"

#############################
# sub-79
#############################

# TaskName
# littlemisssunshine

# Timing info
# period 1 934 120
# period 2 514 119
# 1561566862166
# 1561567023586 start
# 1561569938400 pause 1
# 1561569991033 rewind -.922 start
# 1561572976428 ended
# rewind 1 934-922 = 12
export functional_1_lost_start_sub-79="120"
export functional_2_lost_start_sub-79="119"
export functional_1_lost_end_sub-79="12"
export functional_2_lost_end_sub-79="514"
export functional_1_rewind_sub-79="false" 
export functional_2_rewind_sub-79="true" 
export functional_3_rewind_sub-79="false"

############################
# sub-80
#############################

# TaskName
# littlemisssunshinne

# Timing info
# period 1 873 118
# period 2 656 118
# period 3 996 119
# 1562078896223
# 1562079053561 start
# 1562079691316 pause 1
# 1562079743649 rewind -.863 start
# 1562082021187 pause 2
# 1562082074421 rewind -.646 start
# 1562085059298 ended
# rewind 1 873-863 = 10
# rewind 2 656-646 = 10
export functional_1_lost_start_sub-80="118"
export functional_2_lost_start_sub-80="118"
export functional_3_lost_start_sub-80="119"
export functional_1_lost_end_sub-80="10"
export functional_2_lost_end_sub-80="10"
export functional_3_lost_end_sub-80="996"
export functional_1_rewind_sub-80="false" 
export functional_2_rewind_sub-80="true"  
export functional_3_rewind_sub-80="true"  
export functional_4_rewind_sub-80="false" 

#############################
# sub-81
#############################

# TaskName
# 12yearsaslave

# Timing info
# period 1 889 132
# period 2 530 120
# period 3 127 127
# 1574508731943
# 1574508968494 start
# 1574512382251 pause 1
# 1574513084663 rewind -.865 start
# 1574515399073 pause 2
# 1574515493623 rewind -.518 start
# rewind 1 889-865 = 24
# rewind 2 530-518 = 12
export functional_1_lost_start_sub-81="132"
export functional_2_lost_start_sub-81="120"
export functional_3_lost_start_sub-81="127"
export functional_1_lost_end_sub-81="24"
export functional_2_lost_end_sub-81="12"
export functional_3_lost_end_sub-81="127"
export functional_1_rewind_sub-81="false"
export functional_2_rewind_sub-81="true"
export functional_3_rewind_sub-81="true"
export functional_4_rewind_sub-81="false"

#############################
# sub-82
#############################

# TaskName
# 12yearsaslave

# Timing info
# period 1 1031 119
# period 2 432 128
# period 3 124 124
# 1575307960285
# 1575308248143 start
# 1575311662055 pause 1
# 1575311727954 rewind -1.020 start
# 1575314042258 pause 2
# 1575314102966 rewind -.412 start
# rewind 1 1031-1020 = 11
# rewind 2 432-412 = 20
export functional_1_lost_start_sub-82="119"
export functional_2_lost_start_sub-82="128"
export functional_3_lost_start_sub-82="124"
export functional_1_lost_end_sub-82="11"
export functional_2_lost_end_sub-82="20"
export functional_3_lost_end_sub-82="124"
export functional_1_rewind_sub-82="false"
export functional_2_rewind_sub-82="true"
export functional_3_rewind_sub-82="true"
export functional_4_rewind_sub-82="false"

#############################
# sub-83
#############################

# TaskName
# 12yearsaslave

# Timing info
# period 1 740 125
# period 2 433 125
# period 3 125 125
# 1575730121653
# 1575730333026 start
# 1575733746641 pause 1
# 1575733820477 rewind -.723 start
# 1575736134785 pause 2
# 1575736202932 rewind -.416 start
# rewind 1 740-723 = 17
# rewind 2 433-416 = 17
export functional_1_lost_start_sub-83="125"
export functional_2_lost_start_sub-83="125"
export functional_3_lost_start_sub-83="125"
export functional_1_lost_end_sub-83="17"
export functional_2_lost_end_sub-83="17"
export functional_2_lost_end_sub-83="125"
export functional_1_rewind_sub-83="false"
export functional_2_rewind_sub-83="true"
export functional_3_rewind_sub-83="true"
export functional_4_rewind_sub-83="false"

#############################
# sub-84
#############################

# TaskName
# 12yearsaslave

# Timing info
# period 1 963 128
# period 2 467 127
# period 3 128 128
# 1578741621673
# 1578741728914 start
# 1578745142749 pause 1
# 1578745217950 rewind -.943 start
# 1578747532290 pause 2
# 1578747625741 rewind -.448 start
# rewind 1 963-943 = 20
# rewind 2 467-448 = 19
export functional_1_lost_start_sub-84="128"
export functional_2_lost_start_sub-84="127"
export functional_3_lost_start_sub-84="128"
export functional_1_lost_end_sub-84="20"
export functional_2_lost_end_sub-84="19"
export functional_3_lost_end_sub-84="128"
export functional_1_rewind_sub-84="false"
export functional_2_rewind_sub-84="true"
export functional_3_rewind_sub-84="true"
export functional_4_rewind_sub-84="false"

#############################
# sub-85
#############################

# TaskName
# 12yearsaslave

# Timing info
# period 1 807 127
# period 2 410 128
# period 3 127 127
# 1579361817348
# 1579361953069 start
# 1579365366749 pause 1
# 1579365452401 rewind -.788 start
# 1579367766683 pause 2
# 1579367838393 rewind -.390 start
# rewind 1 807-788 = 19
# rewind 2 410-390 = 20
export functional_1_lost_start_sub-85="127"
export functional_2_lost_start_sub-85="128"
export functional_3_lost_start_sub-85="127"
export functional_1_lost_end_sub-85="19"
export functional_2_lost_end_sub-85="20"
export functional_3_lost_end_sub-85="127"
export functional_1_rewind_sub-85="false"
export functional_2_rewind_sub-85="true"
export functional_3_rewind_sub-85="true"
export functional_4_rewind_sub-85="false"

#############################
# sub-86
#############################

# TaskName
# 12yearsaslave

# Timing info
# period 1 839 129
# period 2 369 124
# period 3 122 122
# 1583169873213
# 1583170017448 start
# 1583173431158 pause 1
# 1583173491837 rewind -.818 start
# 1583175806082 pause 2
# 1583175872529 rewind -.353 start
# rewind 1 839-818 = 21
# rewind 2 369-353 =
export functional_1_lost_start_sub-86="129"
export functional_2_lost_start_sub-86="124"
export functional_3_lost_start_sub-86="122"
export functional_1_lost_end_sub-86="21"
export functional_2_lost_end_sub-86="16"
export functional_3_lost_end_sub-86="122"
export functional_1_rewind_sub-86="false"
export functional_2_rewind_sub-86="true"
export functional_3_rewind_sub-86="true"
export functional_4_rewind_sub-86="false"

################################################################################
# End
################################################################################
