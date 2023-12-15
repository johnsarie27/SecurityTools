# SecurityTools

## Decription

A PowerShell module with tools for information security, digital forensics, and
reporting tasks. Most functions were developed for Windows, however, an effort
was made to support multiple platforms where possible.

Functions range in functionality from conversion and reporting to getting
information from local (Windows Registry, patches, etc.) or remote (IP or domain
registration info) systems.

Several functions were written specifically for organizing and reporting on
vulnerabilities. This includes looking up CVSSv3 scores and Known Exploted
Vulnerability (KEV) lists.

Other functions were written to help review and triage web traffic.

## Lastest Version Notes

See release information for version notes

## Disclaimer

Feel free to create issues or pull requests, however, this project is developed
for use by a specific team of engineers, not for broad use.

## Repo layout

* [Public](./Public) -  functions that are available when using the module
* [Private](./Private) - functions/tools that are used internally by the module
* [Documentation](./Documentation) - help files for each cmdlet
* [Tests](./Tests) - Pester tests
* [Build](./Build) - tools to handle automated testing/builds

## Contributions, Feature Requests, and Feedback

To start, please read the [contribution guide](CONTRIBUTING.md).

* Read the current content and help us fix any spelling mistakes or grammatical errors.
* Choose an existing [issue](https://github.com/PS-MCS/MCS/issues) and submit a pull request to fix it.
* Open a new issue to report an opportunity for improvement.
