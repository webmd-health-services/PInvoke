
function Assert-NTStatusSuccess
{
    [CmdletBinding()]
    param(
        [UInt32] $Status,

        [String] $Message
    )

    Set-StrictMode -Version 'Latest'
    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    # https://learn.microsoft.com/en-us/windows-hardware/drivers/kernel/using-ntstatus-values
    if ($Status -le 0x3FFFFFFF -or ($Status -ge 0x40000000 -and $Status -le 0x7FFFFFFF))
    {
        return $true
    }

    $win32Err = Invoke-AdvApiLsaNtStatusToWinError -Status $ntstatus
    Write-Win32Error -ErrorCode $win32Err -Message $Message
    return $false
}