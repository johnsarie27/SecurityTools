# SecurityTools

[![validate](https://github.com/johnsarie27/SecurityTools/actions/workflows/validate.yml/badge.svg?branch=main)](https://github.com/johnsarie27/SecurityTools/actions/workflows/validate.yml)
[![release](https://github.com/johnsarie27/SecurityTools/actions/workflows/release.yml/badge.svg)](https://github.com/johnsarie27/SecurityTools/actions/workflows/release.yml)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## Description

A PowerShell module with tools for information security, digital forensics, and
reporting tasks. Most functions were developed for Windows, however, an effort
was made to support multiple platforms where possible.

Functions range in functionality from conversion and reporting to gathering
information from local (Windows Registry, patches, etc.) or remote (IP or
domain registration info) systems.

Several functions were written specifically for organizing and reporting on
vulnerabilities. This includes looking up CVSSv3 scores and Known Exploited
Vulnerability (KEV) lists.

Other functions were written to help review and triage web traffic.

## Requirements

- PowerShell 7.0 or later (tested on Windows and Linux)
- [`ImportExcel`](https://www.powershellgallery.com/packages/ImportExcel) (required — used by the `Export-*` reporting functions)
- Optional, Windows-only: `SqlServer`, `ActiveDirectory`, `GroupPolicy` (loaded on demand by specific functions)

## Installation

Clone the repository and import the module directly:

```powershell
git clone https://github.com/johnsarie27/SecurityTools.git
Import-Module ./SecurityTools/SecurityTools.psd1
```

## Latest Version Notes

See the [Releases](https://github.com/johnsarie27/SecurityTools/releases) page
for version notes. Release notes are auto-generated from merged pull requests
and categorized via [.github/release.yml](.github/release.yml).

## Disclaimer

Feel free to create issues or pull requests; however, this project is developed
for use by a specific team of engineers, not for broad use.

## Repo Layout

- [Public](./Public) — functions that are available when using the module
- [Private](./Private) — functions/tools that are used internally by the module
- [Tests](./Tests) — Pester tests
- [Build](./Build) — tools to handle automated testing/builds

## Contributions, Feature Requests, and Feedback

To start, please read the [contribution guide](CONTRIBUTING.md).

- Read the current content and help fix any spelling mistakes or grammatical errors.
- Choose an existing [issue](https://github.com/johnsarie27/SecurityTools/issues) and submit a pull request to fix it.
- Open a new issue to report an opportunity for improvement.
