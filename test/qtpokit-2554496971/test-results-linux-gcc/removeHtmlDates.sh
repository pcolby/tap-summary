#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2022 Paul Colby <git@colby.id.au>
# SPDX-License-Identifier: LGPL-3.0-or-later
#
# Optional script that may be executes after building the `coverage-html`
# target, to remove timestamps from the HTML reports. Somewhat analogous
# to setting Doxygen's HTML_TIMESTAMP to `no` (which is the default).
#

set -o errexit -o noclobber -o nounset -o pipefail

while IFS= read -d '' -r htmlFile; do
  sed -Ei \
    -e '/headerItem">Test:</{s/>.*:/>Project:/;n;s/>.*</>QtPokit</}' \
    -e '/headerItem">Date:</{s/>.*:/>Version:/;n;s/>.*</>0.1.0-pre</}' \
    "$htmlFile" < /dev/null
done < <(find '/home/runner/work/_temp/coverage/' -name '*.html' -print0)
