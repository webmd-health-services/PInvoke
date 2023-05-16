
function Invoke-AdvapiLookupAccountSid
{
    <#
    .SYNOPSIS
    Calls the Advanced Windows 32 Base API (advapi32.dll) `LookupAccountSid` function.

    .DESCRIPTION
    The `Invoke-AdvapiLookupAccountSid` function calls the advapi32.dll API's `LookupAccountSid` function, which looks up a
    SID and returns its account name, domain name, and use. Pass the SID as a byte array to the `Sid` parameter and the
    system name to the `SystemName` parameter, which are passed to `LookupAccountSid` as the `Sid` and `lpSystemName`
    arguments, respectively. The function returns an object with properties for each of the `LookupAccountSid`
    function's out parameters: `Name`, `ReferencedDomainName`, and `Use`.

    .LINK
    https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-lookupaccountsida

    .EXAMPLE
    Invoke-AdvapiLookupAccountSid -Sid $sid

    Demonstrates how to call this function by passing a sid to the `Sid` parameter.
    #>
    [CmdletBinding()]
    param(
        [String] $SystemName,

        [Parameter(Mandatory)]
        [byte[]] $Sid
    )

    Set-StrictMode -Version 'Latest'
    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    $result = [pscustomobject]@{
        Name = '';
        ReferencedDomainName = ''
        Use = [PureInvoke.AdvApi32+SidNameUse]::Unknown
    }

    [Text.StringBuilder] $name = [Text.StringBuilder]::New()
    # cch = count of chars
    [UInt32] $cchName = $name.Capacity;

    [Text.StringBuilder] $domainName = [Text.StringBuilder]::New()
    [UInt32] $cchDomainName = $domainName.Capacity;

    [PureInvoke.AdvApi32+SidNameUse] $sidNameUse = [PureInvoke.AdvApi32+SidNameUse]::Unknown;

    [PureInvoke.ErrorCode] $errCode = [PureInvoke.ErrorCode]::Ok

    $result = [PureInvoke.AdvApi32]::LookupAccountSid($SystemName, $sid, $name, [ref] $cchName,
                                                   $domainName, [ref] $cchDomainName, [ref] $sidNameUse)
    $errCode = [Marshal]::GetLastWin32Error()
    if (-not $result -and ($errCode -eq [PureInvoke.ErrorCode]::InsufficientBuffer))
    {
        [void]$name.EnsureCapacity($cchName);
        [void]$domainName.EnsureCapacity($cchName);
        $result = [PureInvoke.AdvApi32]::LookupAccountSid($SystemName, $sid,  $name, [ref] $cchName,
                                                            $domainName, $cchDomainName, [ref] $sidNameUse)
        $errCode = [Marshal]::GetLastWin32Error()
        if (-not $result)
        {
            Write-Win32Error -ErrorCode $errCode
            return
        }
    }

    if ($errCode)
    {
        Write-Win32Error -ErrorCode $errCode
        return
    }

    $result.ReferencedDomainName = $domainName.ToString()
    $result.Name = $name.ToString()
    $result.Use = $sidNameUse

    return $result
}