#!/bin/sh
#
# Env variables from VEEAM are:
# VEEAM_SESSION_ID={uuid}
# VEEAM_JOB_NAME='Backup-eSpaces'
# VEEAM_JOB_ID={uuid}
# and this one only appears on error...
# VEEAM_SESSION_ERROR='Canceled by user [root]'

status=/usr/share/nginx/html/.status
date=$(date)

if [ -z "$VEEAM_SESSION_ERROR" ]; then
  echo "Success at $date" > $status
else
  echo "Failure at $date" > $status
fi
