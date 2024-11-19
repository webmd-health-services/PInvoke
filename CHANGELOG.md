
# PureInvoke PowerShell Module Changelog

## 1.0.1

Fixed: strange error messages when multiple instances of PureInvoke are imported. Tried to do shenanigans where the
module always used the assembly from the module, but PowerShell had other ideas.

## 1.0.0

> Released 18 Nov 2024

* Created `Invoke-AdvApiLookupAccountName` function to call the advapi32.dll library's `LookupAccountName` function.
* Created `Invoke-AdvApiLookupAccountSid` function to call the advapi32.dll library's `LookupAccountSid` function.
* Created `Invoke-AdvApiLookupPrivilegeName` function to call the advapi32.dll library's `LookupPrivilegeName` function.
* Created `Invoke-AdvApiLookupPrivilegeValue` function to call the advapi32.dll library's `LookupPrivilegeValue`
  function.
* Created `Invoke-AdvApiLsaAddAccountRights` function to call the advapi32.dll library's `LsaAddAccountRights` function.
* Created `Invoke-AdvApiLsaClose` function to call the advapi32.dll library's `LsaClose` function.
* Created `Invoke-AdvApiLsaEnumerateAccountRights` function to call the advapi32.dll library's
  `LsaEnumerateAccountRights` function.
* Created `Invoke-AdvApiLsaFreeMemory` function to call the advapi32.dll library's `LsaFreeMemory` function.
* Created `Invoke-AdvApiLsaNtStatusToWinError` function to call the advapi32.dll library's `LsaNtStatusToWinError`
  function.
* Created `Invoke-AdvApiLsaOpenPolicy` function to call the advapi32.dll library's `LsaOpenPolicy` function.
* Created `Invoke-AdvApiLsaRemoveAccountRights` function to call the advapi32.dll library's `LsaRemoveAccountRights`
  function.
* Created `Invoke-KernelFindFileName` to call the kernel32.dll library's `FindFirstFileNameW` and `FindNextFileNameW`
  functions to find all the hardlinks to a file.
* Created `Invoke-KernelGetVolumePathName` to call the kerndel32.dll library's `GetVolumePathName` function, which gets
  the volume mount point for a file.
* Created `Invoke-NetApiNetLocalGroupGetMembers` to call the netapi32.dll library's `NetLocalGroupGetMembers` function.
