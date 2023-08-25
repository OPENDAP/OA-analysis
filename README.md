
# Performance analysis of NASA's Open Altimetry Web UI

## About the data in run_1 and run_2

These directories hold csv files that contain the total time, time to connect to the server and the total time to the 
first byte of data. The timing information was collected by cURL. For data in `run_1` the client was _not_ using the
EBNET VPN while for `run_2` the client _was_ using the VPN.

## About the data in raw-bes-logs


## Driving around on UAT's EC2 instances

AWS Console --> System Manager --> Session Manager. 

To get access to a specific host, 'Start Session'

Once there (useful commands):

* `sudo -s` gets root access
* `docker ps -a` shows the container Ids
* `docker exec it <container> bash` to access the container with a Bash shell
* `docker cp <conatiner>:/var/log/bes/bes.log .` when run in the EC2 host (not the container) will copy the container's bes.log to the EC2 host's file system
* `aws s3 cp bes.log s3://opendap.scratch/UAT-logs/bes-2d47.log` How to get files off of an EC2 instance in UAT, et cetera. Use ENV Vars for the credentials.



