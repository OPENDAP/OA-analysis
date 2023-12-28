#!/bin/bash
#
# Test a query to Hyrax, verifying the response is valid and collecting basic timing data.
#
# Syntax OA-query-test.sh <N> <Name> <URL>
# N: Repeat N+1 times, discarding the first response
# URL: Get this response from the server. Must include the correct DAP2/DAP4 extension (e.g., .dap4)
#
# Print data for each of the N requests, as a table, with a header using <Name>

N="${1}"
name="${2}"
url="${3}"
edl_token_auth_hdr="${4}"

# Use the the EDL authorization header if one is provided.
if test -n "${edl_token_auth_hdr}"
then
    # Use cURL with no following redirects, no .netrc, no HTTP BASIC auth.
    curl -s -o "${name}" -H "${edl_token_auth_hdr}" "${url}"
else 
    # Use burl (cURL with following redirects, .netrc, and HTTP BASIC auth.)
    burl -s -o "${name}" "${url}"
fi

echo ""
echo "Request,$name,$url"
echo "Connect (s),TTFB (s),Total time(s),Response size (bytes)"

for i in $(seq $N)
do
    if test -n "${edl_token_auth_hdr}"
    then
        # Use cURL with no following redirects, no .netrc, no HTTP BASIC auth.
        curl -w "%{time_connect},%{time_starttransfer},%{time_total}," -s -o "${name}" -L -b cookie -c cookie -H "${edl_token_auth_hdr}" "${url}"
    else 
        # Use burl (cURL with following redirects, .netrc, and HTTP BASIC auth.)
        burl -w "%{time_connect},%{time_starttransfer},%{time_total}," -s -o "${name}" "${url}"
    fi
    
    if getdap4 -D -M $name > /dev/null
    then
        file_size=$(wc -c $name | awk '{print $1}')
        mv $name ${name}-${i}.dap4
        echo $file_size
    else
        echo "Bad response"
    fi
done
