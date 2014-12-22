#!/bin/bash

# voxrecorder.sh
# Todd Foster, 2014 Dec 22
# https://github.com/toddfoster/voxrecorder
#
# References:
# http://sox.sourceforge.net/sox.html
# http://digitalcardboard.com/blog/2009/08/25/the-sox-of-silence/


########
# Config
########

# Paths

# Where to store recordings in progress:
# Warning: old recordings will be destroyed when script is run!
WIPDIR="/tmp/voxrecorder/recordings"
WIPNAME="recording"

# Where to store finished recordings (e.g., directory available via http)
# PUBLISHTIMESTAMP is a format specification for the "date" utility
# Finished recordings will be named PUBLISHNAME-PUBLISHTIMESTAMP.PUBLISHFORMAT
PUBLISHDIR="/tmp/voxrecorder/completed"
PUBLISHNAME="StPMV"
PUBLISHTIMESTAMP="%Y%m%d-%H%M"
PUBLISHFORMAT="flac"


# Times

# How long does silence have to be to separate recordings?
# Use a trailing ".0" to make sure sox knows you're talking about seconds
# On a test platform, the time specification was wonky: it appears to delay
# for around half the specified time. Behavior seems consistent.
SILENTTIME="18.0"

# How long must a recording be to be viable?
# Format: whole number of seconds
VIABLETIME="60"


# SOX Settings

SOXSOURCE="--default-device"
SOXPARAMS="--no-show-progress"
THRESHOLD="3.0%"
SOXSILENCE="silence 1 0.50 $THRESHOLD 1 $SILENTTIME $THRESHOLD"

# ------------------------------------------------------
# Ideally, nothing below here should need to be modified
# ------------------------------------------------------


SOX=`which sox`
SOXI=`which soxi`
#TODO: abort if missing binaries

# Create missing directories
mkdir -p $WIPDIR
mkdir -p $PUBLISHDIR

# Clear old recordings
rm -f $WIPDIR/$WIPNAME*.$PUBLISHFORMAT

# Start recording
$SOX $SOXSOURCE $WIPDIR/$WIPNAME.$PUBLISHFORMAT \
	$SOXPARAMS 	$SOXSILENCE : newfile : restart &

# Wake up periodically to publish/clean up
while [ 1 ]
do
	sleep 2s

	#TODO: Check free space, rm oldest files if below minimum

	# Sort files in reverse by time; skip first (which is the active file)
	firstpass=""
	for i in `ls -1rt $WIPDIR/$WIPNAME*.$PUBLISHFORMAT`
	do
		if [ -z "$firstpass" ]
		then
			firstpass="done"
		else
			# Older files: delete or publish
			modtime=`ls -gG --full-time $i | awk '{print $4,$5,$6}'`
			begintime=`date +$PUBLISHTIMESTAMP --date "$modtime -$length seconds"`
			length=`$SOXI -D $i | egrep -o '^[0-9]+'`

			# Delete if too short, else publish
			if [ "$length" -lt "$VIABLETIME" ]
			then
				rm $i
				echo "Erased recording that was too short: $length seconds recorded at $begintime"
			else
				newname="$PUBLISHNAME-$begintime.$PUBLISHFORMAT"
				mv $i $PUBLISHDIR/$newname
				echo "Created recording $newname ($length seconds)"
			fi
		fi
	done
done

