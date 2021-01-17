#!/bin/bash -x

if [[ $# != 2 ]]; then
	echo "Invalid usage! $0 AUDIO_IN AUDIO_OUT" 1>&2
	exit 1
fi


audio_in="$1"
audio_out="$2"

processing_dir="$(mktemp --directory)"
cleanup(){
	rm -rf "$processing_dir" || true
}
trap cleanup EXIT

audio_t="$(/opt/utility/detect_audio.sh "$audio_in")"

preprocess_audio="$processing_dir/original_audio" 
postprocess_audio="$processing_dir/spleeter_audio"
scrap_space="$processing_dir/scrap"
mkdir "$preprocess_audio" "$postprocess_audio" "$scrap_space"

rescrap(){
	rm -rf "$scrap_space"
	mkdir "$scrap_space"
}

ffmpeg -i "file:$audio_in" \
	 -map 0:a \
	 -c copy \
	 -segment_time 00:03:00 \
	 -segment_format "$audio_t" \
	 -f segment \
	 -reset_timestamps 1 \
	 "file:$preprocess_audio/%08d.$audio_t" < /dev/null


find "$preprocess_audio" -type f | 
	while read -r audio_part; do

		MODEL_PATH="/opt/models" spleeter separate \
			-p spleeter:2stems \
			-o "$scrap_space" "$audio_part"

		part_name="$(basename "$audio_part")"
		processed_file="$(find "$scrap_space" -type f -iname "*vocals*" | head -1 )"
		mv "$processed_file" "$postprocess_audio/$part_name"

		rescrap
	done

ffmpeg -f concat -safe 0 -i <( find "$postprocess_audio" -type f ) -c copy "$audio_out"
