#!/usr/bin/env python3

filtered_timing_data = 'bes-2d47.timing.csv'

# BESServerHandler::execute
# RemoteResource::get_url() - source url: https://cmr.uat.earthdata.nasa.gov
# RemoteResource::get_url() - source url: .*\.dmrpp
# get dap for d1 return as dap2; transmitting
# CurlUtils::retrieve_effective_url()


def line_appears_useful(line):
    """ Returns true if the line contains data that we want to keep """
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


def get_request_groups():
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


def print_timing_data(groups):
    # 'start' is a time stamp and can be used to join with information in the 'request' csv file
    # 'granule' is the granule's DMR++ that was used
    # cmr, dmrpp, signed_url, and transmit are the times in seconds for those activities
    # cmr: Get the true URL for the given 'restified' URL
    # dmrpp: Get the DMR++ file used to read the data
    # signed_url: Use TEA to get a signed URL for use with S3
    # transmit: Actual time to read from S3 and send to the remote client
    print(f"start, granule, total, cmr, dmrpp, signed_url, transmit")

    for group in groups:
        start = "-"
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
                start = int(int(cmd_info[TRUE_START]) / MILLION)
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
        print(f"{start}, {granule}, {total}, {cmr}, {dmrpp}, {signed_url}, {transmit}")


groups = get_request_groups()
# for group in groups:
#     for line in group:
#         print(line)
#     print('---------------------------')

print_timing_data(groups)
