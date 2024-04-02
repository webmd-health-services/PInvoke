
function ConvertTo-IntPtr
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [SecurityIdentifier] $Sid
    )

    Set-StrictMode -Version 'Latest'
    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    $sidBytes = [byte[]]::New($Sid.BinaryLength)
    $sid.GetBinaryForm($sidBytes, 0);
    $sidPtr = [Marshal]::AllocHGlobal($sidBytes.Length)
    [Marshal]::Copy($sidBytes, 0, $sidPtr, $sidBytes.Length)
    return $sidPtr

}