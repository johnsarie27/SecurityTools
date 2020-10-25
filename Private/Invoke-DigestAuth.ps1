#Requires -Version 5.1

function Invoke-DigestAuth {
    <# =========================================================================
    .SYNOPSIS
        Invoke web digest authentication
    .DESCRIPTION
        Invoke web digest authentication
    .PARAMETER Uri
        Target URI
    .PARAMETER Credential
        PS Credential Object
    .INPUTS
        None.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> Invoke-DigestAuthentication -Uri https://myWebSite/path/to/somewhere -Credential $c
        Get content from the provided Uri using the credentials $c
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target URI')]
        [System.Uri] $Uri,

        [Parameter(Mandatory, HelpMessage = 'Credential object')]
        [pscredential] $Credential
    )

    Begin {
        function Get-Md5Hash ([string] $String) {
            # THE TYPE COULD BE CHANGED FROM ASCII TO UTF8 OR UNICODE DEPENDING
            # ON THE STRING INPUT
            $inputBytes = [System.Text.Encoding]::ASCII.GetBytes($String)

            $algorithm = [System.Security.Cryptography.MD5]::Create()
            $stringBuilder = New-Object System.Text.StringBuilder

            $algorithm.ComputeHash($inputBytes) | ForEach-Object -Process {
                # APPENDING TO THE STRING BUILDER PRINTS TO THE CONSOLE
                # THE VOID REMOVES THAT CONSOLE OUTPUT
                [void] $stringBuilder.Append($_.ToString("x2"))
            }

            $StringBuilder.ToString()
        }

        function Get-HeaderVariable ([string] $VariableName, [string] $Header) {
            $regex = '{0}=\"([^""]*)\"' -f $VariableName
            $match = Select-String -InputObject $Header -Pattern $regex
            if ( $match ) {
                $match.Matches.Groups[1].Value
            }
            else {
                Write-Warning -Message ('Header {0} not found' -f $VariableName)
            }
        }

        function Get-DigestHeader ([hashtable] $Tokens) {
            $Tokens['nc']++

            $ha1 = Get-Md5Hash -String ('{0}:{1}:{2}' -f $Tokens['un'], $Tokens['realm'], $Tokens['pw'])
            $ha2 = Get-Md5Hash -String ('GET:{0}' -f $Tokens['uri'].PathAndQuery)

            $digestString = '{0}:{1}:{2:00000000}:{3}:{4}:{5}' -f $ha1, $Tokens['nonce'], $Tokens['nc'], $Tokens['cnonce'], $Tokens['qop'], $ha2
            $digestResponse = Get-Md5Hash -String $digestString

            Write-Verbose -Message ('1st Hash: {0}' -f $ha1)
            Write-Verbose -Message ('2nd Hash: {0}' -f $ha2)
            Write-Verbose -Message ('Response: {0}' -f $digestResponse)

            $vars = @(
                $Tokens['un']
                $Tokens['realm']
                $Tokens['nonce']
                $Tokens['dir']
                'MD5'
                $digestResponse
                $Tokens['qop']
                $Tokens['nc']
                $Tokens['cnonce']
            )

            $headerString = 'Digest username="{0}", realm="{1}", nonce="{2}", uri="{3}", algorithm={4}, response="{5}", qop={6}, nc={7:00000000}, cnonce="{8}"'
            $headerString -f $vars
        }
    }

    Process {
        # EXECUTION MAIN
        $request = [System.Net.HttpWebRequest]::Create($Uri)

        try {
            $response = $request.GetResponse()
        }
        catch {
            $failResponce = $_.Exception.InnerException.Response
            if ( !$failResponce ) {
                Write-Error -Message 'Failed to communicate with server'
            }
            else {
                $headerParam = @{ Header = $failResponce.Headers['WWW-Authenticate'] }

                $authParams = @{
                    un     = $Credential.UserName
                    pw     = $Credential.GetNetworkCredential().Password
                    realm  = Get-HeaderVariable -VariableName "realm" @headerParam
                    nonce  = Get-HeaderVariable -VariableName "nonce" @headerParam
                    dir    = $Uri.PathAndQuery
                    qop    = Get-HeaderVariable -VariableName "qop" @headerParam
                    nc     = 0
                    cnonce = (Get-Random -Minimum 123400 -Maximum 9999999).ToString()
                    uri    = $Uri
                }

                $request2 = [System.Net.HttpWebRequest]::Create($Uri)
                $digestHeader = Get-DigestHeader -Tokens $authParams #-Verbose

                $request2.Headers.Add("Authorization", $digestHeader)
                $response = $request2.GetResponse()
            }
        }

        $sr = [System.IO.StreamReader]::New($response.GetResponseStream())
        $sr.ReadToEnd()
    }
}