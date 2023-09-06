#!/bin/bash
#
# Run the rough analysis and collect the CSV files.

# -----------------
# Footprint queries
# -----------------

edl_auth_hdr=${edl_auth_hdr:-""}
if test -n "${edl_auth_hdr}"
then 
    echo "$0 - Using EDL Authorization Header: ${edl_auth_hdr}" >&2
else
    echo "Using .netrc and HTTP BASIC authentication" >&2
fi

RESP_BASE="ATL06"
./OA-query-test.sh 20 $RESP_BASE-response.dap 'https://opendap.uat.earthdata.nasa.gov/collections/C1241426872-NSIDC_CUAT/granules/ATL06_20200101223747_00950603_005_01.h5.dap?dap4.ce=/orbit_info_rgt;/orbit_info_crossing_time;/gt3r_land_ice_segments_latitude%5B0:256:%5D;/gt3r_land_ice_segments_longitude%5B0:256:%5D;/gt3r_land_ice_segments_delta_time%5B0:256:%5D;/gt3l_land_ice_segments_latitude%5B0:256:%5D;/gt3l_land_ice_segments_longitude%5B0:256:%5D;/gt3l_land_ice_segments_delta_time%5B0:256:%5D;/gt2r_land_ice_segments_latitude%5B0:256:%5D;/gt2r_land_ice_segments_longitude%5B0:256:%5D;/gt2r_land_ice_segments_delta_time%5B0:256:%5D;/gt2l_land_ice_segments_latitude%5B0:256:%5D;/gt2l_land_ice_segments_longitude%5B0:256:%5D;/gt2l_land_ice_segments_delta_time%5B0:256:%5D;/gt1r_land_ice_segments_latitude%5B0:256:%5D;/gt1r_land_ice_segments_longitude%5B0:256:%5D;/gt1r_land_ice_segments_delta_time%5B0:256:%5D;/gt1l_land_ice_segments_latitude%5B0:256:%5D;/gt1l_land_ice_segments_longitude%5B0:256:%5D;/gt1l_land_ice_segments_delta_time%5B0:256:%5D' "${edl_auth_hdr}" | tee $RESP_BASE-data.csv

RESP_BASE="ATL07"
./OA-query-test.sh 20 $RESP_BASE-response.dap 'https://opendap.uat.earthdata.nasa.gov/collections/C1241426887-NSIDC_CUAT/granules/ATL07-01_20200101015629_00820601_005_01.h5.dap?dap4.ce=/orbit_info_rgt;/orbit_info_crossing_time;/gt3r_sea_ice_segments_latitude%5B0:1024:%5D;/gt3r_sea_ice_segments_longitude%5B0:1024:%5D;/gt3r_sea_ice_segments_delta_time%5B0:1024:%5D;/gt3l_sea_ice_segments_latitude%5B0:1024:%5D;/gt3l_sea_ice_segments_longitude%5B0:1024:%5D;/gt3l_sea_ice_segments_delta_time%5B0:1024:%5D;/gt2r_sea_ice_segments_latitude%5B0:1024:%5D;/gt2r_sea_ice_segments_longitude%5B0:1024:%5D;/gt2r_sea_ice_segments_delta_time%5B0:1024:%5D;/gt2l_sea_ice_segments_latitude%5B0:1024:%5D;/gt2l_sea_ice_segments_longitude%5B0:1024:%5D;/gt2l_sea_ice_segments_delta_time%5B0:1024:%5D;/gt1r_sea_ice_segments_latitude%5B0:1024:%5D;/gt1r_sea_ice_segments_longitude%5B0:1024:%5D;/gt1r_sea_ice_segments_delta_time%5B0:1024:%5D;/gt1l_sea_ice_segments_latitude%5B0:1024:%5D;/gt1l_sea_ice_segments_longitude%5B0:1024:%5D;/gt1l_sea_ice_segments_delta_time%5B0:1024:%5D' "${edl_auth_hdr}"  | tee $RESP_BASE-data.csv

RESP_BASE="ATL08"
./OA-query-test.sh 20 $RESP_BASE-response.dap 'https://opendap.uat.earthdata.nasa.gov/collections/C1241426907-NSIDC_CUAT/granules/ATL08_20200101145654_00900605_005_01.h5.dap?dap4.ce=/orbit_info_rgt;/orbit_info_crossing_time;/gt3r_land_segments_latitude%5B0:64:%5D;/gt3r_land_segments_longitude%5B0:64:%5D;/gt3r_land_segments_delta_time%5B0:64:%5D;/gt3l_land_segments_latitude%5B0:64:%5D;/gt3l_land_segments_longitude%5B0:64:%5D;/gt3l_land_segments_delta_time%5B0:64:%5D;/gt2r_land_segments_latitude%5B0:64:%5D;/gt2r_land_segments_longitude%5B0:64:%5D;/gt2r_land_segments_delta_time%5B0:64:%5D;/gt2l_land_segments_latitude%5B0:64:%5D;/gt2l_land_segments_longitude%5B0:64:%5D;/gt2l_land_segments_delta_time%5B0:64:%5D;/gt1r_land_segments_latitude%5B0:64:%5D;/gt1r_land_segments_longitude%5B0:64:%5D;/gt1r_land_segments_delta_time%5B0:64:%5D;/gt1l_land_segments_latitude%5B0:64:%5D;/gt1l_land_segments_longitude%5B0:64:%5D;/gt1l_land_segments_delta_time%5B0:64:%5D' "${edl_auth_hdr}"  | tee $RESP_BASE-data.csv

