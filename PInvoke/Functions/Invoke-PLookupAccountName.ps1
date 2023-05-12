
function Invoke-PLookupAccountName
{
    <#
    .SYNOPSIS
    Calls the Advanced Windows 32 Base API (advapi32.dll) `LookupAccountName` function.

    .DESCRIPTION
    The `Invoke-PLookupAccountName` function calls the advapi32.dll API's `LookupAccountName` function, which looks up
    an account name and returns its domain, SID, and use. Pass the account name to the `AccountName` parameter and the
    system name to the `SystemName` parameter, which are passed to `LookupAccountName` as the `lpAccountName` and
    `lpSystemName` arguments, respectively. The function returns an object with properties for each of the
    `LookupAccountName` function's out parameters: `ReferencedDomainName`, `Sid`, and `Use`.

    .LINK
    https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-lookupaccountnamea

    .EXAMPLE
    Invoke-PLookupAccountName -AccountName ([Environment]::UserName)

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
        Use = [PInvoke.AdvApi32+SidNameUse]::Unknown
    }

    [byte[]] $sid = [byte[]]::New(0);

    # cb = count of bytes
    [UInt32] $cbSid = 0;
    [Text.StringBuilder] $domainName = [Text.StringBuilder]::New()
    # cch = count of chars
    [UInt32] $cchDomainName = $domainName.Capacity;
    [PInvoke.AdvApi32+SidNameUse] $sidNameUse = [PInvoke.AdvApi32+SidNameUse]::Unknown;

    $err = [PInvoke.WinError]::Ok
    if ([PInvoke.AdvApi32]::LookupAccountName($SystemName, $AccountName,
                                              $sid, [ref] $cbSid,
                                              $domainName, [ref] $cchDomainName,
                                              [ref]$sidNameUse))
    {
        Write-PWin32Error
        return
    }

    $err = [Marshal]::GetLastWin32Error();
    if ($err -eq [PInvoke.WinError]::InsufficientBuffer -or $err -eq [PInvoke.WinError]::InvalidFlags)
    {
        $sid = [byte[]]::New($cbSid);
        [void]$domainName.EnsureCapacity([int]$cchDomainName);
        if (-not [PInvoke.AdvApi32]::LookupAccountName($SystemName, $AccountName, $sid, [ref] $cbSid,
                                                       $domainName, [ref] $cchDomainName,
                                                       [ref] $sidNameUse))
        {
            Write-PWin32Error
            return
        }
    }
    else
    {
        Write-PWin32Error
        return
    }

    $result.ReferencedDomainName = $domainName.ToString()
    $result.Sid = $sid
    $result.Use = $sidNameUse

    return $result
}