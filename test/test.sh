#!/usr/bin/env bash

set -o errexit -o noclobber -o nounset -o pipefail

: "${SOURCE_DIR:=${BASH_SOURCE[0]%/*}}"

failures=0
while IFS= read -d '' -r dirName; do
  echo "Test case: ${dirName##*/}"
  gawk -f "$SOURCE_DIR/../test-summary.gawk" --sandbox -- "$dirName"/*/{*.tap,test/unit/*.tap} >| "$dirName/observed.md"
  diff --color=auto --strip-trailing-cr --unified "$dirName/expected.md" "$dirName/observed.md" || ((++failures))
done < <(find "$SOURCE_DIR" -maxdepth 1 -mindepth 1 -type d -print0)
[[ "$failures" -eq 0 ]]
