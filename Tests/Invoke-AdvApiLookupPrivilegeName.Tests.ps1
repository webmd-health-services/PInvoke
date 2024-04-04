
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

BeforeAll {
    Set-StrictMode -Version 'Latest'

    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)
}

Describe 'Invoke-AdvApiLookupPrivilegeName' {
    BeforeEach {
        $Global:Error.Clear()
    }

    It 'fails' {
        $emptyLuid = [PureInvoke.WinNT.LUID]::New()
        Invoke-AdvApiLookupPrivilegeName -LUID $emptyLuid -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
        $Global:Error | Should -Match 'specified privilege does not exist'
    }

    # In testing, these are the privilege values.
    $privilegeValues = 2..35
    It 'finds privilege <_>' -TestCases $privilegeValues {
        $luid = [PureInvoke.WinNT.LUID]::New()
        $luid.LowPart = $_
        $result = Invoke-AdvApiLookupPrivilegeName -LUID $luid
        $Global:Error | Should -BeNullOrEmpty
        $result | Should -Not -BeNullOrEmpty
        $result | Should -Match '^Se.*Privilege$'
    }
}