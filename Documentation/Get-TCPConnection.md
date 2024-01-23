# Get-TCPConnection

## SYNOPSIS
Get Windows processes with open network connections

## SYNTAX

```
Get-TCPConnection [[-ComputerName] <String>] [<CommonParameters>]
```

## DESCRIPTION
Query Windows processes and display open connections

## EXAMPLES

### EXAMPLE 1
```
Get-TCPConnection.ps1 -ComputerName MyServer
```

## PARAMETERS

### -ComputerName
Hostname of remote system from which to pull logs.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name, Computer, Host, HostName, CN

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String.
## OUTPUTS

### System.Object[].
## NOTES
This assumes that the identity executing the function has permissions
to run the cmdlet Get-NetTCPConnection on the remote system when using
the ComputerName parameter.

## RELATED LINKS
