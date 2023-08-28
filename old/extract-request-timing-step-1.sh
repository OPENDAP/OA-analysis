#!/bin/bash
#
# extract information from bes log files and prepare them to be read into a spreadsheet

# $1 is the timing info file name, where the lines are sorted by PID and by the start us time

# Get only lines matching these patterns:
# BESServerHandler::execute
# RemoteResource::get_url() - source url: https://cmr.uat.earthdata.nasa.gov
# RemoteResource::get_url() - source url: .*\.dmrpp
# get dap for d1 return as dap2; transmitting
# CurlUtils::retrieve_effective_url()

# $2 is the basename for the new, subset log files
# writes the log file as a CSV to stdout

grep -e 'BESServerHandler::execute' \
-e 'RemoteResource::get_url() - source url: https://cmr.uat.earthdata.nasa.gov' \
-e 'RemoteResource::get_url() - source url: .*\.dmrpp' \
-e 'get dap for d1 return as dap2; transmitting' \
-e 'CurlUtils::retrieve_effective_url()' \
$1 > timing-step-1.csv

# Now remove lines that are the status test
awk -F, '{if ($5 > 999) print $0}' timing-step-1.csv > timing-step-2.csv
