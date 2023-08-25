#!/bin/bash
#
# extract information from bes log files and prepare them to be read into a spreadsheet

# $1 is the log file name
# $2 is the basename for the new, subset log files
# writes the log file as a CSV to stdout

# basic stats

echo "Total lines, $(wc -l $1)"

echo "Error lines, $(grep '|error|' $1 | wc -l)"
echo "Info lines, $(grep '|info|' $1 | wc -l)"
echo "Request  lines, $(grep '|request|' $1 | wc -l)"
echo "Timing lines, $(grep '|timing|' $1 | wc -l)"

# Split into four sub logs, error, request, info and timing.
# Turn them into CSV files
# Sort those by PID and then 

grep '|error|' $1 | sed 's@|&|@,@g' | sort --numeric-sort --field-separator=, --key=2 > $2.error.csv
grep '|info|' $1 | sed 's@|&|@,@g' | sort --numeric-sort --field-separator=, --key=2 > $2.info.csv
grep '|request|' $1 | sed 's@|&|@,@g' | sort --numeric-sort --field-separator=, --key=2 > $2.request.csv
grep '|timing|' $1 | sed 's@|&|@,@g' | sort --numeric-sort --field-separator=, --key=2 --key=7> $2.timing.csv
