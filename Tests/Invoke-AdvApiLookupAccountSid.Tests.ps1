
using namespace System.Security.Principal

#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

BeforeAll {
    Set-StrictMode -Version 'Latest'

    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)
}

Describe 'Invoke-AdvApiLookupAccountSid' {
    BeforeEach {
        $Global:Error.Clear()
    }

    It 'fails' {
        [byte[]] $sidBytes = @(0,2,3,4)
        Invoke-AdvApiLookupAccountSid -Sid $sidBytes -ErrorAction SilentlyContinue |
            Should -BeNullOrEmpty
        $Global:Error | Should -Match 'parameter is incorrect'
    }

    It 'succeeds' {
        $sid = [NTAccount]::New([Environment]::UserName).Translate([SecurityIdentifier])
        $sidBytes = [byte[]]::New($sid.BinaryLength)
        $sid.GetBinaryForm($sidBytes, 0)
        $result = Invoke-AdvApiLookupAccountSid -Sid $sidBytes
        $Global:Error | Should -BeNullOrEmpty
        $result | Should -Not -BeNullOrEmpty
        $result.DomainName | Should -Not -BeNullOrEmpty
        $result.Name | Should -Be ([Environment]::UserName)
        $result.Use | Should -Not -BeNullOrEmpty
    }
}