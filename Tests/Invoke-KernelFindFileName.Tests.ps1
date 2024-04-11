
using namespace PureInvoke
using namespace System.ComponentModel

#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

BeforeAll {
    Set-StrictMode -Version 'Latest'

    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

    $script:testRoot = $null
    $script:testNum = 0
    [String[]]$script:targets = @()

    function GivenHardlink
    {
        param(
            [Parameter(Mandatory, Position=0)]
            [String[]] $LinkPath,

            [Parameter(Mandatory)]
            [String] $ThatTargets
        )

        $targetPath = Join-Path -Path $testRoot -ChildPath $ThatTargets
        if( -not (Test-Path -Path $targetPath -PathType Leaf) )
        {
            New-Item -Path $targetPath -ItemType 'File'
        }

        foreach( $linkPathItem in $LinkPath )
        {
            if( (Test-Path -Path $linkPathItem -PathType Leaf) )
            {
                Write-Verbose -Message ('Removing "{0}": this file exists.' -f $linkPathItem)
                Remove-Item -Path $linkPathItem
            }

            if( -not (Test-Path -Path $linkPathItem -PathType Leaf) )
            {
                Write-Verbose ('Creating hardlink "{0}" -> "{1}".' -f $linkPathItem,$targetPath)
                New-Item -ItemType HardLink -Path (Join-Path -Path $testRoot -ChildPath $linkPathItem) -Value $targetPath
            }
        }
    }

    function GivenFile
    {
        param(
            [Parameter(Mandatory)]
            [String] $Path,

            [String] $In
        )

        if( $In )
        {
            $Path = Join-Path -Path $In -ChildPath $Path
        }
        else
        {
            $Path = Join-Path -Path $testRoot -ChildPath $Path
        }

        New-Item -Path $Path -ItemType 'File'
    }

    function ThenError
    {
        [Diagnostics.CodeAnalysis.SuppressMessage('PSAvoidAssignmentToAutomaticVariable', '')]
        param(
            [Parameter(Mandatory, ParameterSetName='Empty')]
            [switch] $IsEmpty,

            [Parameter(Mandatory, ParameterSetName='Exists')]
            [string] $Matches
        )

        if ($IsEmpty)
        {
            $Global:Error | Should -BeNullOrEmpty
            return
        }

        $Global:Error | Should -Match $Matches
    }

    function ThenFound
    {
        param(
            [String[]] $Targets
        )

        $script:targets | Should -HaveCount $Targets.Length

        foreach ($target in $Targets)
        {
            if (-not ([IO.Path]::IsPathRooted($target)))
            {
                $target = Join-Path -Path $testRoot -ChildPath $target
            }

            $script:targets | Should -Contain ($target | Split-Path -NoQualifier)
        }
    }

    function WhenFinding
    {
        [CmdletBinding()]
        param(
            $Path
        )

        if (-not ([IO.Path]::IsPathRooted($Path)))
        {
            $Path = Join-Path -Path $testRoot -ChildPath $Path
        }

        $script:targets = Invoke-KernelFindFileName -Path $Path
    }
}

Describe 'Invoke-KernelFindFileName' {
    BeforeEach {
        $Global:Error.Clear()
        $script:testRoot = $null
        $script:failed = $false
        $script:testRoot = Join-Path -Path $TestDrive -ChildPath ($script:testNum++)
        New-Item -Path $script:testRoot -ItemType 'Directory'
        $script:targets = @()
    }

    It 'finds targets for file linked to no files' {
        GivenFile 'target0.txt'
        WhenFinding 'target0.txt'
        ThenFound 'target0.txt'
        ThenError -IsEmpty
    }
    It 'finds targets for file linked to two file' {
        GivenHardlink -LinkPath 'link.txt' -ThatTargets 'target1.txt'
        $targets = @('target1.txt', 'link.txt')
        WhenFinding 'target1.txt'
        ThenFound $targets
        WhenFinding 'link.txt'
        ThenFound $targets
        ThenError -IsEmpty
    }

    It 'finds targets for file linked to three files' {
        GivenHardlink -LinkPath 'link1.txt', 'link2.txt' -ThatTargets 'target2.txt'
        $targets = @('target2.txt', 'link1.txt', 'link2.txt')
        WhenFinding 'link1.txt'
        ThenFound $targets
        WhenFinding 'link2.txt'
        ThenFound $targets
        WhenFinding 'target2.txt'
        ThenFound $targets
        ThenError -IsEmpty
    }

    It 'fails if path does not exist' {
        WhenFinding 'idonotexist.txt' -ErrorAction SilentlyContinue
        ThenFound @()
        ThenError -Matches ([Win32Exception]::New([PureInvoke.ErrorCode]::FileNotFound)).Message
    }
}