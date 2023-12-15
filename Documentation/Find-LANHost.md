# Find-LANHost

## SYNOPSIS
Find LAN hosts

## SYNTAX

```
Find-LANHost [-IP] <String[]> [[-DelayMS] <Int32>] [-ClearARPCache] [<CommonParameters>]
```

## DESCRIPTION
Find LAN hosts

## EXAMPLES

### EXAMPLE 1
```
$ips = 1..254 | % {"10.250.1.$_"}; Find-LANHost -IP $ips
Explanation of what the example does
```

## PARAMETERS

### -IP
IP addresses to scan

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DelayMS
Delay in milliseconds between packet send

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 2
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClearARPCache
Clear ARP cache before scanning

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
https://xkln.net/blog/layer-2-host-discovery-with-powershell-in-under-a-second/

## RELATED LINKS