RESP_BASE="ATL10"
./OA-query-test.sh 20 $RESP_BASE-response.dap 'https://opendap.uat.earthdata.nasa.gov/collections/C1241426950-NSIDC_CUAT/granules/ATL10-01_20200101002212_00810601_005_02.h5.dap?dap4.ce=/orbit_info_rgt;/orbit_info_crossing_time;/gt3r_freeboard_beam_segment_beam_freeboard_latitude%5B0:2048:%5D;/gt3r_freeboard_beam_segment_beam_freeboard_longitude%5B0:2048:%5D;/gt3r_freeboard_beam_segment_beam_freeboard_delta_time%5B0:2048:%5D;/gt3l_freeboard_beam_segment_beam_freeboard_latitude%5B0:2048:%5D;/gt3l_freeboard_beam_segment_beam_freeboard_longitude%5B0:2048:%5D;/gt3l_freeboard_beam_segment_beam_freeboard_delta_time%5B0:2048:%5D;/gt2r_freeboard_beam_segment_beam_freeboard_latitude%5B0:2048:%5D;/gt2r_freeboard_beam_segment_beam_freeboard_longitude%5B0:2048:%5D;/gt2r_freeboard_beam_segment_beam_freeboard_delta_time%5B0:2048:%5D;/gt2l_freeboard_beam_segment_beam_freeboard_latitude%5B0:2048:%5D;/gt2l_freeboard_beam_segment_beam_freeboard_longitude%5B0:2048:%5D;/gt2l_freeboard_beam_segment_beam_freeboard_delta_time%5B0:2048:%5D;/gt1r_freeboard_beam_segment_beam_freeboard_latitude%5B0:2048:%5D;/gt1r_freeboard_beam_segment_beam_freeboard_longitude%5B0:2048:%5D;/gt1r_freeboard_beam_segment_beam_freeboard_delta_time%5B0:2048:%5D;/gt1l_freeboard_beam_segment_beam_freeboard_latitude%5B0:2048:%5D;/gt1l_freeboard_beam_segment_beam_freeboard_longitude%5B0:2048:%5D;/gt1l_freeboard_beam_segment_beam_freeboard_delta_time%5B0:2048:%5D' "${edl_auth_hdr}"  | tee $RESP_BASE-data.csv

RESP_BASE="ATL12"
./OA-query-test.sh 20 $RESP_BASE-response.dap 'https://opendap.uat.earthdata.nasa.gov/collections/C1241426998-NSIDC_CUAT/granules/ATL12_20200101002212_00810601_005_02.h5.dap?dap4.ce=/orbit_info_rgt;/orbit_info_crossing_time;/gt3r_ssh_segments_latitude%5B0:8:%5D;/gt3r_ssh_segments_longitude%5B0:8:%5D;/gt3r_ssh_segments_delta_time%5B0:8:%5D;/gt3l_ssh_segments_latitude%5B0:8:%5D;/gt3l_ssh_segments_longitude%5B0:8:%5D;/gt3l_ssh_segments_delta_time%5B0:8:%5D;/gt2r_ssh_segments_latitude%5B0:8:%5D;/gt2r_ssh_segments_longitude%5B0:8:%5D;/gt2r_ssh_segments_delta_time%5B0:8:%5D;/gt2l_ssh_segments_latitude%5B0:8:%5D;/gt2l_ssh_segments_longitude%5B0:8:%5D;/gt2l_ssh_segments_delta_time%5B0:8:%5D;/gt1r_ssh_segments_latitude%5B0:8:%5D;/gt1r_ssh_segments_longitude%5B0:8:%5D;/gt1r_ssh_segments_delta_time%5B0:8:%5D;/gt1l_ssh_segments_latitude%5B0:8:%5D;/gt1l_ssh_segments_longitude%5B0:8:%5D;/gt1l_ssh_segments_delta_time%5B0:8:%5D' "${edl_auth_hdr}"  | tee $RESP_BASE-data.csv

