#!/bin/bash
#
# Test a query to Hyrax, verifying the response is valid and collecting basic timing data.
#
# Syntax OA-query-test.sh <N> <Name> <URL>
# N: Repeat N+1 times, discarding the first response
# URL: Get this response from the server. Must include the correct DAP2/DAP4 extension (e.g., .dap4)
#
# Print data for each of the N requests, as a table, with a header using <Name>

N=$1
name=$2
url=$3

burl -s -o $name "$url"

echo ""
echo "Request,$name,$url"
echo "Connect (s),TTFB (s),Total time(s),Response size (bytes)"

for i in $(seq $N)
do
    burl -w "%{time_connect},%{time_starttransfer},%{time_total}," -s -o $name "$url"
    if getdap4 -D -M $name > /dev/null
    then
        file_size=$(wc -c $name | awk '{print $1}')
        rm $name
        echo $file_size
    else
        echo "Bad response"
    fi
done
