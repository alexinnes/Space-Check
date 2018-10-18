$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"



Describe "Wmi Query"{
    it "Can I query WMI"{
        $wmiCheck = Get-WmiObject win32_Logicaldisk
        $wmiCheck | Should -Not -Be $null
    }
}
Describe "Check Type" {
    It "Is the FreeSpace the correct type" {
        $driveSpace = get-drivespace
        $driveSpace.FreeSpaceGB | Should beoftype system.Double
    }
    It "Is the TotalSize the correct type" {
        $driveSpace = get-drivespace
        $driveSpace.totalsizeGB | Should beoftype system.Double
    }
}
Describe "Mock Win32_LogicalDisk"{
    Mock Get-WmiObject {
        return @{
            #values need to be in bytes.
            FreeSpace = 1073741824
            Size = 2147483648
        }
    } -Verifiable

    it "Are the mocked values being converted correctly"{
        $drive = get-drivespace
        $drive.freespaceGB | should -be 1
        $drive.totalsizeGB | should -be 2
    }

}


