BeforeDiscovery {
    # Taken with love from @juneb_get_help (https://raw.githubusercontent.com/juneb/PesterTDD/master/Module.Help.Tests.ps1)
    # Import module
    if (-not (Get-Module -Name $env:BHProjectName -ListAvailable)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
    $Cmdlets = Get-Command -Module $env:BHProjectName -CommandType 'Cmdlet', 'Function' -ErrorAction 'Stop'
}

Describe '<_> help' -ForEach $Cmdlets {
    BeforeDiscovery {
        $Common = 'Debug', 'ErrorAction', 'ErrorVariable', 'InformationAction', 'InformationVariable', 'OutBuffer', 'OutVariable', 'PipelineVariable', 'Verbose', 'WarningAction', 'WarningVariable', 'Confirm', 'Whatif'

        $Command = $_ # Get current from -ForEach $Cmdlets in discovery-phase
        $CommandParameters = $Command.ParameterSets.Parameters | Sort-Object -Property Name -Unique | Where-Object { $_.Name -notin $Common } | Select-Object Name
        $CommandParameterNames = $CommandParameters.Name
    }
    BeforeAll {
        $Common = 'Debug', 'ErrorAction', 'ErrorVariable', 'InformationAction', 'InformationVariable', 'OutBuffer', 'OutVariable', 'PipelineVariable', 'Verbose', 'WarningAction', 'WarningVariable', 'Confirm', 'Whatif'

        $Command = $_ # Get current from -ForEach $Cmdlets in run-phase
        $CommandParameters = $Command.ParameterSets.Parameters | Sort-Object -Property Name -Unique | Where-Object { $_.Name -notin $Common }# | Select-Object Name
        $CommandParameterNames = $CommandParameters.Name

        $Help = Get-Help $Command -ErrorAction SilentlyContinue
        $HelpParameters = $Help.Parameters.Parameter | Where-Object { $_.Name -notin $Common } | Sort-Object -Property Name -Unique
        $HelpParameterNames = $HelpParameters.Name
    }

    # If help is not found, synopsis in auto-generated help is the syntax diagram
    It 'Should not be auto-generated' {
        $Help.Synopsis | Should -Not -Contain 'CommonParameters'
    }

    # Should be a description for every function
    It 'Should have a description' {
        $Help.Description | Should -Not -BeNullOrEmpty
    }

    # Should be at least one example
    It 'Should have at least one example' {
        ($Help.Examples.Example | Select-Object -First 1).Code | Should -Not -BeNullOrEmpty
    }

    # Should be a valid link
    It 'Should have valid link response' {
        if ($Help.relatedLinks.navigationLink.uri) {
            $Results = Invoke-WebRequest -Uri $Help.relatedLinks.navigationLink.uri -UseBasicParsing
            $Results.StatusCode | Should -Be '200'
        }
    }

    # Should be a description for every parameter
    It 'Should have description for parameter: <_>' -ForEach $CommandParameterNames {
        $CommandParameterName = $_
        $ParameterHelp = $HelpParameters | Where-Object { $_.Name -ieq $CommandParameterName }
        $ParameterHelp.Description.Text | Should -Not -BeNullOrEmpty
    }

    # Required value in Help should match IsMandatory property of parameter
    It 'Should have correct mandatory value for parameter: <_>' -ForEach $CommandParameterNames {
        $CommandParameterName = $_
        $ParameterHelp = $HelpParameters | Where-Object { $_.Name -ieq $CommandParameterName }
        $CodeMandatory = ($Command.ParameterSets.Parameters | Sort-Object -Property Name -Unique | Where-Object { $_.Name -ieq $CommandParameterName }).IsMandatory.toString()
        $ParameterHelp.Required | Should -Be $CodeMandatory
    }

    # Shouldn't find extra parameters in help
    It 'Should have matching help for parameter: <_>' -ForEach $HelpParameterNames {
        $HelpParameterName = $_
        $HelpParameterName -in $CommandParameterNames | Should -Be $true
    }
}
