function Set-GitHubBranchProtection {
    <#
    .SYNOPSIS
        Apply a standard branch protection policy to a GitHub repository
    .DESCRIPTION
        Applies a standard branch protection policy to the default branch (or a
        named branch) of one or more GitHub repositories owned by the specified
        account. The default policy enforces signed commits, requires linear
        history, blocks force pushes and deletions, requires conversation
        resolution, and prevents administrators from bypassing the rules. These
        controls are designed to limit blast radius if an authentication key or
        token is compromised.

        Requires the GitHub CLI (gh) to be installed and authenticated with an
        admin-scoped token for the target account.
    .PARAMETER Owner
        GitHub account (user or organization) that owns the repositories
    .PARAMETER Repository
        One or more repository names (without the owner prefix). Accepts
        pipeline input.
    .PARAMETER Branch
        Branch to protect. When omitted, the repository's default branch is
        used.
    .PARAMETER ApprovalCount
        Number of required pull request approvals. Defaults to 0 for solo
        maintainers.
    .PARAMETER RequiredStatusCheck
        Required status check contexts that must pass before merging. Defaults
        to none.
    .PARAMETER DismissStaleReviews
        Dismiss approving reviews when new commits are pushed. Default: $true.
    .PARAMETER RequireCodeOwnerReview
        Require review from designated code owners. Default: $true.
    .INPUTS
        System.String.
    .OUTPUTS
        System.Management.Automation.PSCustomObject.
    .EXAMPLE
        PS C:\> Set-GitHubBranchProtection -Owner 'johnsarie27' -Repository 'PS.SSL' -WhatIf
        Show what protection would be applied to the default branch of the
        PS.SSL repository without making changes.
    .EXAMPLE
        PS C:\> 'PS.SSL', 'SecurityTools' | Set-GitHubBranchProtection -Owner 'johnsarie27'
        Apply the standard protection policy to the default branch of two
        repositories via pipeline.
    .NOTES
        Name:     Set-GitHubBranchProtection
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2026-05-27
        Comments:
        Requires the gh CLI: https://cli.github.com/
        Token must have admin:repo (or equivalent) scope.
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory, Position = 0, HelpMessage = 'GitHub account owner')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Owner,

        [Parameter(Mandatory, Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage = 'Repository name(s)')]
        [ValidateNotNullOrEmpty()]
        [Alias('Name', 'RepositoryName')]
        [System.String[]] $Repository,

        [Parameter(HelpMessage = 'Branch to protect (defaults to repo default branch)')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Branch,

        [Parameter(HelpMessage = 'Required approving review count')]
        [ValidateRange(0, 6)]
        [System.Int32] $ApprovalCount = 0,

        [Parameter(HelpMessage = 'Required status check contexts')]
        [System.String[]] $RequiredStatusCheck = @(),

        [Parameter(HelpMessage = 'Dismiss stale reviews on new commits')]
        [System.Boolean] $DismissStaleReviews = $true,

        [Parameter(HelpMessage = 'Require code owner reviews')]
        [System.Boolean] $RequireCodeOwnerReview = $true
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.MyCommand)"

        # VERIFY gh CLI IS AVAILABLE
        if (-not (Get-Command -Name 'gh' -ErrorAction SilentlyContinue)) {
            Write-Error -Message 'gh CLI not found in PATH. Install from https://cli.github.com/.' -ErrorAction Stop
        }

        # VERIFY gh CLI IS AUTHENTICATED
        $null = & gh auth status 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Error -Message 'gh CLI is not authenticated. Run: gh auth login --scopes admin:repo_hook,repo' -ErrorAction Stop
        }

        # BUILD PROTECTION PAYLOAD
        $protectionPayload = [Ordered] @{
            required_status_checks           = [Ordered] @{
                strict   = $true
                contexts = $RequiredStatusCheck
            }
            enforce_admins                   = $true
            required_pull_request_reviews    = [Ordered] @{
                dismiss_stale_reviews           = $DismissStaleReviews
                require_code_owner_reviews      = $RequireCodeOwnerReview
                required_approving_review_count = $ApprovalCount
                require_last_push_approval      = $true
            }
            restrictions                     = $null
            required_linear_history          = $true
            allow_force_pushes               = $false
            allow_deletions                  = $false
            block_creations                  = $false
            required_conversation_resolution = $true
            required_signatures              = $true
            lock_branch                      = $false
            allow_fork_syncing               = $false
        }

        # WRITE PAYLOAD TO TEMP FILE (gh api --input requires a file path)
        $payloadPath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ('gh-branch-protection-{0}.json' -f [System.Guid]::NewGuid())
        $protectionPayload | ConvertTo-Json -Depth 6 | Set-Content -Path $payloadPath -Encoding utf8
        Write-Verbose -Message ('Payload written to: [{0}]' -f $payloadPath)
    }
    Process {
        foreach ($repo in $Repository) {
            $repoFullName = '{0}/{1}' -f $Owner, $repo

            # RESOLVE TARGET BRANCH
            if ($PSBoundParameters.ContainsKey('Branch')) {
                $targetBranch = $Branch
            }
            else {
                Write-Verbose -Message ('Resolving default branch for [{0}]' -f $repoFullName)
                $repoInfo = & gh repo view $repoFullName --json defaultBranchRef 2>&1
                if ($LASTEXITCODE -ne 0) {
                    Write-Error -Message ('[{0}] - failed to query repository: {1}' -f $repoFullName, ($repoInfo -join ' '))
                    continue
                }

                $targetBranch = ($repoInfo | ConvertFrom-Json).defaultBranchRef.name
                if ([System.String]::IsNullOrWhiteSpace($targetBranch)) {
                    Write-Warning -Message ('[{0}] has no default branch - skipping.' -f $repoFullName)
                    continue
                }
            }

            $apiPath = 'repos/{0}/branches/{1}/protection' -f $repoFullName, $targetBranch
            $target = '{0}:{1}' -f $repoFullName, $targetBranch
            $action = 'Apply standard branch protection policy'

            if (-not $PSCmdlet.ShouldProcess($target, $action)) {
                [PSCustomObject] @{
                    Repository = $repoFullName
                    Branch     = $targetBranch
                    Result     = 'Skipped'
                    Message    = 'ShouldProcess declined'
                }
                continue
            }

            Write-Verbose -Message ('PUT {0}' -f $apiPath)
            $applyArgs = @('api', '-X', 'PUT', $apiPath, '--input', $payloadPath)
            $apiOutput = & gh @applyArgs 2>&1

            if ($LASTEXITCODE -ne 0) {
                Write-Error -Message ('[{0}] - gh api PUT failed: {1}' -f $repoFullName, ($apiOutput -join ' '))
                [PSCustomObject] @{
                    Repository = $repoFullName
                    Branch     = $targetBranch
                    Result     = 'Failed'
                    Message    = ($apiOutput -join ' ')
                }
            }
            else {
                [PSCustomObject] @{
                    Repository = $repoFullName
                    Branch     = $targetBranch
                    Result     = 'Protected'
                    Message    = 'Branch protection applied'
                }
            }
        }
    }
    End {
        # CLEANUP TEMP PAYLOAD FILE
        Remove-Item -Path $payloadPath -Force -ErrorAction Ignore
    }
}
