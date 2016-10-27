#!/bin/bash

CURRENT_DATE=`/bin/date '+%M_%Y'`
LOGFILE=/var/tmp/${CURRENT_DATE}

/home/ec2-user/src/buildNvidiaCudaAndCudnn_main 2>&1 |tee ${LOGFILE}