#!/bin/bash
#
# repeatedly run the rough analysis and collect the CSV files.
#
# Usage: OA-iterate.sh <results dir base name>

counter=1

results_dir_base=$1
iterations=$2

results_dir=${results_dir_base-run_caching_master}

./OA-performance.sh
mkdir ${results_dir}_$counter
mv *.csv *.dap ${results_dir}_$counter 2> /dev/null

counter=$((counter + 1))
while test $counter -lt $iterations
do
    echo $counter
    ./OA-performance.sh
    mkdir ${results_dir}_$counter
    mv *.csv *.dap ${results_dir}_$counter 2> /dev/null
    counter=$((counter + 1))
done
