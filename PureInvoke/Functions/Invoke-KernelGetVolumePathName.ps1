
function Invoke-KernelGetVolumePathName
{
    <#
    .SYNOPSIS
    Calls the kernel32.dll libary's `GetVolumePathName` function.

    .DESCRIPTION
    The `Invoke-KernelGetVolumePathName` function calls the kernel32.dll libary's `GetVolumePathName` function which
    gets the volume mount point of the path. Pass the path to the `Path` parameter.

    .EXAMPLE
    Invoke-KernelGetVolumePathName -Path $path

    Demonstrates how to call this function.
    #>
    [CmdletBinding()]
    param(
        # The path whose volume mount point to get.
        [Parameter(Mandatory)]
        [String] $Path
    )

    Set-StrictMode -Version 'Latest'
    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    # Need to call GetFullPathName to get the size of the necessary buffer.
    $sbPath = [Text.StringBuilder]::New([PureInvoke.Kernel32]::MAX_PATH)
    $cchPath = [UInt32]$sbPath.Capacity; # in/out character-count variable for the WinAPI calls.
    $result = [PureInvoke.Kernel32]::GetVolumePathName($Path, $sbPath, $cchPath)
    # Get the volume (drive) part of the target file's full path (e.g., @"C:\")
    $errCode = [Marshal]::GetLastWin32Error()
    $msg = "[Kernel32]::GetVolumePathName(""${Path}"", [out] ""${sbPath}"", ${cchPath})  return ${result}  " +
           "GetLastError() ${errCode}"
    Write-Debug $msg
    if (-not $result -and -not (Assert-Win32Error -ErrorCode $errCode))
    {
        return
    }

    return $sbPath.ToString()
}