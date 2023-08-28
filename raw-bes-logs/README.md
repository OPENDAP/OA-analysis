
# Notes

## To process the log data

* Run the `process-log.sh` script with the raw BES log as input. Parameter $2 is the prefix for the putput files
* Run the `extract-req-timing.py` script using the `.timing.csv` and `.request.csv` files from above as input.
* Import the output from `extract-req-timing.py` to a spreadsheet.
* Make sense of the data...

## About the raw BES log files

These two log files (bes-2d47.log and bes-72bf.log) were gathered after 
the 8 URLs supplied by Kevin Bean were accessed 20 times each. The 
accesses were run from a remote desktop machine, not a machine in the cloud. 

The bes-2d47 EC2 instance was about 2 hours old and the log is much
smaller than the bes-72bf log that was over a day old.

edamame:raw-bes-logs jimg$ ./process-logs.sh bes-2d47.log bes-2d47
Total lines,     3820 bes-2d47.log
Error lines,        6
Request lines,      125
Info lines,      137
Timing lines,     3430

There are 122 lines from the 2d47 log file not in one of the csv
files. 

edamame:raw-bes-logs jimg$ ./process-logs.sh bes-72bf.log bes-72bf
Total lines,     8782 bes-72bf.log
Error lines,        8
Request lines,      290
Info lines,      354
Timing lines,     8040

There are 90 lines from the 72bf log file that are no in one of the
four csv files.
