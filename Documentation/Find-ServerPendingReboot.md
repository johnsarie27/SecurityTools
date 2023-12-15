# Find-ServerPendingReboot

## SYNOPSIS
Check if a server is pending reboot

## SYNTAX

```
Find-ServerPendingReboot [[-ComputerName] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Check if a server is pending reboot

## EXAMPLES

### EXAMPLE 1
```
C:\Script\FindServerIsPendingReboot.ps1 -ComputerName "WIN-VU0S8","WIN-FJ6FH","WIN-FJDSH","WIN-FG3FH"
```

ComputerName                                          RebootIsPending
------------                                          ---------------
WIN-VU0S8                                             False
WIN-FJ6FH                                             True
WIN-FJDSH                                             True
WIN-FG3FH                                             True

This command will get the reboot status on the specified remote computers.

## PARAMETERS

### -ComputerName
Gets the server reboot status on the specified computer.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: CN

Required: False
Position: 1
Default value: $env:COMPUTERNAME
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
This script was taken from the site listed below.
I've made several
modifications including formatting for ease of reading.

https://gallery.technet.microsoft.com/scriptcenter/How-to-check-if-any-4b1e53f2

## RELATED LINKS
