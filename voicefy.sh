#!/bin/bash -e

if [[ $# != 1 ]]; then
	echo "Invalid usage! $0 AUDIO_IN" 1>&2
	exit 1
fi

audio_in="$1"
audio_out="safe_$(basename "$1")"

link_or_copy(){
	cp --link "$@" || cp "$@"
}

docker_storage="$(mktemp --directory)"
cleanup(){
	rm -rf "$docker_storage" || true
}
trap cleanup EXIT

mkdir "$docker_storage/input" "$docker_storage/output"

link_or_copy "$audio_in" "$docker_storage/input"

audio_in_name="$(basename "$audio_in")"
audio_out_name="$(basename "$audio_out")"

docker run \
	--volume "$docker_storage:/data"  \
	voicefy \
	"/opt/processors/voicefy_audio.sh" "/data/input/$audio_in_name" "/data/output/$audio_out_name" \

mv "$docker_storage/output/$audio_out_name" "$audio_out"
