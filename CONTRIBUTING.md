# Contributing Guide

- For minor fixes such as a typo, a simple pull request is all that's needed. For more involved changes, please follow the process laid out below.
- :heavy_exclamation_mark: Focus on updating a single function/cmdlet in a Pull Request to make the review processes simpler for the core team.

To propose changes to the existing functions or the creation of a new one, the process is as follows:

1. Create a new [issue](https://github.com/johnsarie27/SecurityTools/issues/new/choose) using either:
   - The `new_function_proposal` template if you want to propose a new function.
   - The `update_function_proposal` template if you want to modify a existing function.
2. Create a new issue
3. Once the issue has been discussed and approved:
    1. Clone this repository.
    2. Create a new branch.
    3. Either:
        - Create the page using the [new function template](templates/new-function.md).
        - Modify the target function in case of an update or refactor.
    4. Submit your [Pull Request](https://help.github.com/articles/creating-a-pull-request/).

## Style Guide

### Content

The intended purpose of the functions in this module is to support information security, digital forensics, and reporting tasks. External module dependencies are kept to a minimum and must be justified — currently the module requires `ImportExcel` (used by the `Export-*` reporting functions) and optionally uses `SqlServer`, `ActiveDirectory`, and `GroupPolicy` for specific Windows-only functions. New dependencies should be discussed in an issue before being added.

### Structure

- Start with this general structure

```pwsh
function <FunctionName> {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>

    [CmdletBinding()]
    Param()
}
```

- Only use approved verbs when naming functions
- Function must include properly defined help

## How to get started contributing

Follow these steps:

1. Install [Visual Studio Code (VSCode)](https://code.visualstudio.com/).
2. Open the file [Project.code-workspace](project.code-workspace) from VSCode via the menu `File > Open Workspace...`.
3. You should be prompted to open the workspace in a dev container. If you are not prompted, open the Command Palette and search for "Remote-Containers: Rebuild and Reopen in Container". When complete, you should be connected to the development container as if it was your local machine.
4. You are ready to contribute :+1:

>:alarm_clock: What to verify before pushing the updates?

Ensure your changes are passing PSScriptAnalyzer and Pester tests.

```pwsh
  ./Build/build.ps1 -ResolveDependency -TaskList Test # run pester
  ./Build/build.ps1 -ResolveDependency -TaskList Analyze # run psscriptanalyzer
  ./Build/build.ps1 -ResolveDependency -TaskList Cleanup # cleanup testing artifacts
```

## Pull Requests

Apply one or more labels to your PR at open-time so it is grouped correctly in the auto-generated release notes (configured in [.github/release.yml](.github/release.yml)). Use the label that best describes the user-visible impact:

| Label | Section in release notes |
| --- | --- |
| `breaking` / `breaking-change` | Breaking Changes |
| `enhancement` / `feature` | New Features |
| `bug` / `fix` | Bug Fixes |
| `security` | Security |
| `documentation` / `docs` | Documentation |
| `ci` / `build` / `dependencies` | CI / Build |
| _(none / other)_ | Other Changes |

PRs land in the **first** matching category, so order labels by importance (e.g., a `security` + `bug` PR should be labeled with `security` if you want it to appear there). Apply `ignore-for-release` to omit a PR from the notes entirely.

## Release

This project also includes the necessary tools to automate the release of the module via GitHub Actions. The file [release.yml](.github/workflows/release.yml) handles this task.

To create a new release of the module, first update the module manifest with the necessary version number and commit that to the main branch. Then, create a new tag with the same version number and push it to GitHub. This will start the build process and publish a new version of the module to the repo.
