
function Invoke-AdvApiLsaOpenPolicy
{
    <#
    .SYNOPSIS
    Calls the advapi32.dll library's `LsaOpenPolicy` function to open a handle to a computer's LSA policy.

    .DESCRIPTION
    The `Invoke-AdvApiLsaOpenPolicy` function calls the advapi32.dll library's `LsaOpenPolicy` function to open a handle
    to a computer's LSA policy. Pass the desired access to the `DesiredAccess` parameter. The function returns a handle
    to the policy if opening succeeds or, if opening fails, returns nothing and writes an error.

    You can open the LSA policy on a different computer by passing the computer's name to the `ComputerName` parameter.

    .EXAMPLE
    Invoke-AdvApiLsaOpenPolicy -DesiredAccess LookupNames,CreateAccount

    Demonstrates how to open a policy handle that allows reading and setting privileges.
    #>
    [CmdletBinding()]
    param(
        # The optional computer name whose LSA policy to open. The default is the local computer.
        [String] $ComputerName,

        # The value of the `LsaOpenPolicy` method's `ObjectAttribute` parameter.
        [LSA_OBJECT_ATTRIBUTES] $ObjectAttribute,

        # The desired access for the policy handle. See the documentation for the LSA function/method the policy will
        # be used with to discover what rights are needed.
        [Parameter(Mandatory)]
        [PolicyAccessRights] $DesiredAccess
    )

    Set-StrictMode -Version 'Latest'
    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    $lsaSystemName = [LSA_UNICODE_STRING]::New([Environment]::MachineName)
    if ($ComputerName)
    {
        $lsaSystemName = [LSA_UNICODE_STRING]::New($ComputerName)
    }

    if (-not $ObjectAttribute)
    {
        $ObjectAttribute = [PureInvoke.LsaLookup.LSA_OBJECT_ATTRIBUTES]::New()
        $ObjectAttribute.Length = 0
        $ObjectAttribute.RootDirectory = [IntPtr]::Zero
        $ObjectAttribute.Attributes = 0
        $ObjectAttribute.SecurityDescriptor = [IntPtr]::Zero
        $ObjectAttribute.SecurityQualityOfService = [IntPtr]::Zero
    }

    $policyHandle = [IntPtr]::Zero

    $ntstatus =
        [PureInvoke.AdvApi32]::LsaOpenPolicy([ref] $lsaSystemName, [ref] $ObjectAttribute, $DesiredAccess, [ref] $policyHandle)

    if (-not (Assert-NtStatusSuccess -Status $ntstatus -Message "Invoke-AdvApiLsaOpenPolicy failed"))
    {
        return
    }

    return $policyHandle
}