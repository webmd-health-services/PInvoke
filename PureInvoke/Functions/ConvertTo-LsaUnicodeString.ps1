
function ConvertTo-LsaUnicodeString
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [String] $InputObject
    )

    process
    {
        Set-StrictMode -Version 'Latest'
        Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

        [LSA_UNICODE_STRING]::New($InputObject) | Write-Output
    }
}