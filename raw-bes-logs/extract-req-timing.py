#!/usr/bin/env python3

#filtered_timing_data = 'bes-2d47.timing.csv'
#filtered_request_data = 'bes-2d47.request.csv'

# BESServerHandler::execute
# RemoteResource::get_url() - source url: https://cmr.uat.earthdata.nasa.gov
# RemoteResource::get_url() - source url: .*\.dmrpp
# get dap for d1 return as dap2; transmitting
# CurlUtils::retrieve_effective_url()


def line_appears_useful(line):
    """
    Returns true if the line contains data that we want to keep
    # BESServerHandler::execute
    # RemoteResource::get_url() - source url: https://cmr.uat.earthdata.nasa.gov
    # RemoteResource::get_url() - source url: .*\.dmrpp
    # get dap for d1 return as dap2; transmitting
    # CurlUtils::retrieve_effective_url()
    """

    # we are not interested in the status requests which take only a few ms.
    if 'BESServerHandler::execute' in line and int(line.split(',')[4]) > 999:
        return True

    useful = ['RemoteResource::get_url()', 'get dap for d1 return as dap2; transmitting', 'CurlUtils::retrieve_effective_url']
    for x in useful:
        if x in line:
            return True

    return False


def group_is_valid(group):
    """A valid group of lines for a DAP response will have """
    return len(group) == 4 and 'get dap for d1 return as dap2; transmitting' in group[-1] \
        or len(group) == 5 and 'CurlUtils::retrieve_effective_url' in group[-1]


def filter_groups_of_lines(lines):
    """
    For a set of lines, we are interested in four or five line sequences that start with an execute line
    and end with a 'CurlUtils::retrieve_effective_url' or a 'get dap for d1 return as dap2; transmitting' line.
    """
    groups = []
    group = []
    for line in lines:
        if 'BESServerHandler::execute' in line:
            if group_is_valid(group):
                groups.append(group)
            group = [line]
        else:
            group.append(line)

    return groups


def get_timing_groups(filtered_timing_data):
    """
    Read information from the timing data CSV file, extracting the 'useful' lines.
    Then extract from that information those groups of lines that correspond to
    requests for DAP4 data responses. From those, choose lines that hold information
    about key aspects of the requests such as the total time, the time spent working
    with CMR, with TEA, accessing the DMR and reading & transmitting the data.

    Store the lines for each request in a list and then each of those lists in a parent
    list.
    """
    useful_lines = []   # holds the lines that are useful

    with open(filtered_timing_data, 'r+') as f:
        for line in f.readlines():
            line = line.strip()
            if line_appears_useful(line):
                useful_lines.append(line)

    groups = filter_groups_of_lines(useful_lines)
    return groups


MILLION = 1000000
# info in parsed timing log line
COMMAND = 10
TRUE_START = 6
ELAPSED = 4
TIME_STAMP = 0
PID = 1


def build_timing_data_records(groups):
    # 'key' is a time stamp and pid. It can be used to join with information in the 'request' csv file
    # 'granule' is the granule's DMR++ that was used
    # cmr, dmrpp, signed_url, and transmit are the times in seconds for those activities
    # cmr: Get the true URL for the given 'restified' URL
    # dmrpp: Get the DMR++ file used to read the data
    # signed_url: Use TEA to get a signed URL for use with S3
    # transmit: Actual time to read from S3 and send to the remote client

    # print(f"key, granule, total, cmr, dmrpp, signed_url, transmit")

    timing_records = []

    for group in groups:
        key = "-"
        granule = "-"
        total = "-"
        cmr = "-"
        dmrpp = "-"
        signed_url = "-"
        transmit = "-"

        for cmd_info in group:
            cmd_info = cmd_info.split(',')
            # From 'BESServerHandler::execute get start time and total time duration
            if 'BESServerHandler::execute' in cmd_info[COMMAND]:
                start = str(int(int(cmd_info[TRUE_START]) / MILLION))
                pid = cmd_info[PID]
                key = start + "-" + pid
                total = int(cmd_info[ELAPSED]) / MILLION

            # From 'RemoteResource::get_url() - source url: https://cmr' get CMR time
            elif 'RemoteResource::get_url()' in cmd_info[COMMAND] and 'cmr' in cmd_info[COMMAND]:
                cmr = int(cmd_info[ELAPSED]) / MILLION

            # From 'RemoteResource::get_url() - source url: https://data...' get DMR++ fetch time
            elif 'RemoteResource::get_url()' in cmd_info[COMMAND] and 'dmrpp' in cmd_info[COMMAND]:
                dmrpp = int(cmd_info[ELAPSED]) / MILLION
                granule = cmd_info[COMMAND].split(' ')[4].split('/')[-1]

            # From 'transmitting' get time to read and transmit the data
            elif 'transmitting' in cmd_info[COMMAND]:
                transmit = int(cmd_info[ELAPSED]) / MILLION

            # From CurlUtils::retrieve_effective_url() get the time to get a signed URL for S3
            elif 'CurlUtils::retrieve_effective_url()' in cmd_info[COMMAND]:
                signed_url = int(cmd_info[ELAPSED]) / MILLION

        if signed_url != "-":   # transmit includes signed_url time
            transmit = round(transmit - signed_url, 6)

        timing_records.append([key, granule, total, cmr, dmrpp, signed_url, transmit])
        # print(f"{key}, {granule}, {total}, {cmr}, {dmrpp}, {signed_url}, {transmit}")

    return timing_records


