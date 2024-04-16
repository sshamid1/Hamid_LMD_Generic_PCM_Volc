#!/usr/bin/ksh
# ------------------------------------------------------------------------------
# (C) Crown copyright Met Office. All rights reserved.
# For further details please refer to the file COPYRIGHT.txt
# which you should have received as part of this distribution.
# ------------------------------------------------------------------------------

lockfile='lock'

if [[ -f $lockfile ]]; then
  exit
fi

touch $lockfile

headrevfile='latest'
lastrevfile='lastrev'

# Current HEAD revision
if [[ ! -r $headrevfile ]]; then
  echo "HEAD revision file $headrevfile cannot be read, abort" >&2
  rm -f $lockfile
  exit 1
fi
headrev=$(<$headrevfile)
headrev=$(echo $headrev)

# Revision at which this script is last run
if [[ -r $lastrevfile ]]; then
  lastrev=$(<$lastrevfile)
  lastrev=$(echo $lastrev)
else
  lastrev=0
fi

# Exit if HEAD revision is the same as the last run revision
if (($lastrev == $headrev)); then
  rm -f $lockfile
  exit 0
fi

# ------------------------------------------------------------------------------
# Do something...
# ------------------------------------------------------------------------------

# Update last run revision file
echo $headrev >$lastrevfile
rm -f $lockfile

# EOF
