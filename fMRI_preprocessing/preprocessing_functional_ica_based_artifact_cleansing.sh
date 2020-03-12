#!/bin/bash

################################################################################
# Artifact and outlier rejection tests
################################################################################

# NOTE
# Useful to have open:
# Hand classification of fMRI ICA noise components
# https://www.sciencedirect.com/science/article/pii/S1053811916307583
# which can be reduced by constraining the maximum number of components (e.g., 250 is set as the maximum for HCP preprocessing)
# See section on smoothing
# Should expect about 85% to be noise

################################################################################
# Run melodic to find artifacts
################################################################################

# Test perp
# perps="190701SM 190624AO 190501DB 181218MS 181206RU 181203AJ 180815FY 180801IF 180329NR 180322SM 180317RC 180317LG 180315AL 180310MF 180308PV 180303JM 190618EP 190527AA 190520GH 190514AR 190429RB 190219SC 190211KV 190116CD 190115EH 181219CS 181210IS 181121JR 181107LB 181023AS 181017DS 180919SB"
# Individual:
# perps="180303JM" # mov001; running
# perps="180308PV" # mov003; running
# perps="180310MF" # mov004; running
# perps="180315AL" # mov006; running
# perps="180317LG" # mov009; running
# perps="180317RC" # mov007; running
# perps="180322SM" # mov002; running
# perps="180329NR" # mov008; running
# perps="180801IF" # mov012; running
# perps="180808AF" # mov014; done
# perps="180815FY" # mov013; running
# perps="181203AJ" # mov037; running
# perps="181206RU" # mov031; running
# perps="181218MS" # mov031;
# perps="190501DB" # mov050;
# perps="190624AO" # mov046;
# perps="190701SM" # mov057;
# perps="180919SB" # mov017;
# perps="181017DS" # mov019;
# perps="181023AS" # mov020;
# perps="181107LB" # mov021;
# perps="181121JR" # mov022;
# perps="181210IS" # mov034;
# perps="181219CS" # mov026;
# perps="190115EH" # mov036;
# perps="190116CD" # mov032;
# perps="190219SC" # mov024;
# perps="190429RB" # mov049;
# perps="190514AR" # mov045;
# perps="190520GH" # mov039;
# perps="190527AA" # mov043;
perps="190618EP" # mov054;
# ts_file="media_all_tshift_despike_reg_al_mni_mask_norm_polort_motion_wm_ventricle_timing"
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
for perp in $perps
do
  cd /data/movie/fmri/participants/adults/*/"$perp"/
  melodic \
    --dim="$num_dim" --tr=1.0 --nobet --report --Oall \
    --outdir=ica_artifiact_d"$num_dim"_"$ts_file" \
    --mask=anatomical_mask.nii.gz \
    --bgimage=anatomical_mask.nii.gz \
    --in="$ts_file".nii.gz
done

################################################################################
# Go through each perp by hand
################################################################################

##############################
perp="180303JM"
##############################

# NOTE
# Not done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "1 10 100 101 102 103 105 106 108 109 113 114 115 116 117 118 119 12 120 121 122 123 124 126 127 128 129 13 130 131 132 133 134 135 136 138 139 140 141 142 144 145 146 148 149 15 150 151 152 153 154 155 156 157 158 159 160 161 163 164 165 167 168 169 17 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 19 190 191 192 193 194 196 197 198 199 2 200 201 202 203 204 205 206 207 208 209 21 210 211 212 213 214 215 216 217 218 219 22 220 221 222 223 224 225 226 227 228 23 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 25 250 28 29 32 35 37 39 40 41 42 43 45 46 47 49 50 54 55 58 6 61 65 66 69 7 72 73 74 75 76 77 80 82 83 86 88 89 91 93 94 95 96 97 98 99" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perp="180308PV"
##############################

# NOTE
# Not done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perp="180310MF"
##############################

# NOTE
# done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "1 100 102 104 105 106 107 109 110 114 115 117 120 121 122 123 124 126 127 129 13 132 134 135 136 138 140 141 145 147 149 153 154 155 156 158 16 160 161 162 163 165 167 170 171 177 178 18 180 181 183 184 185 189 190 191 192 193 195 196 197 2 20 200 202 204 205 206 207 209 21 211 212 213 214 215 216 217 218 219 22 220 222 223 224 225 227 228 229 23 231 233 234 235 236 237 238 239 240 241 243 244 245 246 247 248 249 25 250 26 29 3 30 32 34 35 4 40 41 44 45 46 47 5 50 51 54 55 57 58 59 60 61 62 63 64 65 66 68 7 71 72 74 77 78 79 80 84 85 88 89 9 11 119 148 201 230 242 93 94 96 97" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perp="180315AL"
##############################

# NOTE
# done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "1 10 100 101 102 103 105 106 108 110 113 114 115 116 117 118 119 120 121 122 125 127 128 129 13 132 133 134 135 136 137 138 139 140 141 142 143 144 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 165 166 167 168 169 170 172 173 174 175 176 177 178 179 180 182 183 184 185 186 187 188 189 19 190 192 193 194 195 196 197 198 199 200 201 202 203 205 206 208 209 21 210 211 212 213 214 215 216 217 22 220 221 222 223 224 225 226 227 228 23 230 235 237 24 240 241 242 243 244 245 246 247 248 249 250 28 29 31 33 36 37 38 4 41 45 46 5 50 52 53 54 56 6 60 62 63 65 66 67 68 69 70 74 75 77 78 8 80 81 82 83 84 86 87 88 9 90 92 95 96 97 98 99 234 48" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perp="180317LG"
##############################

# NOTE
# done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "1 10 100 101 102 103 105 11 111 112 115 116 119 12 120 121 122 123 124 127 128 129 13 130 133 135 137 141 142 145 146 147 149 152 153 154 155 157 158 161 165 167 168 169 17 171 172 173 174 176 177 178 179 180 181 182 183 184 185 187 188 189 19 190 191 192 193 194 195 197 198 199 2 20 200 201 203 204 205 206 207 208 209 21 210 211 212 214 217 218 220 222 223 225 226 227 228 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 247 248 249 250 27 30 32 36 4 43 44 47 48 49 5 50 53 55 56 57 59 60 61 62 66 67 69 73 75 76 80 81 82 83 85 86 89 91 92 93 94 95 96 97 98 15 196 219 224 26" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perp="180317RC"
##############################

# NOTE
# Not done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perp="180322SM"
##############################

# NOTE
# done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "1 10 100 101 103 104 106 107 108 11 110 113 117 118 119 121 124 126 128 129 13 130 132 133 136 137 138 139 14 140 145 146 147 149 150 151 154 157 158 159 16 160 161 163 166 167 168 17 170 171 174 175 176 177 18 180 182 183 184 185 187 188 19 190 193 2 20 200 202 203 204 205 206 207 21 210 211 212 214 216 217 218 219 22 221 223 225 226 227 228 229 23 230 231 232 233 235 236 237 238 239 24 240 241 242 243 245 246 247 248 249 25 250 26 27 28 29 3 30 31 32 34 35 38 4 40 41 44 46 47 49 5 50 52 54 55 57 58 59 6 60 63 65 66 67 7 70 71 73 74 77 79 8 80 81 83 9 90 91 94 95 97 99" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perp="180329NR"
##############################

# NOTE
# Not done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perp="180801IF"
##############################

# NOTE
# done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "1 10 101 103 104 105 106 108 109 11 110 111 112 113 115 12 121 122 123 124 126 127 128 13 130 132 133 134 135 137 138 140 141 142 143 144 146 147 148 150 151 152 153 154 155 156 157 158 16 160 161 164 165 166 167 168 169 17 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 188 19 190 191 193 194 195 196 198 199 2 200 201 202 203 204 205 208 210 211 212 213 214 215 216 217 218 219 22 220 221 222 223 224 225 226 227 228 229 231 232 233 234 235 236 237 238 239 24 240 241 242 243 244 245 246 247 248 250 3 34 36 38 39 4 41 43 44 45 5 50 51 53 55 56 57 59 6 63 65 66 67 68 69 7 70 71 74 75 78 80 83 84 85 86 88 89 9 90 91 92 93 94 96 97 98 99 189 95" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perp="180808AF"
##############################

# NOTE
# done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "1 6 8 10 11 12 13 14 15 16 20 21 22 25 27 30 34 37 40 41 42 44 45 51 52 53 57 60 62 64 68 71 74 75 76 77 78 80 82 86 89 90 95 98 103 104 105 107 109 110 111 114 115 116 121 122 123 126 130 133 134 135 139 140 145 147 149 152 155 156 158 160 161 162 163 164 167 170 171 173 174 177 178 179 180 181 182 183 185 188 189 190 192 193 194 197 198 199 201 204 206 208 209 210 211 212 214 215 216 217 218 219 220 221 222 223 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perp="180815FY"
##############################

# NOTE
# Not done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "1 10 100 102 103 104 108 11 111 112 113 114 116 117 118 12 120 121 122 123 124 125 126 127 128 129 13 130 132 133 134 135 136 138 139 14 140 141 142 143 144 145 148 15 150 151 153 155 156 157 158 159 16 160 161 162 165 166 167 168 17 171 172 173 174 175 177 178 179 18 180 182 184 186 187 188 189 19 190 191 192 193 194 196 197 198 199 2 20 200 201 202 205 206 209 210 211 212 214 215 216 217 218 219 221 222 223 226 228 229 23 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 25 250 27 28 29 3 30 31 32 33 34 35 36 37 38 40 42 43 44 45 46 47 48 5 50 51 52 54 55 56 59 6 61 62 63 64 65 7 72 73 74 75 76 77 78 79 8 80 81 87 88 89 9 94 95 96 98 99" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perps="181203AJ"
##############################

# NOTE
# Not done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perps="181206RU"
##############################

# NOTE
# Not done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perps="181218MS"
##############################

# NOTE
# Not done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perps="190501DB"
##############################

# NOTE
# Not done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perp="190624AO"
##############################

# NOTE
# Not done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "1 10 100 101 102 103 104 105 109 111 112 113 114 115 116 117 118 119 12 120 121 122 124 125 127 129 13 131 132 133 135 137 138 14 140 141 142 143 144 145 146 147 148 149 150 151 152 154 155 158 16 160 161 163 164 165 167 168 169 170 171 172 173 175 177 178 179 183 184 186 187 188 189 19 191 192 193 195 197 198 199 2 201 203 205 206 207 208 209 210 211 212 213 214 216 217 218 219 22 221 222 223 224 225 227 228 229 23 230 231 232 233 234 236 237 238 243 244 245 246 247 248 249 250 27 29 3 30 31 32 33 39 4 41 43 44 49 51 52 53 6 60 61 62 63 64 66 68 7 70 74 75 76 79 8 80 82 85 87 89 90 91 92 95 98" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perps="190701SM"
##############################

# NOTE
# Not done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perp="180919SB"
##############################

# NOTE
# Not done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "1 10 100 103 104 106 107 109 111 112 113 115 116 117 118 119 122 13 131 133 134 135 137 138 14 144 146 147 149 15 150 154 156 157 16 162 163 165 166 167 168 169 17 171 172 173 174 175 176 177 18 180 182 183 184 185 186 187 188 19 190 191 193 194 195 198 199 2 200 201 202 203 204 205 206 207 208 209 21 210 211 212 213 214 215 216 217 218 219 22 220 221 222 223 224 225 226 227 228 229 231 232 233 235 236 237 239 240 241 242 243 244 245 246 247 248 249 250 26 3 37 39 40 41 43 45 5 50 54 6 60 69 74 76 77 8 80 85 86 88 9 90 91 98 99" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perps="181017DS"
##############################

# NOTE
# Not done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perp="181023AS"
##############################

# NOTE
# Not done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perp="181107LB"
##############################

# NOTE
# Not done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perp="181121JR"
##############################

# NOTE
# Not done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "103 105 106 108 110 113 114 115 116 118 119 12 121 122 123 126 127 128 129 132 133 134 135 136 138 14 140 141 143 145 146 147 148 150 151 152 153 155 157 158 159 161 162 164 166 167 168 169 17 170 171 173 175 176 178 179 182 184 185 186 187 189 190 191 192 194 196 198 199 200 201 202 203 204 205 207 208 209 211 213 214 215 218 219 220 221 223 224 225 226 227 229 230 231 232 233 234 235 236 237 238 239 24 240 241 242 243 244 245 246 247 248 249 25 250 29 30 31 33 35 36 37 40 43 44 45 46 47 48 49 5 50 55 57 58 59 63 65 66 67 7 70 71 74 75 76 77 78 8 81 83 86 87 89 9 92 95 96 98 99" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perp="181210IS"
##############################

# NOTE
# Not done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perp="181219CS"
##############################

# NOTE
# Not done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "1 10 100 103 104 107 108 109 110 112 113 117 118 12 120 121 123 124 125 126 127 128 129 13 130 133 135 136 137 138 139 14 142 143 144 145 147 149 15 150 152 153 155 156 158 159 160 161 163 164 165 166 167 169 17 171 172 173 174 175 176 177 178 179 18 180 182 183 184 185 187 190 191 194 195 196 197 199 20 201 202 204 205 206 207 208 209 21 211 212 213 214 215 216 217 218 219 221 222 223 225 227 228 229 23 230 231 232 233 234 235 236 237 238 239 24 240 241 243 244 245 246 247 248 249 250 26 28 29 3 30 32 33 34 35 38 39 4 42 43 46 47 49 5 53 54 55 56 57 58 6 60 61 62 63 64 67 68 7 70 71 72 73 74 8 80 81 82 83 84 86 87 89 9 90 91 93 95 96 99" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perp="190115EH"
##############################

# NOTE
# Not done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "1 10 100 105 108 109 11 110 111 112 115 118 121 122 123 124 13 130 131 132 134 135 137 14 140 142 143 144 147 148 150 154 155 156 157 158 159 16 162 163 165 166 167 168 169 17 170 171 172 173 174 176 177 178 180 182 184 185 186 187 188 19 190 191 193 197 198 2 20 200 201 203 204 205 206 207 208 209 21 211 212 213 214 215 216 217 218 219 22 220 221 222 223 224 225 226 227 228 229 23 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 25 26 27 3 33 35 36 4 40 41 43 45 47 48 49 5 53 55 57 58 59 6 60 61 62 63 66 67 68 7 70 71 73 75 76 77 78 79 8 81 84 85 87 89 90 91 93 96 97 98 99" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perp="190116CD"
##############################

# NOTE
# Not done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "1 101 102 104 107 108 109 11 111 115 116 118 119 120 121 122 129 13 130 133 137 138 140 141 142 144 145 146 147 15 150 152 153 154 156 157 158 159 16 160 162 164 165 166 167 169 171 172 176 177 178 179 182 183 184 186 187 188 189 191 192 193 194 195 196 197 2 200 201 202 203 204 205 206 208 209 21 210 211 213 214 215 216 217 219 220 221 222 223 224 225 226 227 229 23 230 231 232 233 234 235 236 237 238 239 24 240 241 242 243 244 245 246 247 248 25 250 27 28 29 3 30 32 33 4 44 45 46 49 5 50 52 56 6 60 63 64 69 70 73 78 8 81 83 85 87 88 9 91 92 95 97 99" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perps="190219SC"
##############################

# NOTE
# Not done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perps="190429RB"
##############################

# NOTE
# Not done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perps="190514AR"
##############################

# NOTE
# Not done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perps="190520GH"
##############################

# NOTE
# Not done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perps="190527AA"
##############################

# NOTE
# Not done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

##############################
perps="190618EP"
##############################

# NOTE
# Not done
ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
num_dim="250"
cd /data/movie/fmri/participants/adults/*/"$perp"/ica_artifiact_d"$num_dim"_"$ts_file"/stats/
mkdir files/
mv stats.log MMstats_* probmap_* files/
cp ../../anatomical_avg.aw.nii.gz ./
# firefox ../report/00index.html &
# sudo chmod -R 770 *
cd /data/movie/fmri/participants/adults/*/"$perp"/files/text_files/
echo "" | tr -cs 0-9 '[\n*]' > "$ts_file"_d"$num_dim"_artifacts.txt

################################################################################
# Build artifactual component regressor
################################################################################

# NOTE
# Set variables above
# Loop through labeled artifacts and rename timeseries files to include 'temp_'
cd /data/movie/fmri/participants/adults/*/"$perp"/
num_artis=`cat files/text_files/"$ts_file"_d"$num_dim"_artifacts.txt | wc | awk '{print $2}'`
while read arti_num; do
  echo "**************************************************" $arti_num
  cat  ica_artifiact_d"$num_dim"_"$ts_file"/report/t"$arti_num".txt \
     > ica_artifiact_d"$num_dim"_"$ts_file"/report/temp_t"$arti_num".1D
