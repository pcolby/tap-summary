# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] (2025-01-10)

### Changed

- Separated failures with `TODO` [TAP directive]s into their own column, and not treated as failures.

## [1.1.1] (2024-02-16)

### Added

- Support for non-preferred block scalars (eg `|` or `>+` instead of `>-`).

## [1.1.0] (2024-02-11)

### Changed

- Increased support for non-QtTest (but still valid) TAP files ([#2])

### Fixed

- Total 'pass' count was incorrectly deducting 'skip' count.

## [1.0.1] (2023-03-29)

### Changed

- Switched from deprecated `set-output` command to new environment files.

## [1.0.0] (2022-07-23)

### Added

- Support for summarising [Qt Test] [TAP] files.
- Automated tests on all supported GitHub-hosted runners (`macos-*`, `ubuntu-*` and `windows-*`).

[unreleased]: https://github.com/pcolby/tap-summary/compare/v1.2.0...HEAD
[1.2.0]: https://github.com/pcolby/tap-summary/releases/tag/v1.2.0
[1.1.1]: https://github.com/pcolby/tap-summary/releases/tag/v1.1.1
[1.1.0]: https://github.com/pcolby/tap-summary/releases/tag/v1.1.0
[1.0.1]: https://github.com/pcolby/tap-summary/releases/tag/v1.0.1
[1.0.0]: https://github.com/pcolby/tap-summary/releases/tag/v1.0.0

[#2]:  https://github.com/pcolby/tap-summary/issues/2
[TAP]: https://testanything.org/ "Test Anything Protocol"
[TAP directive]: https://testanything.org/tap-version-14-specification.html#directive
[Qt Test]: https://doc.qt.io/qt-6/qtest-overview.html "Qt Test Overview"
