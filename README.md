# PureInvoke PowerShell Module README

## Overview

The "PureInvoke" module is a wrapper around Win32 APIs. It attempts to hide the complexities of such calls from callers.
The majority of its implementation is in pure PowerShell with a minimum amount in a compiled .NET assembly.

## System Requirements

* Windows PowerShell 5.1 and .NET 4.6.1+
* PowerShell 6+ on Windows

## Installing

To install globally:

```powershell
Install-Module -Name 'PureInvoke'
Import-Module -Name 'PureInvoke'
```

To install privately:

```powershell
Save-Module -Name 'PureInvoke' -Path '.'
Import-Module -Name '.\PureInvoke'
```

## Usage

Although some of the module's code is compiled into a .NET assembly, the assembly's types and implementation should be
considered private and not used. Only the exported PowerShell functions from this module are considered public.

## Commands

### From advapi32.dll

* `LookupAccountName`: `Invoke-AdvApiLookupAccountName`
* `LookupAccountSid`: `Invoke-AdvApiLookupAccountSid`
* `LsaAddAccountRights`: `Invoke-AdvApiLsaAddAccountRights`
* `LsaClose`: `Invoke-AdvApiLsaClose`
* `LsaEnumerateAccountRights`: `Invoke-AdvApiLsaEnumerateAccountRights`
* `LsaFreeMemory`: `Invoke-AdvApiLsaFreeMemory`
* `LsaNtStatusToWinError`: `Invoke-AdvApiLsaNtStatusToWinError`
* `LsaOpenPolicy`: `Invoke-AdvApiLsaOpenPolicy`
* `LsaRemoveAccountRights`: `Invoke-AdvApiLsaRemoveAccountRights`

### From kernel32.dll

* `Invoke-KernelFindFileName`
* `Invoke-KernelGetVolumePathName`
