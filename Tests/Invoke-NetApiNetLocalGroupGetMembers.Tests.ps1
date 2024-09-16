
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

BeforeAll {
    Set-StrictMode -Version 'Latest'

    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

    $script:level = 0
}

Describe 'Invoke-NetApiNetLocalGroupGetMembers' {
    BeforeEach {
        $Global:Error.Clear()
    }

    $groupsWithMembers = [pscustomobject]@{ 'Name' = 'Administrators' }
    if ((Get-Command -Name 'Get-LocalGroup' -ErrorAction Ignore))
    {
        $groupsWithMembers = Get-LocalGroup | Where-Object { $_ | Get-LocalGroupMember -ErrorAction Ignore }
    }

    It 'gets group members' -ForEach $groupsWithMembers {
        $expectedMembers = $null
        if ((Get-Command -Name 'Get-LocalGroupMember' -ErrorAction Ignore))
        {
            $expectedMembers = $_ | Get-LocalGroupMember
        }

        foreach ($level in @(0, 1, 2, 3))
        {
            $actualMembers = Invoke-NetApiNetLocalGroupGetMembers -LocalGroupName $_.Name -Level $script:level
            $actualMembers | Should -Not -BeNullOrEmpty
            if ($expectedMembers)
            {
                $actualMembers | Should -HaveCount ($expectedMembers | Measure-Object).Count
            }
            $Global:Error | Should -BeNullOrEmpty
        }
    }
}