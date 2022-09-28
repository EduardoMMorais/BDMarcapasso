#!/bin/sh
cd /home/calculator/
su -c '/usr/bin/Rscript server.R' - calculator &
sleep 3s
nginx -g "daemon off;"