STAMP = 0
PID = 1
PATH = 11
BES_RESPONSE = 14
DAP_CE = 17


def get_request_data(filtered_request_data):
    """ Extract info from each request line and return as a dictionary. """
    # 0          1                     11
    # 1692903045,184, , , , , , , , , ,/hyrax/ngap/collections/C1241426872-NSIDC_CUAT/granules/ATL06_20200101223747_00950603_005_01.h5.dap,
    # 12
    # dap4.ce=#orbit_info_rgt##orbit_info_crossing_time##gt3r_land_ice_segments_latitude#5B0:256:#5D##gt3r_land_ice_segments_longitude#5B0:256:#5D##gt3r_land_ice_segments_delta_time#5B0:256:#5D##gt3l_land_ice_segments_latitude#5B0:256:#5D##gt3l_land_ice_segments_longitude#5B0:256:#5D##gt3l_land_ice_segments_delta_time#5B0:256:#5D##gt2r_land_ice_segments_latitude#5B0:256:#5D##gt2r_land_ice_segments_longitude#5B0:256:#5D##gt2r_land_ice_segments_delta_time#5B0:256:#5D##gt2l_land_ice_segments_latitude#5B0:256:#5D##gt2l_land_ice_segments_longitude#5B0:256:#5D##gt2l_land_ice_segments_delta_time#5B0:256:#5D##gt1r_land_ice_segments_latitude#5B0:256:#5D##gt1r_land_ice_segments_longitude#5B0:256:#5D##gt1r_land_ice_segments_delta_time#5B0:256:#5D##gt1l_land_ice_segments_latitude#5B0:256:#5D##gt1l_land_ice_segments_longitude#5B0:256:#5D##gt1l_land_ice_segments_delta_time#5B0:256:#5D,
    # 13   14       15   16
    # BES, get.dap ,dap2,https://data.nsidc.uat.earthdatacloud.nasa.gov/nsidc-cumulus-uat-protected/ATLAS/ATL06/005/2020/01/01/ATL06_20200101223747_00950603_005_01.h5,
    # 17
    # /orbit_info_rgt;/orbit_info_crossing_time;/gt3r_land_ice_segments_latitude[0:256:];/gt3r_land_ice_segments_longitude[0:256:];/gt3r_land_ice_segments_delta_time[0:256:];/gt3l_land_ice_segments_latitude[0:256:];/gt3l_land_ice_segments_longitude[0:256:];/gt3l_land_ice_segments_delta_time[0:256:];/gt2r_land_ice_segments_latitude[0:256:];/gt2r_land_ice_segments_longitude[0:256:];/gt2r_land_ice_segments_delta_time[0:256:];/gt2l_land_ice_segments_latitude[0:256:];/gt2l_land_ice_segments_longitude[0:256:];/gt2l_land_ice_segments_delta_time[0:256:];/gt1r_land_ice_segments_latitude[0:256:];/gt1r_land_ice_segments_longitude[0:256:];/gt1r_land_ice_segments_delta_time[0:256:];/gt1l_land_ice_segments_latitude[0:256:];/gt1l_land_ice_segments_longitude[0:256:];/gt1l_land_ice_segments_delta_time[0:256:]
    requests = {}
    key = "-"
    response = "-"
    path = "-"
    dap_ce = "-"

    with open(filtered_request_data, 'r+') as f:
        for line in f.readlines():
            dap_ce = "-"     # might be absent
            line = line.strip().split(',')
            key = line[STAMP] + "-" + line[PID]
            response = line[BES_RESPONSE]
            path = line[PATH]
            if len(line) > 17:
                dap_ce = line[DAP_CE]
            requests[key] = [response, path, dap_ce]

    return requests


def join_timing_and_request_data(timing_data, request_data):
    """
    Perform a join on these two data tables. If there is no request_data item,
    do not include the timing info.
    """
    joined_data = []

    for timing_record in timing_data:
        key = timing_record[0]
        if key in request_data.keys():  # request_data might not be complete WRT timing_data
            request_record = request_data[key]
            joined_data.append(timing_record + request_record)

    return joined_data


def print_timing_data(timing_data):
    for timing_record in timing_data:
        print(*timing_record, sep=", ")


def print_request_data(request_data):
    for key in request_data.keys():
        request_record = request_data[key]
        print(f"{key}, ", end="")
        print(*request_record, sep=", ")


def main():
    import argparse
    parser = argparse.ArgumentParser(description="Parse and combine information from the 'timing' and 'requests'"
                                     "files built using a bes.log file")
    parser.add_argument("-v", "--verbose", help="increase output verbosity", action="store_true")
    parser.add_argument("-r", "--requests", help="request data file")
    parser.add_argument("-t", "--timing", help="timing data file")

    args = parser.parse_args()

    filtered_timing_data = args.timing      #'bes-2d47.timing.csv'
    filtered_request_data = args.requests   # 'bes-2d47.request.csv'

    timing_data = build_timing_data_records(get_timing_groups(filtered_timing_data))
    request_data = get_request_data(filtered_request_data)

    if args.verbose:
        print_timing_data(timing_data)
        print("------------------------")
        print_request_data(request_data)

    request_timing_records = join_timing_and_request_data(timing_data, request_data)

    print(f"key, granule, total (s), cmr (s), dmrpp (s), signed_url (s), transmit (s), BES response, BES path, DAP CE")
    for records in request_timing_records:
        print(*records, sep=",")


if __name__ == "__main__":
    main()
