#!/usr/bin/env bash

set -o errexit -o noclobber -o nounset -o pipefail

: "${SOURCE_DIR:=${BASH_SOURCE[0]%/*}}"

function require {
  local C;
  for c in "$@"; do
    if [ -v "${c^^}" ]; then continue; fi
    C=$(command -v "$c") || { echo "Required command not found: $c" >&2; exit 1; }
    declare -gr "${c^^}"="$C"
  done
}

require diff find gawk

failures=0
while IFS= read -d '' -r dirName; do
  echo "Test case: ${dirName##*/}"
  "$GAWK" -f "$SOURCE_DIR/../test-summary.gawk" --sandbox -- "$dirName"/*/{*.tap,test/unit/*.tap} >| "$dirName/observed.md"
  "$DIFF" --color=auto --strip-trailing-cr --unified "$dirName/expected.md" "$dirName/observed.md" || ((++failures))
done < <("$FIND" "$SOURCE_DIR" -maxdepth 1 -mindepth 1 -type d -print0)
[[ "$failures" -eq 0 ]]
