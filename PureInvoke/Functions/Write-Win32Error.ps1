
function Write-Win32Error
{
    [CmdletBinding()]
    param(
        [String] $Message
    )

    Set-StrictMode -Version 'Latest'
    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    if ($Message)
    {
        $Message.TrimEnd('.')
        $Message = "${Message}: "
    }

    $win32Ex = [Win32Exception]::New()
    $msg = "${Message}$($win32Ex.Message) (0x$($win32Ex.ErrorCode.ToString('x'))/$($win32Ex.NativeErrorCode))."
    Write-Error -Message $msg -ErrorAction $ErrorActionPreference
}