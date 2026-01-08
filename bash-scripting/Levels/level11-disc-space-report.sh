#Level 11: Automated Disk Space Report
#A script that sends an alert if disc space usage of "Arena" directory exceeds a given threshold.

#!/bin/bash

directory="Arena"
threshold="85"
space_used=$(du -sh $Directory | awk '{print $1}')

#Alert if directory disc usage exceeds 85K
if [ "${space_used::-1}" -gt 85 ]; then
 echo "Disc space usage of directory:$directory has exceeded 85K"
fi
