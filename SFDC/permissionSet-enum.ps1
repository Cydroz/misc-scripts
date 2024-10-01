
# Usage example (within PowerShell terminal):
# ./script.ps1 -Path path/to/PS.permissionset-meta.xml -Out output/directory/path


[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $Path,
    [Parameter()]
    [string]
    $Out
)

$sfObj = ([xml](gc "$Path")).PermissionSet

# get basename
$basename = (Split-Path -Path $Path -Leaf) -replace '\..*',''

# If output arg specified, cd there.
if ($Out) {
    ni -Type Directory -Path $Out -Force
    cd $Out
}
rm "$basename.singletons.txt"

# Print obj summary
$sfObj

# Enumerate properties
$props=$sfObj | Get-Member -MemberType Property | select -ExpandProperty name
foreach ($name in $props) {
    echo "Scanning $name"
    if ($sfObj.$name.Count -gt 1) {
        # Save to csv
        $sfObj.$name | ConvertTo-Csv > "$basename.$name.csv"
    }else {
        echo "$name : $($sfObj.$name)" >> "$basename.singletons.txt"
    }
}