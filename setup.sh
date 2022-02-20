#!/bin/bash

script_dir="$(readlink --canonicalize-existing "$(dirname "$0")" )"

exec docker build --network=host --tag voicefy --file "$script_dir/Dockerfile" "$script_dir"
