#!/bin/bash

function change_to_root_dir {
  # Always change to root directory while pubspec.yaml is not in the current directory but don't go
  # past the project root directory
  echo "🔎 Jumping into root directory..."
  while [ ! -f "pubspec.yaml" ] && [ "$PWD" != "/" ]; do
    cd ..
  done
  echo "🤺 Wallah! $PWD"
}

function brb {
  flutter clean
  dart pub get
  dart run build_runner build --delete-conflicting-outputs
  dart format --line-length 80 .
}

function sort_translation_arb_files {
  targetDir="lib/l10n"

  # Check if the targetDir exists
  if [ ! -d "$targetDir" ]; then
    echo "🤷‍ DIRECTORY NOT FOUND: $targetDir"
    exit 1
  fi

  # Find all .arb files in the directory
  arbFiles=($(find "$targetDir" -name "*.arb"))

  # Check if .arb files are available
  if [ ${#arbFiles[@]} -eq 0 ]; then
    echo "😑 No .arb FILES FOUND IN $targetDir"
    exit 1
  fi

  # Loop through .arb files and sort the JSON keys
  for file in "${arbFiles[@]}"; do
    # Use jq to sort the file by keys (output to a temp file to avoid clobbering)
    jq -S . "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"

    # Check for jq error
    if [ $? -ne 0 ]; then
      echo "🙂 ERROR: Sorting failed for $file"
      exit 1
    else
      echo "🙂 SORTED: $file"
    fi
  done

  echo "🙂 All .arb files have been sorted."
}

function verify_config_content {
  # Check if config.json file exists
  if [ ! -f config.json ]; then
    echo "😹 You're missing the config.json file!"
    exit 1
  fi

  # Check if config.json file is valid JSON
  if ! jq . config.json > /dev/null 2>&1; then
    echo "💔 config.json file is not a valid JSON file!"
    exit 1
  fi

  # Verifies if json keys in "config.json" match "config_template.json". To prevent building and
  # deploying with missing or empty keys in "config.json" file.
  configKeys=$(jq -r 'keys[]' config.json)
  templateKeys=$(jq -r 'keys[]' config_template.json)

  if [ "$configKeys" == "$templateKeys" ]; then
      echo "🤝 Configuration keys match!"
  else
      echo "🤔 Misconfiguration in config.json ‼️Please fix that first ‼️"
      echo "Differences:"
      diff <(echo "$configKeys") <(echo "$templateKeys") | while IFS= read -r line; do
        echo "  $line"
      done
  fi

  empty_keys=()
  for key in $configKeys; do
    value=$(jq -r ".$key" config.json)
    if [ -z "$value" ]; then
      empty_keys+=("$key")
    fi
  done

  # echo those empty keys if any and exit with error to prevent deployment
  if [ ${#empty_keys[@]} -ne 0 ]; then
    echo "🫙BUT ‼️found empty keys in config.json:"
    for empty_key in "${empty_keys[@]}"; do
      echo " $empty_key is empty"
    done
    exit 1
  fi

  echo "🤝 config.json file is valid!"
}

function build_wasm_for_preview {
  echo "🕸️ Building wasm..."
  flutter build web --release --wasm
  echo "🚀 Web Assembly built successfully!"

  echo "🍽️ Serving wasm..."
  cd build/web || exit 1

  echo "🧹 Don't forget to terminate the server when you're done!"
  dart pub global activate dhttpd
  echo "🚀 Server started at: http://localhost:8080"
  open http://localhost:8080
  dhttpd '--headers=Cross-Origin-Embedder-Policy=credentialless;Cross-Origin-Opener-Policy=same-origin'
}

function build_and_release_wasm {
  echo "🕸️ Building wasm..."
  flutter build web --release --wasm
  firebase deploy
}

function build_and_release_canvaskit {
  echo "🕸️ Building CanvasKit..."
  flutter build web --release --web-renderer canvaskit
  firebase deploy
}

function sort_anime_watchlist_data {

  echo "🧹 Sorting anime watchlist data..."

  file_name="anime_watchlist.json"
  file_path="assets/$file_name"

  # check if file exists
  if [ ! -f "$file_path" ]; then
    echo "🤷‍ FILE NOT FOUND: $file_path"
    exit 1
  fi

  jq 'to_entries | sort_by(.key) | from_entries | map_values(sort_by(.name))' "$file_path" > "$file_path.tmp" && mv "$file_path.tmp" "$file_path"

# Check for jq error
  if [ $? -ne 0 ]; then
    echo "‼️ ERROR: Sorting failed for $file_path"
    exit 1
  fi

  git add "$file_path"
  git commit -m "chore(🧹): Sorted anime watchlist data"

  echo "✅ Watchlist sorted and commited!"
  exit 0
}
