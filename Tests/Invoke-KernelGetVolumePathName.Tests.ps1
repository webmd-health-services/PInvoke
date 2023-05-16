
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

BeforeAll {
    Set-StrictMode -Version 'Latest'

    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

    $script:testRoot = $null
    $script:testNum = 0
    $script:systemVolume =
        Join-Path -Path ([Environment]::GetFolderPath('Windows') | Split-Path -Qualifier) -ChildPath '\'
}

Describe 'Invoke-KernelGetVolumePathName' -Skip {
    BeforeEach {
        $Global:Error.Clear()
    }

    It 'returns path volume' {
        Invoke-KernelGetVolumePathName -Path $PSScriptRoot |
            Should -Be (Join-Path -Path ($PSScriptRoot | Split-Path -Qualifier) -ChildPath '\')
    }

    It 'returns non-rooted path volume' {
        Invoke-KernelGetVolumePathName -Path ($PSScriptRoot | Split-Path -NoQualifier) | Should -Be $script:systemVolume
    }

    It 'returns system drive for files that do not exist' {
        Invoke-KernelGetVolumePathName -Path 'i do not exist' | Should -Be $script:systemVolume
    }

    It 'returns system drive for relative paths' {
        Get-ChildItem |
            Select-Object -First 1 |
            ForEach-Object { Invoke-KernelGetVolumePathName -Path $_.Name } |
            Should -Be $script:systemVolume
    }
}
