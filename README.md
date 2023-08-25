
# Performance analysis of NASA's Open Altimetry Web UI

## Driving around on UAT's EC2 instances

AWS Console --> System Manager --> Session Manager. 

To get access to a specific host, 'Start Session'

Once there (useful commands):

* `sudo -s` gets root access
* `docker ps -a` shows the container Ids
* `docker exec it <container> bash` to access the container with a Bash shell
* `docker cp <conatiner>:/var/log/bes/bes.log .` when run in the EC2 host (not the container) will copy the container's bes.log to the EC2 host's file system
* `aws s3 cp bes.log s3://opendap.scratch/UAT-logs/bes-2d47.log` How to get files off of an EC2 instance in UAT, et cetera. Use ENV Vars for the credentials.



