<#
.Synopsis
   Gets disk space of computers specified
.DESCRIPTION
   Uses WMI to get disk size and available space on computers specified. Will look at the disks you ask
.EXAMPLE
   get-DriveSpace -driveLetter C -Computer SomeStation
.EXAMPLE
    Get-DriveSpace -Computer Station1,Station2,Station3
.EXAMPLE
#>

function Get-DriveSpace {

[CmdletBinding()]
param (
    [Parameter(Mandatory=$false, Position=1)]
    #Default Param is the local computer.
    [string[]]$computer = $ENV:ComputerName,

    [Parameter(Mandatory=$false, Position=0)]
    [string]$driveLetter = "C"
)
$outputObj = @()
    $SpaceObj = @()
    $wmiError
    foreach($c in $computer){
        if(Test-Connection $c -Count 1 -Quiet){
            $space = Get-WmiObject win32_Logicaldisk -ComputerName $c -filter "DeviceID='$driveLetter`:'" -ErrorAction SilentlyContinue
            $spaceObj = [ordered]@{
                ComputerName = $c
                DriveLetter = $driveLetter
                FreespaceGB = [math]::round($space.freespace /1GB,2)
                TotalSizeGB = [math]::round($space.size /1GB,2)
            }#end spaceObj

            $outputObj += $spaceObj
        }else{
            $spaceObj = [ordered]@{
                ComputerName = $c
                DriveLetter = $driveLetter
                FreespaceGB = "Offline"
                TotalSizeGB = "Offline"
            }#end SpaceObj

            $outputObj += $spaceObj
        }
    }
    $outputObj
}
