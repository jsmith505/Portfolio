# Drive and ignore setup
$drive = "F:\"
$ignoreFolders = @(
    "$drive`Windows",
    "$drive`Program Files",
    "$drive`Program Files (x86)",
    "$drive`ProgramData",
    "$drive`Users\Default",
    "$drive`Recovery",
    "$drive`$Recycle.Bin",
    "$drive`System Volume Information",
    "$drive`PerfLogs"
)
$ignorePattern = [regex]'\\AppData(\\|$)'
$reportPath = "C:\Temp\DiskScan_Tree.html"

$html = @"
<html>
<head>
<title>DiskScan Tree</title>
<style>
    body { font-family: monospace; background: #1e1e1e; color: #d4d4d4; }
    details > summary { cursor: pointer; }
</style>
</head>
<body>
<h2>Disk Scan Tree: $drive</h2>
"@

function Write-TreeHTML {
    param (
        [string]$Path,
        [string[]]$Ignore
    )

    $sb = New-Object System.Text.StringBuilder

    Get-ChildItem -Path $Path -Force -ErrorAction SilentlyContinue | Sort-Object PSIsContainer, Name | ForEach-Object {
        $fullPath = $_.FullName

        # Skip ignored folders and any AppData
        if ($Ignore -contains $fullPath -or $ignorePattern.IsMatch($fullPath)) {
            return
        }

        if ($_.PSIsContainer) {
            # Directory: make it collapsible
            $sb.AppendLine("<details><summary>$($_.Name)</summary>") | Out-Null
            $sb.AppendLine((Write-TreeHTML -Path $fullPath -Ignore $Ignore)) | Out-Null
            $sb.AppendLine("</details>") | Out-Null
        }
        else {
            # File
            $sb.AppendLine("$($_.Name)<br>") | Out-Null
        }
    }
    return $sb.ToString()
}

$html += Write-TreeHTML -Path $drive -Ignore $ignoreFolders
$html += @"
</body>
</html>
"@

Set-Content $reportPath $html -Encoding UTF8
Write-Host "HTML tree report generated at $reportPath"
