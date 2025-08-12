# TAP Summary

[![Automatic Tests](https://github.com/pcolby/tap-summary/actions/workflows/test.yaml/badge.svg?branch=main)](
  https://github.com/pcolby/pcolby/tap-summary/actions/workflows/test.yaml)

GitHub Action for summarising [TAP] (Test Anything Protocol) test results. It
summarises a collection of TAP files (such a produced by Qt Tests), and writes the
result as a Markdown table to the GitHub step summary by default, or some other
destination file if overridden.

## Usage

```yaml
- uses: pcolby/tap-summary@v1
```

Note, this will use a default [`path`](#path) of `**/*.tap`, which depends on Bash's
globstar support, which is not available on macOS's default Bash (which is really
old). For macOS, either provide paths that don't depend on globstar, or upgrade Bash
(eg via `brew`). This is not necessary for Linux and Windows.

## Inputs

### `path`

One or more paths to [TAP] files. This will undergo Bash expansion, so things like
environment variables can be used, and must be quoted or escaped as appropriate.

Defaults to `**/*.tap`.

```yaml
- uses: pcolby/tap-summary@v1
  with:
    path: >-
      path/to/tap-file
      'path/to a file with spaces.tap'
      path/with/globstar/**/*.tap
    summary-file: path/to/output/file.md
```

### `summary-file`

The file to append the test summary to. Defaults to `$GITHUB_STEP_SUMMARY`.

```yaml
- uses: pcolby/tap-summary@v1
  with:
    summary-file: path/to/output/file.md
```

## Outputs

### `summary-file`

The file the test summary was appended to. This is mostly just for automated tests,
where it allows the invoking workflow job to check the summary output when the
input `summary-file` is defaulted.

[TAP]: https://testanything.org/ "Test Anything Protocol"