RESP_BASE="ATL13"
./OA-query-test.sh 20 $RESP_BASE-response.dap 'https://opendap.uat.earthdata.nasa.gov/collections/C1241427013-NSIDC_CUAT/granules/ATL13_20200101002212_00810601_005_01.h5.dap?dap4.ce=/orbit_info_rgt;/orbit_info_crossing_time;/gt3r_segment_lat%5B0:256:%5D;/gt3r_segment_lon%5B0:256:%5D;/gt3r_delta_time%5B0:256:%5D;/gt3l_segment_lat%5B0:256:%5D;/gt3l_segment_lon%5B0:256:%5D;/gt3l_delta_time%5B0:256:%5D;/gt2r_segment_lat%5B0:256:%5D;/gt2r_segment_lon%5B0:256:%5D;/gt2r_delta_time%5B0:256:%5D;/gt2l_segment_lat%5B0:256:%5D;/gt2l_segment_lon%5B0:256:%5D;/gt2l_delta_time%5B0:256:%5D;/gt1r_segment_lat%5B0:256:%5D;/gt1r_segment_lon%5B0:256:%5D;/gt1r_delta_time%5B0:256:%5D;/gt1l_segment_lat%5B0:256:%5D;/gt1l_segment_lon%5B0:256:%5D;/gt1l_delta_time%5B0:256:%5D' "${edl_auth_hdr}"  | tee $RESP_BASE-data.csv

# --------------------------
# ATL08 Elevation plot query
# --------------------------

RESP_BASE="ATL08-elevation"
./OA-query-test.sh 20 $RESP_BASE-response.dap 'https://opendap.uat.earthdata.nasa.gov/collections/C1241426907-NSIDC_CUAT/granules/ATL08_20200101145654_00900605_005_01.h5.dap?dap4.ce=/orbit_info_rgt;/orbit_info_crossing_time;/gt3r_land_segments_latitude%5B0:8:%5D;/gt3r_land_segments_longitude%5B0:8:%5D;/gt3r_land_segments_terrain_h_te_best_fit%5B0:8:%5D;/gt3r_land_segments_canopy_h_canopy%5B0:8:%5D;/gt3r_land_segments_delta_time%5B0:8:%5D;/gt3l_land_segments_latitude%5B0:8:%5D;/gt3l_land_segments_longitude%5B0:8:%5D;/gt3l_land_segments_terrain_h_te_best_fit%5B0:8:%5D;/gt3l_land_segments_canopy_h_canopy%5B0:8:%5D;/gt3l_land_segments_delta_time%5B0:8:%5D;/gt2r_land_segments_latitude%5B0:8:%5D;/gt2r_land_segments_longitude%5B0:8:%5D;/gt2r_land_segments_terrain_h_te_best_fit%5B0:8:%5D;/gt2r_land_segments_canopy_h_canopy%5B0:8:%5D;/gt2r_land_segments_delta_time%5B0:8:%5D;/gt2l_land_segments_latitude%5B0:8:%5D;/gt2l_land_segments_longitude%5B0:8:%5D;/gt2l_land_segments_terrain_h_te_best_fit%5B0:8:%5D;/gt2l_land_segments_canopy_h_canopy%5B0:8:%5D;/gt2l_land_segments_delta_time%5B0:8:%5D;/gt1r_land_segments_latitude%5B0:8:%5D;/gt1r_land_segments_longitude%5B0:8:%5D;/gt1r_land_segments_terrain_h_te_best_fit%5B0:8:%5D;/gt1r_land_segments_canopy_h_canopy%5B0:8:%5D;/gt1r_land_segments_delta_time%5B0:8:%5D;/gt1l_land_segments_latitude%5B0:8:%5D;/gt1l_land_segments_longitude%5B0:8:%5D;/gt1l_land_segments_terrain_h_te_best_fit%5B0:8:%5D;/gt1l_land_segments_canopy_h_canopy%5B0:8:%5D;/gt1l_land_segments_delta_time%5B0:8:%5D' "${edl_auth_hdr}" | tee $RESP_BASE-data.csv

# -------------------------
# ATL03 Photon plot queries
# -------------------------
# For a given granule there are two queries executed sequentially:

RESP_BASE="ATL08-photon"
./OA-query-test.sh 20 $RESP_BASE-response.dap 'https://opendap.uat.earthdata.nasa.gov/collections/C1241426826-NSIDC_CUAT/granules/ATL03_20200101145654_00900605_005_01.h5.dap?dap4.ce=/gt3r_geolocation_delta_time;/gt3r_geolocation_reference_photon_lat;/gt3r_geolocation_reference_photon_lon;/gt3r_geolocation_reference_photon_index;/gt3r_geolocation_segment_ph_cnt;/gt3r_geolocation_ph_index_beg;/gt3r_geolocation_segment_id' "${edl_auth_hdr}"  | tee $RESP_BASE-data.csv

RESP_BASE="ATL03-photon"
./OA-query-test.sh 20 $RESP_BASE-response.dap 'https://opendap.uat.earthdata.nasa.gov/collections/C1241426826-NSIDC_CUAT/granules/ATL03_20200101145654_00900605_005_01.h5.dap?dap4.ce=/gt3r_heights_delta_time%5B6710118:149:8209976%5D;/gt3r_heights_lat_ph%5B6710118:149:8209976%5D;/gt3r_heights_lon_ph%5B6710118:149:8209976%5D;/gt3r_heights_h_ph%5B6710118:149:8209976%5D;/gt3r_heights_signal_conf_ph%5B6710118:149:8209976%5D%5B0:1:4%5D'  "${edl_auth_hdr}" | tee $RESP_BASE-data.csv
