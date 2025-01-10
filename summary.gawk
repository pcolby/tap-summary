# SPDX-FileCopyrightText: 2022-2024 Paul Colby <git@colby.id.au>
# SPDX-License-Identifier: MIT
#
# Summarise a set of QTest TAP (Test Anything Protocol) output files as a
# GitHub Flavored Markdown table. Typical usage is something like:
#
# testFoo -o foo.tap,tap -o -,txt
# testBar -o bar.tap,tap -o -,txt
# ...
# gawk --file summary.gawk --sandbox *.tap >> $GITHUB_STEP_SUMMARY
#

BEGIN {
  RS="\r?\n"     # Allow both DOS and *nix line endings.
  IGNORECASE = 1 # Non-zero number means yes.
  maxNameLength = 0
}

# Reset the test name at the beginning of each TAP file.
BEGINFILE {
  testName=""
}

# If we have test results, and no test name yet, default to the current TAP file name.
/^(not )?ok .*/ && !testName {
  name=FILENAME
  sub("^.*/", "", name)
  sub(".tap$", "", name)
  setTestName(name)
}

# QtTest sets the test name on the second line of the TAP file.
FNR==2 && NF==2 && $1=="#"  {
  setTestName($2)
}

function setTestName(name) {
  testName=name
  if (length(testName) > maxNameLength)
    maxNameLength = length(testName)
}

# Handle skipped tests.
/^ok .*[^\\]#\s*SKIP/ {
  tests[testName]["skip"]++
}

# Handle passed (but not skipped) tests.
/^ok / && !/^ok .*[^\\]#\s*SKIP/ {
  tests[testName]["pass"]++
}

# Handle todo (aka expected-failure) tests.
/^not ok .*[^\\]#\s*TODO/ {
  tests[testName]["xfail"]++
}

# Handle failed (unexpectedly) tests.
/^not ok / && !/^not ok .*[^\\]#\s*TODO/ {
  tests[testName]["fail"]++
}

END {
  nameDashes = "-"
  while (length(nameDashes) < maxNameLength) nameDashes = nameDashes "-"
  printf "|       Test result       | Passed | Failed | Skipped | %-*s |\n", maxNameLength, "Test name"
  printf "|:------------------------|-------:|-------:|--------:|:%*s-|\n", maxNameLength, nameDashes
  PROCINFO["sorted_in"] = "@ind_str_asc"
  for (name in tests) {
    printf "| %-18s %4s | %6u | %6u | %7u | %-*s |\n",
      (tests[name]["fail"]) ? ":x:" : ":heavy_check_mark:",
      (tests[name]["fail"]) ? "fail" : "pass",
      tests[name]["pass"], tests[name]["fail"], tests[name]["skip"],
      maxNameLength, name
  }
}
