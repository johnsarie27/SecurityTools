@{
    ExcludeRules = @(
        'PSAvoidGlobalVars'
        'PSAvoidUsingConvertToSecureStringWithPlainText'
    )

    Severity     = @(
        'Warning',
        'Error'
    )

    Rules        = @{}
}
