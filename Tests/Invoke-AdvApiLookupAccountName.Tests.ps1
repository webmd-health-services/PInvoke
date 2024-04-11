
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

BeforeAll {
    Set-StrictMode -Version 'Latest'

    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)
}

Describe 'Invoke-AdvApiLookupAccountName' {
    BeforeEach {
        $Global:Error.Clear()
    }

    It 'fails' {
        Invoke-AdvApiLookupAccountName -AccountName 'fubarsnafu' -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
        $Global:Error | Should -Match 'no mapping between account names'
    }

    It 'succeeds' {
        $result = Invoke-AdvApiLookupAccountName -AccountName ([Environment]::UserName)
        $Global:Error | Should -BeNullOrEmpty
        $result | Should -Not -BeNullOrEmpty
        $result.DomainName | Should -Not -BeNullOrEmpty
        $result.Sid | Should -Not -BeNullOrEmpty
        $result.Use | Should -Not -BeNullOrEmpty
    }
}