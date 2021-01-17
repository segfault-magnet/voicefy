#!/bin/bash -e

if [[ $# != 2 ]]; then
	echo "Invalid usage! $0 VIDEO_IN VIDEO_OUT" 1>&2
	exit 1
fi

video_in="$1"
video_out="$2"

link_or_copy(){
	cp --link "$@" || cp "$@"
}

docker_storage="$( readlink --canonicalize-existing "$(mktemp --directory)" )"
cleanup(){
	rm -rf "$docker_storage" || true
}
trap cleanup EXIT

mkdir "$docker_storage/input" "$docker_storage/output"

link_or_copy "$video_in" "$docker_storage/input"

video_in_name="$(basename "$video_in")"
video_out_name="$(basename "$video_out")"

docker run voicefy \
	"./voicefy_video.sh" "/data/input/$video_in_name" "/data/output/$video_out_name" \
	--mount "$docker_storage:/data" 