done < files/text_files/"$ts_file"_d"$num_dim"_artifacts.txt
# Concatenate 'temp_'s into one file
1dcat ica_artifiact_d"$num_dim"_"$ts_file"/report/temp_t*.1D \
    > files/text_files/"$ts_file"_d"$num_dim"_artifact_ics.1D
# Remove 'temp_' files
rm ica_artifiact_d"$num_dim"_"$ts_file"/report/temp_t*.1D
echo "**************************************************" $num_artis "**************************************************"

################################################################################
# Remove artifactual components from the functional data
################################################################################

# NOTE
# 3dDetrend \
# -vector files/text_files/"$ts_file"_d"$num_dim"_artifact_ics.1D \
# -prefix "$ts_file"_ica.nii.gz  \
#         "$ts_file".nii.gz
# Do with 3dTproject b/c its way way faster
# Also can use a censor file too if we eventually decide to do that:
# -censor XXX.1D -cenmode NTRP \
# This does default polort of 2 (who knows, maybe regressing out artifacts puts some trend back in) and re-normalizes
# Set variables above
cd /data/movie/fmri/participants/adults/*/"$perp"/
3dTproject \
-norm \
-ort files/text_files/"$ts_file"_d"$num_dim"_artifact_ics.1D \
-mask anatomical_mask.nii.gz \
-prefix "$ts_file"_ica.nii.gz \
-input  "$ts_file".nii.gz

################################################################################
# Compare results
################################################################################

# NOTE
# This takes too long to actually do.
# We'd have to set the dimensionality to somthing like 1000 as a compromise

# ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing"
# melodic \
#   --tr=1.0 --nobet --report --Oall \
#   --outdir=ica_"$ts_file" \
#   --mask=anatomical_mask.nii.gz \
#   --bgimage=anatomical_mask.nii.gz \
#   --in="$ts_file".nii.gz
# ts_file="media_all_tshift_despike_reg_al_mni_mask_blur6_norm_polort_motion_wm_ventricle_timing_ica"
# melodic \
#   --tr=1.0 --nobet --report --Oall \
#   --outdir=ica_"$ts_file" \
#   --mask=anatomical_mask.nii.gz \
#   --bgimage=anatomical_mask.nii.gz \
#   --in="$ts_file".nii.gz

################################################################################
# End
################################################################################
