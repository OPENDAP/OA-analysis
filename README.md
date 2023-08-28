
# Performance analysis of NASA's Open Altimetry Web UI

To collect the data for this analysis, the following steps need to be performed: make sure...
1. the `burl` script is available
2. the `curl` command is available
3. the `getdap4` command is available
4. the ~/.netrc file is present and contains UAT credentials

Run the script `OA-performance.sh` to collect the data. You can save the generated files to
new directories.

## About the data in run_1 and run_2

These directories hold csv files that contain the total time, time to connect to the server and the total time to the 
first byte of data. The timing information was collected by cURL. For data in `run_1` the client was _not_ using the
EBNET VPN while for `run_2` the client _was_ using the VPN.

## About the data in raw-bes-logs
See the README.md file in that directory. To _get_ the bes.log files from our UAT deployment, 
use Kion to access the hosts and use the commands in _Driving around on UAT's EC2 instances_ 
to copy the raw logs here. Then see the raw-bes-logs README for more information.

### Driving around on UAT's EC2 instances

AWS Console --> System Manager --> Session Manager. 

To get access to a specific host, 'Start Session'

Once there (useful commands):

* `sudo -s` gets root access
* `docker ps -a` shows the container Ids
* `docker exec it <container> bash` to access the container with a Bash shell
* `docker cp <conatiner>:/var/log/bes/bes.log .` when run in the EC2 host (not the container) will copy the container's bes.log to the EC2 host's file system
* `aws s3 cp bes.log s3://opendap.scratch/UAT-logs/bes-2d47.log` How to get files off of an EC2 instance in UAT, et cetera. Use ENV Vars for the credentials.

Set the AWS credentials using:
* [root@ip-10-9-0-37 ~]# export AWS_ACCESS_KEY_ID=******************
* [root@ip-10-9-0-37 ~]# export AWS_SECRET_ACCESS_KEY=****************************************
* [root@ip-10-9-0-37 ~]# export AWS_ACCESS_REGION=us-west-2

Then copy the file to S3:
* [root@ip-10-9-0-37 ~]# aws s3 cp bes.log s3://opendap.scratch/UAT-logs/bes-in-cloud-72bf.log

Back on the host with this OA-analysis repo, get the file using: 

    aws s3 cp s3://opendap.scratch/UAT-logs/bes-in-cloud-72bf.log .
