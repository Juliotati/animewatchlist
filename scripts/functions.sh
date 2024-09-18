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

  # Check if there is any modification in target directory, if so create a commit including that
  # directory only.
  if [ -n "$(git status --porcelain "$file_path")" ]; then
    git add "$file_path"
    git commit -m "chore(🤖): Sorted anime watchlist data"

    # Push the change/commit from github workflow to the current branch
    if [ -n "$GITHUB_ACTIONS" ]; then
      git push origin $GITHUB_REF
      echo "🚀 Pushed commit to $GITHUB_REF"
    fi
    exit 0
  fi
  echo "✅ Watchlist already sorted!"
  exit 0
}
