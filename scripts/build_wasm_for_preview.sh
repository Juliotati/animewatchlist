#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$DIR/functions.sh"

change_to_root_dir

build_wasm_for_preview
