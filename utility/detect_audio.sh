#!/bin/bash

if [[ $# != 1 ]]; then
	echo "Invalid usage! $0 AUDIO_FILE" 1>&2
	exit 1
fi

ffprobe -v quiet \
	-print_format json \
	-show_format \
	-show_streams \
	"$1"  | 
	jq --raw-output '.streams[] | select(.codec_type == "audio") | .codec_name ' |
	head -1;
