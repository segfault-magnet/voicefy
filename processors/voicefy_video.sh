#!/bin/bash

if [[ $# != 2 ]]; then
	echo "Invalid usage! $0 VIDEO_IN VIDEO_OUT" 1>&2
	exit 1
fi

detect_audio_type(){
	ffprobe -v quiet \
		-print_format json \
		-show_format \
		-show_streams \
		"$1"  | 
		jq --raw-output '.streams[] | select(.codec_type == "audio") | .codec_name ' |
		head -1;
}

