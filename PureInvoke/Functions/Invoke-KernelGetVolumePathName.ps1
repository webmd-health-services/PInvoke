
function Invoke-KernelGetVolumePathName
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String] $Path
    )

    Set-StrictMode -Version 'Latest'
    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    [Marshal]::SetLastPInvokeError([PureInvoke.ErrorCode]::Ok)
    [Marshal]::SetLastSystemError([PureInvoke.ErrorCode]::Ok)
    # Need to call GetFullPathName to get the size of the necessary buffer.
    $sbPath = [Text.StringBuilder]::New([PureInvoke.Kernel32]::MAX_PATH)
    $cchPath = [UInt32]$sbPath.Capacity; # in/out character-count variable for the WinAPI calls.
    # Get the volume (drive) part of the target file's full path (e.g., @"C:\")
    $result = [PureInvoke.Kernel32]::GetVolumePathName($Path, $sbPath, $cchPath)
    [PureInvoke.ErrorCode] $errCode = [Marshal]::GetLastWin32Error()
    $msg = "[Kernel32]::GetVolumePathName(""${Path}"", ""${sbPath}"", ${cchPath})  return ${result}  " +
           "GetLastError() ${errCode}"
    Write-Debug $msg
    if (-not $result)
    {
        Write-Win32Error -ErrorCode $errCode
        return
    }

    return $sbPath.ToString()
}