
function Invoke-AdvApiLookupAccountName
{
    <#
    .SYNOPSIS
    Calls the Advanced Windows 32 Base API (advapi32.dll) `LookupAccountName` function.

    .DESCRIPTION
    The `Invoke-AdvApiLookupAccountName` function calls the advapi32.dll API's `LookupAccountName` function, which looks up
    an account name and returns its domain, SID, and use. Pass the account name to the `AccountName` parameter and the
    system name to the `SystemName` parameter, which are passed to `LookupAccountName` as the `lpAccountName` and
    `lpSystemName` arguments, respectively. The function returns an object with properties for each of the
    `LookupAccountName` function's out parameters: `ReferencedDomainName`, `Sid`, and `Use`.

    .LINK
    https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-lookupaccountnamea

    .EXAMPLE
    Invoke-AdvApiLookupAccountName -AccountName ([Environment]::UserName)

    Demonstrates how to call this function by passing a username to the `AccountName` parameter.
    #>
    [CmdletBinding()]
    param(
        # The name of the system.
        [String] $SystemName,

        # The account name to lookup.
        [Parameter(Mandatory)]
        [String] $AccountName
    )

    Set-StrictMode -Version 'Latest'
    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    $result = [pscustomobject]@{
        ReferencedDomainName = '';
        Sid = [byte[]]::New(0);
        Use = [SidNameUse]::Unknown
    }

    [byte[]] $sid = [byte[]]::New(0);

    # cb = count of bytes
    [UInt32] $cbSid = 0;
    [StringBuilder] $domainName = [StringBuilder]::New()
    # cch = count of chars
    [UInt32] $cchDomainName = $domainName.Capacity;
    [SidNameUse] $sidNameUse = [SidNameUse]::Unknown;

    [PureInvoke.ErrorCode]$errCode = [PureInvoke.ErrorCode]::Ok
    $result = [AdvApi32]::LookupAccountName($SystemName, $AccountName, $sid, [ref] $cbSid, $domainName,
                                            [ref] $cchDomainName, [ref]$sidNameUse)
    $errCode = [Marshal]::GetLastWin32Error()
    if ($result)
    {
        Write-Win32Error -ErrorCode $errCode
        return
    }

    if ($errCode -eq [ErrorCode]::InsufficientBuffer -or $errCode -eq [ErrorCode]::InvalidFlags)
    {
        $sid = [byte[]]::New($cbSid);
        [void]$domainName.EnsureCapacity([int]$cchDomainName);
        $result = [AdvApi32]::LookupAccountName($SystemName, $AccountName, $sid, [ref] $cbSid, $domainName,
                                                [ref] $cchDomainName, [ref] $sidNameUse)
        $errCode = [Marshal]::GetLastWin32Error()
        if (-not $result)
        {
            Write-Win32Error -ErrorCode $errCode
            return
        }
    }
    else
    {
        Write-Win32Error -ErrorCode $errCode
        return
    }

    $result.ReferencedDomainName = $domainName.ToString()
    $result.Sid = $sid
    $result.Use = $sidNameUse

    return $result
}