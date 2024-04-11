
function Assert-Win32Error
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [int] $ErrorCode,

        [String] $Message
    )

    Set-StrictMode -Version 'Latest'
    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    if ($ErrorCode -eq 0x0)
    {
        return $true
    }

    Write-Win32Error -ErrorCode $ErrorCode -Message $Message
    return $false
}