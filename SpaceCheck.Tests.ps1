$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "SpaceCheck" {
    It "Is the FreeSpace the correct type" {
        $driveSpace = get-drivespace
        $driveSpace.FreeSpaceGB | Should beoftype system.Double
    }
    It "Is the TotalSize the correct type" {
        $driveSpace = get-drivespace
        $driveSpace.totalsizeGB | Should beoftype system.Double
    }
}
