#!/bin/bash -ex

if [[ $# != 2 ]]; then
	echo "Invalid usage! $0 VIDEO_IN VIDEO_OUT" 1>&2
	exit 1
fi


video_in="$1"
video_out="$2"

processing_dir="$(mktemp --directory)"
cleanup(){
	rm -rf "$processing_dir" || true
}
trap cleanup EXIT

audio_t="$(/opt/utility/detect_audio.sh "$video_in")"

processed_audio="$processing_dir/processed.$audio_t"
/opt/processors/voicefy_audio.sh "$video_in" "$processed_audio"

ffmpeg -i "$video_in" \
	-i "$processed_audio" \
	-map 0:v:0 -map 1:a:0 -map 0:s? \
	-c:v copy -c:s copy \
	"$video_out"
