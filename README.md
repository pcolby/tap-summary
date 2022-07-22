# TAP Summary

[![Automatic Tests](https://github.com/pcolby/tap-summary/actions/workflows/test.yaml/badge.svg?branch=main)](
  https://github.com/pcolby/pcolby/tap-summary/actions/workflows/test.yaml)

GitHub Action for summarising [TAP] (Test Anything Protocol) test results.

## Usage

### Basic

```yaml
- uses: pcolby/tap-summary@v1
```

### Advanced

```yaml
- uses: pcolby/tap-summary@v1
  with:
    path: >-
      path/to/tap-file
      'path/to a file with spaces.tap'
      path/with/globstar/**/*.tap
    summary-file: path/to/output/file.txt
```

## Inputs

### `path`

One or more paths to [TAP] files. This will undergo Bash expansion, so things like
environment variables can be used, and must be quotes or escapes are appropriate.

Defaults to `**/*.tap`.

### `summary-file`

The file to append the test summary to. Defaults to `$GITHUB_STEP_SUMMARY`.


[TAP]: https://testanything.org/ "Test Anything Protocol"
