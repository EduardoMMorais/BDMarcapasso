#!/usr/bin/Rscript

library(Rook)
# This script does not run in RStudio. See https://github.com/jeffreyhorner/Rook/pull/31/files for details
s <- Rhttpd$new()
s$add(
  app='./app.R',
  name='marcapasso'
)
s$start(listen='127.0.0.1', port='8081', quiet=FALSE)
suspend_console()
