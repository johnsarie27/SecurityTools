#Requires -Modules Pester

Import-Module -Name $PSScriptRoot\..\UtilityFunctions.psd1 -Force

Describe -Name "Write-Log" -Fixture {
    Context -Name "parameter set initialize" -Fixture {
        BeforeEach { $LogDir = "TestDrive:\Logs" }
        AfterEach { Remove-Item -Path $LogDir -Recurse -Force }

        It -Name "creates daily log file" -Test {
            Write-Log -Directory $LogDir -Name Test
            $FileName = 'TestDrive:\Logs\Test-Log_{0}.log' -f (Get-Date -F "yyyy-MM-dd")
            Test-Path -Path $FileName | Should -BeTrue
        }

        It -Name "adds an initial log entry" -Test {
            $FileName = Write-Log -Directory $LogDir -Name Test
            Get-Content -Path $FileName | Should -Match 'Begin\sLogging'
        }
    }

    Context -Name "parameter set log" -Fixture {
        It -Name "adds log entry" -Test {
            Write-Log -Path $FileName -Message 'Pester test 123'
            Get-Content -Path $FileName | Select-Object -Last 1 | Should -Match 'test\s123'
        }

        It -Name "creates a timestamp for entry" -Test {
            Write-Log -Path $FileName -Message 'Add time stamp'
            $line = Get-Content -Path $FileName | Select-Object -Last 1
            $DateString = $line.Substring(0, 19) -replace "_", " "
            [System.DateTime]::Parse($DateString) | Should -BeTrue
        }

        BeforeAll {
            $LogDir = "TestDrive:\Logs"
            $FileName = Write-Log -Directory $LogDir -Name Test
        }

        AfterAll {
            Remove-Item -Path $LogDir -Recurse -Force
        }
    }
}