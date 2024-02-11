#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2022-2024 Paul Colby <git@colby.id.au>
# SPDX-License-Identifier: MIT

set -o errexit -o noclobber -o nounset -o pipefail
shopt -s globstar inherit_errexit

: "${SOURCE_DIR:=${BASH_SOURCE[0]%/*}}"

failures=0
while IFS= read -d '' -r dirName; do
  echo "Test case: ${dirName##*/}"
  gawk -f "${SOURCE_DIR}/../summary.gawk" --sandbox -- "${dirName}"/**/*.tap >| "${dirName}/observed.md"
  case "${OSTYPE}" in
    darwin*) extraDiffArgs='' ;;                                 # macOS
    msys*)   extraDiffArgs='--color=auto --strip-trailing-cr' ;; # Windows
    *)       extraDiffArgs='--color=auto' ;;
  esac
  # shellcheck disable=SC2086 # We intentionally want word splitting for $extraDiffArgs.
  diff ${extraDiffArgs} --unified "${dirName}/expected.md" "${dirName}/observed.md" || ((++failures))
done < <(find "${SOURCE_DIR}" -maxdepth 1 -mindepth 1 -type d -print0 || :)
[[ "${failures}" -eq 0 ]]
