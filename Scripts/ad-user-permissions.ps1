# Requires ActiveDirectory + ImportExcel
Import-Module ActiveDirectory
Import-Module ImportExcel

# --- Function: Get all groups including primary group ---
function Get-AllUserGroups {
    param([Microsoft.ActiveDirectory.Management.ADUser]$User)

    $Groups = @()

    if ($User.memberOf) {
        $Groups = $User.memberOf | ForEach-Object {
            (Get-ADGroup $_ -ErrorAction SilentlyContinue).Name
        }
    }

    try {
        $PrimaryGroupSID = ($User.SID.Value -replace '\d+$') + $User.PrimaryGroupID
        $PrimaryGroup = Get-ADGroup -Filter "SID -eq '$PrimaryGroupSID'" -ErrorAction SilentlyContinue
        if ($PrimaryGroup) { $Groups += $PrimaryGroup.Name }
    } catch {}

    return $Groups | Sort-Object -Unique
}

# --- US office categories (<Company> OU) ---
$UsCategories = @{
    "Compliance"        = "OU=Compliance"
    "Development"       = "OU=Development"
    "HR"                = "OU=HR"
    "IT"                = "OU=IT"
    "Operations"        = "OU=Operations"
    "Product"           = "OU=Product"
    "Services"          = "OU=Services"
    "Service Accounts"  = "OU=Service Accounts"
}

# --- CA office categories (<Company> OU) ---
$CACategories = @{
    "Bill Review Agents"   = "OU=Bill Review Agents"
    "Call Center Agents"   = "OU=Call Center Agents"
    "Stateside Services"   = "OU=Stateside Services"
}

# --- Paths ---
$SharePath   = "\\FILESERVER\FOLDER"
$DateStamp   = Get-Date -Format "yyyy-MM-dd"
$CurrentFile = Join-Path $SharePath "AD_UserPermissions_$DateStamp.xlsx"

if (-not (Test-Path $SharePath)) { New-Item -ItemType Directory -Path $SharePath }

# --- Collect current snapshot ---
$Users = Get-ADUser -Filter {Enabled -eq $true} -Properties memberOf, DisplayName, SamAccountName, DistinguishedName, SID, PrimaryGroupID

$CurrentReport = foreach ($User in $Users) {
    $DN = $User.DistinguishedName
    $Office = ""
    $Category = "Uncategorized"

    if ($DN -like "*OU=<Company>*") {
        $Office = "US"
        foreach ($Key in $UsCategories.Keys) {
            if ($DN -like "*$($UsCategories[$Key])*") {
                $Category = $Key; break
            }
        }
    }
    elseif ($DN -like "*OU=<Company>*") {
        $Office = "CA"
        foreach ($Key in $CACategories.Keys) {
            if ($DN -like "*$($CACategories[$Key])*") {
                $Category = $Key; break
            }
        }
    }
    else {
        $Office = "Unknown"
    }

    $UserGroups = Get-AllUserGroups $User

    [PSCustomObject]@{
        DisplayName    = $User.DisplayName
        SamAccountName = $User.SamAccountName
        Office         = $Office
        Category       = $Category
        Groups         = ($UserGroups -join "; ")
    }
}

# --- Save current snapshot ---
$CurrentReport | Export-Excel -Path $CurrentFile -WorksheetName "Current" -AutoSize

Write-Host "Current snapshot saved: $CurrentFile" -ForegroundColor Green

# --- Find the last report for diff ---
$PreviousFile = Get-ChildItem $SharePath -Filter "AD_UserPermissions_*.xlsx" |
    Where-Object { $_.FullName -ne $CurrentFile } |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

if ($PreviousFile) {
    Write-Host "Comparing with previous snapshot: $($PreviousFile.Name)" -ForegroundColor Cyan

    $PreviousReport = Import-Excel -Path $PreviousFile.FullName -WorksheetName "Current"

    # Build lookup hashes
    $PrevHash = @{}
    foreach ($p in $PreviousReport) { $PrevHash[$p.SamAccountName] = $p }

    $CurrHash = @{}
    foreach ($c in $CurrentReport) { $CurrHash[$c.SamAccountName] = $c }

    # --- New users ---
    $NewUsers = $CurrentReport | Where-Object { -not $PrevHash.ContainsKey($_.SamAccountName) }

    # --- Changed permissions ---
    $ChangedPermissions = foreach ($User in $CurrentReport) {
        if ($PrevHash.ContainsKey($User.SamAccountName)) {
            if ($User.Groups -ne $PrevHash[$User.SamAccountName].Groups) {
                [PSCustomObject]@{
                    SamAccountName = $User.SamAccountName
                    DisplayName    = $User.DisplayName
                    Office         = $User.Office
                    Category       = $User.Category
                    OldGroups      = $PrevHash[$User.SamAccountName].Groups
                    NewGroups      = $User.Groups
                }
            }
        }
    }

    # --- Export diffs into same Excel ---
    if ($NewUsers) {
        $NewUsers | Export-Excel -Path $CurrentFile -WorksheetName "NewUsers" -AutoSize -Append
    }
    if ($ChangedPermissions) {
        $ChangedPermissions | Export-Excel -Path $CurrentFile -WorksheetName "ChangedPermissions" -AutoSize -Append
    }

    Write-Host "Diff exported into $CurrentFile" -ForegroundColor Green
}
else {
    Write-Host "No previous report found — only current snapshot created." -ForegroundColor Yellow
}
