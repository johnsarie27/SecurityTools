# Invoke-NetScan

## SYNOPSIS
Scan for active hosts

## SYNTAX

```
Invoke-NetScan [-IP] <String[]> [-ResolveHostname] [<CommonParameters>]
```

## DESCRIPTION
Scan for active hosts and provide limited details on each

## EXAMPLES

### EXAMPLE 1
```
$ips = Get-IPNetwork -IPAddress 192.168.1.0 -PrefixLength 24 -ReturnAllIPs
PS C:\> $hosts = Invoke-NetScan -IP $ips.AllIPs -ResolveHostname
Get all IP's on the network 192.168.1.0 and scan for active hosts including hostname info
```

## PARAMETERS

### -IP
IP addresses to scan

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResolveHostname
Attempt to resolve hostname

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### none.
## OUTPUTS

### System.Object.
## NOTES
General notes

## RELATED LINKS
