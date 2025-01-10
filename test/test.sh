#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2022-2024 Paul Colby <git@colby.id.au>
# SPDX-License-Identifier: MIT

# Hint:
#  gh run download <runId> --repo <user>/<repo> --dir <repor>-<run-id> --pattern test-results-*
#  find <repor>-<run-id> -type f -not -name '*.tap' -delete

set -o errexit -o noclobber -o nounset -o pipefail

: "${SOURCE_DIR:=${BASH_SOURCE[0]%/*}}"

failures=0
while IFS= read -d '' -r dirName; do
  echo "Test case: ${dirName##*/}"
  tapFiles=()
  while IFS='' read -r file; do tapFiles+=("${file}"); done < <(find "${dirName}" -name '*.tap' -type f -d -print || :)
  gawk -f "${SOURCE_DIR}/../summary.gawk" --sandbox -- "${tapFiles[@]}" >| "${dirName}/observed.md"
  case "${OSTYPE}" in
    darwin*) diffOptions=(--unified) ;;                                  # macOS
    msys*)   diffOptions=(--color=auto --strip-trailing-cr --unified) ;; # Windows
    *)       diffOptions=(--color=auto --unified) ;;
  esac
  diff "${diffOptions[@]}" "${dirName}/expected.md" "${dirName}/observed.md" || ((++failures))
done < <(find "${SOURCE_DIR}" -maxdepth 1 -mindepth 1 -type d -print0 || :)
[[ "${failures}" -eq 0 ]]
