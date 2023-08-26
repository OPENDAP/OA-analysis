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


groups = get_request_groups()
for group in groups:
    for line in group:
        print(line)
    print('---------------------------')
