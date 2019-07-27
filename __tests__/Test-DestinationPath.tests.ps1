#Requires -Modules Pester

. $PSScriptRoot\..\Test-DestinationPath.ps1

Describe -Name "Test-DestinationPath" -Fixture {
    Context -Name "acceptable scenarios" -Fixture {
        It -Name "accepts new file path with extension" -Test {
            Test-DestinationPath -Path $Path\file.xml -Extension '.xml' | Should -BeOfType System.String
        }
        It -Name "accepts new file path without extension" -Test {
            Test-DestinationPath -Path $Path\file -Extension '.xml' | Should -BeOfType System.String
        }
        It -Name "accepts filename only with extension" -Test {
            Test-DestinationPath -Path file.xml -Extension '.xml' | Should -BeOfType System.String
        }
        It -Name "accepts filename only without extension" -Test {
            Test-DestinationPath -Path file -Extension '.xml' | Should -BeOfType System.String
        }
        It -Name "accepts existing file path without read-only attribute" -Test {
            New-Item -Path $Path\test.xml -ItemType File -Force
            { Test-DestinationPath -Path $Path\test.xml -Extension '.xml' -AllowOverwrite } | Should -Not -Throw
            Remove-Item -Path $Path\test.xml -Force
        }
        It -Name "allows directory only as filename" -Test {
            # shouldn't this just name the zip file the folder name?
            # EX) C:\Users\jjohns\Desktop\MyFolder >> ...\MyFolder.zip
            $a = Test-DestinationPath -Path $Path -Extension '.xml'
            $file = New-Item -Path TestDrive:\FolderOne.xml -ItemType File -Force
            $a -and $file | Should -BeTrue
        }
    }

    Context -Name "rejected scenarios" -Fixture {
        It -Name "rejects existing file path with extension" -Test {
            { Test-DestinationPath -Path $Path\test.xml -Extension '.xml' } | Should -Throw
        }
        It -Name "rejects existing file path without extension" -Test {
            { Test-DestinationPath -Path $Path\test -Extension '.xml' } | Should -Throw
        }
        It -Name "rejects non-existent destination folder" -Test {
            { Test-DestinationPath -Path $Path\FolderTwo\test.xml -Extension '.xml' } | Should -Throw
        }
        It -Name "rejects existing read-only file" -Test {
            Set-ItemProperty -Path $Path\test.xml -Name IsReadOnly -Value $true
            { Test-DestinationPath -Path $Path\test.xml -Extension '.xml' -Force } | Should -Throw
        }

        BeforeAll {
            New-Item -Path $Path\test.xml -ItemType File -Force
        }
    }

    BeforeAll {
        $Path = "TestDrive:\FolderOne"
        New-Item -Path $Path -ItemType Container -Force
    }
    AfterAll {
        Remove-Item -Path $Path -Recurse -Force
    }
}