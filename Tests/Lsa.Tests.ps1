
using namespace System.Security.Principal

#Requires -RunAsAdministrator
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

BeforeAll {
    Set-StrictMode -Version 'Latest'

    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

    Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath '..\PSModules\Carbon' -Resolve) `
                  -Function @('Install-CUser') `
                  -Verbose:$false

    $password = ConvertTo-SecureString -String 'T2-pFZdq-@M2' -AsPlainText -Force
    $script:credential = [pscredential]::New('PILsa', $password)
    Install-CUser -Credential $credential -Description 'User used to test PureInvoke LSA functions.'
}

Describe 'PureInvoke.Lsa' {
    BeforeEach {
        $Global:Error.Clear()
    }

    It 'opens policy, grants priveleges, enumerates privileges, revokes priveleges, and closes policy' {
        $policy = Invoke-AdvApiLsaOpenPolicy -DesiredAccess LookupNames,CreateAccount
        $Global:Error | Should -BeNullOrEmpty
        $policy | Should -Not -BeNullOrEmpty

        $sid = [NTAccount]::New($script:credential.UserName).Translate([SecurityIdentifier])

        Invoke-AdvApiLsaRemoveAccountRights -PolicyHandle $policy -Sid $sid -All | Should -BeTrue
        $Global:Error | Should -BeNullOrEmpty

        $rights = Invoke-AdvApiLsaEnumerateAccountRights -PolicyHandle $policy -Sid $sid
        $rights | Should -BeNullOrEmpty
        $Global:Error | Should -BeNullOrEmpty

        Invoke-AdvApiLsaAddAccountRights -PolicyHandle $policy -Sid $sid -Privilege 'SeBatchLogonRight' |
            Should -BeTrue
        $Global:Error | Should -BeNullOrEmpty

        $rights = Invoke-AdvApiLsaEnumerateAccountRights -PolicyHandle $policy -Sid $sid
        $rights | Should -Contain 'SeBatchLogonRight'

        Invoke-AdvApiLsaAddAccountRights -PolicyHandle $policy `
                                         -Sid $sid `
                                         -Privilege 'SeBackupPrivilege','SeDebugPrivilege','SeInteractiveLogonRight' |
            Should -BeTrue
        $Global:Error | Should -BeNullOrEmpty

        Invoke-AdvApiLsaAddAccountRights -PolicyHandle $policy `
                                         -Sid $sid `
                                         -Privilege 'SeFubarSnafu' `
                                         -ErrorAction SilentlyContinue |
            Should -BeFalse
        $Global:Error | Should -Match 'specified privilege does not exist'

        $Global:Error.Clear()

        Invoke-AdvApiLsaRemoveAccountRights -PolicyHandle $policy `
                                            -Sid $sid `
                                            -Privilege 'SeFubarSnafu' `
                                            -ErrorAction SilentlyContinue |
            Should -BeFalse
        $Global:Error | Should -Match 'specified privilege does not exist'

        $Global:Error.Clear()

        $rights = Invoke-AdvApiLsaEnumerateAccountRights -PolicyHandle $policy -Sid $sid
        $Global:Error | Should -BeNullOrEmpty
        $rights | Should -Contain 'SeBatchLogonRight'
        $rights | Should -Contain 'SeBackupPrivilege'
        $rights | Should -Contain 'SeDebugPrivilege'
        $rights | Should -Contain 'SeInteractiveLogonRight'

        Invoke-AdvApiLsaRemoveAccountRights -PolicyHandle $policy -Sid $sid -Privilege 'SeInteractiveLogonRight' |
            Should -BeTrue
        $Global:Error | Should -BeNullOrEmpty

        $rights = Invoke-AdvApiLsaEnumerateAccountRights -PolicyHandle $policy -Sid $sid
        $Global:Error | Should -BeNullOrEmpty
        $rights | Should -Not -Contain 'SeInteractiveLogonRight'
        $rights | Should -Contain 'SeBatchLogonRight'
        $rights | Should -Contain 'SeBackupPrivilege'
        $rights | Should -Contain 'SeDebugPrivilege'

        Invoke-AdvApiLsaRemoveAccountRights -PolicyHandle $policy `
                                            -Sid $sid `
                                            -Privilege 'SeDebugPrivilege','SeBackupPrivilege' |
            Should -BeTrue
        $Global:Error | Should -BeNullOrEmpty
        $rights = Invoke-AdvApiLsaEnumerateAccountRights -PolicyHandle $policy -Sid $sid
        $Global:Error | Should -BeNullOrEmpty
        $rights | Should -Not -Contain 'SeInteractiveLogonRight'
        $rights | Should -Contain 'SeBatchLogonRight'
        $rights | Should -Not -Contain 'SeBackupPrivilege'
        $rights | Should -Not -Contain 'SeDebugPrivilege'

        Invoke-AdvApiLsaRemoveAccountRights -PolicyHandle $policy -Sid $sid -All | Should -BeTrue
        $Global:Error | Should -BeNullOrEmpty

        Invoke-AdvApiLsaEnumerateAccountRights -PolicyHandle $policy -Sid $sid | Should -BeNullOrEmpty
        $Global:Error | Should -BeNullOrEmpty

        Invoke-AdvApiLsaClose -PolicyHandle $policy | Should -BeTrue
        $Global:Error | Should -BeNullOrEmpty

        Invoke-AdvApiLsaClose -PolicyHandle $policy -ErrorAction SilentlyContinue | Should -BeFalse
        $Global:Error | Should -Match 'handle is invalid'
    }
}