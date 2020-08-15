#! /bin/bash

DEVICE="USB OPTICAL MOUSE "
xinput set-button-map "$DEVICE" 1 0

OUTPUT=$( xinput get-button-map "$DEVICE" )
echo "$OUTPUT | $(date)" >> /home/john/output.txt
