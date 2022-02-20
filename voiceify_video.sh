#!/bin/bash -e

if [[ $# != 1 ]]; then
	echo "Invalid usage! $0 VIDEO_IN" 1>&2
	exit 1
fi

video_in="$1"
video_out="safe_$(basename "$1")"

link_or_copy(){
	cp --link "$@" || cp "$@"
}

docker_storage="$(mktemp --directory)"
cleanup(){
	rm -rf "$docker_storage" || true
}
trap cleanup EXIT

mkdir "$docker_storage/input" "$docker_storage/output"

link_or_copy "$video_in" "$docker_storage/input"

video_in_name="$(basename "$video_in")"
video_out_name="$(basename "$video_out")"

docker run \
	--volume "$docker_storage:/data"  \
	voicefy \
	"/opt/processors/voicefy_video.sh" "/data/input/$video_in_name" "/data/output/$video_out_name" \

mv "$docker_storage/output/$video_out_name" "$video_out"
