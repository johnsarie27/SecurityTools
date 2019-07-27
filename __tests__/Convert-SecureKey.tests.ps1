#Requires -Modules Pester

Import-Module -Name $PSScriptRoot\..\UtilityFunctions.psd1 -Force

Describe -Name "Convert-SecureKey" -Fixture {
    Context -Name "'create' parameter set" -Fixture {
        It -Name "should not fail" -Test {
            { Convert-SecureKey -DestinationPath $Path -Username 'user' -SecurePassword $SecurePW -PassThru } |
            Should -Not -Throw
        }
        It -Name "creates an XML file" -Test {
            Convert-SecureKey -DestinationPath $Path -Username 'user' -SecurePassword $SecurePW
            ( Test-Path -Path $Path -PathType Leaf -Include "*.xml" ) | Should -BeTrue
        }
        It -Name "xml file contains PSCredential object" -Test {
            Convert-SecureKey -DestinationPath $Path -Username 'user' -SecurePassword $SecurePW
            $Creds = Import-Clixml -Path $Path
            $Creds.GetType().Name | Should -Be 'PSCredential'
        }
        AfterEach {
            Remove-Item -Path $Path
        }
    }

    Context -Name "'retrieve' parameter set" -Fixture {
        It -Name "should not fail" -Test {
            { Convert-SecureKey -Path $Path } | Should -Not -Throw
        }
        It -Name "returns a PSCredential object" -Test {
            (Convert-SecureKey -Path $Path).GetType().Name | Should -Be 'PSCredential'
        }
        BeforeAll {
            Convert-SecureKey -DestinationPath $Path -Username 'user' -SecurePassword $SecurePW -PassThru
        }
    }

    BeforeAll {
        New-Item -Path TestDrive:\Temp -ItemType Directory
        $Path = "TestDrive:\Temp.xml"
        $SecurePW = ConvertTo-SecureString -String 'SuperPassword123' -AsPlainText -Force
    }
}