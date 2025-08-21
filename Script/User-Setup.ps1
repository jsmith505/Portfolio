#region Functions

function Capitalize-EachWord {
    param([string]$text)
    if ([string]::IsNullOrWhiteSpace($text)) { return $text }
    return ($text -split ' ' | ForEach-Object { $_.Substring(0,1).ToUpper() + $_.Substring(1).ToLower() }) -join ' '
}

function Capitalize-All {
    param([string]$text)
    if ([string]::IsNullOrWhiteSpace($text)) { return $text }
    return $text.ToUpper()
}

function Get-ChildOUs {
    param([string]$BaseDN)
    try {
        Get-ADOrganizationalUnit -SearchBase $BaseDN -SearchScope OneLevel -Filter * |
            Sort-Object Name |
            Select-Object Name, DistinguishedName
    } catch {
        Write-Host "Failed to enumerate OUs under: $BaseDN`n$($_.Exception.Message)" -ForegroundColor Red
        @()
    }
}

function Select-OUInteractive {
    param([string]$StartDN)

    if (-not $StartDN) { throw "StartDN is required." }

    $stack = New-Object System.Collections.Stack
    $current = $StartDN

    while ($true) {
        $children = Get-ChildOUs -BaseDN $current

        Write-Host "`n--- Select OU ---" -ForegroundColor Cyan
        Write-Host "Current: $current"
        Write-Host "0)  Use this OU"
        for ($i=0; $i -lt $children.Count; $i++) {
            "{0})  {1}" -f ($i+1), $children[$i].Name | Write-Host
        }
        $backIndex = $children.Count + 1
        $cancelIndex = $children.Count + 2
        Write-Host "$backIndex)  Back"
        Write-Host "$cancelIndex)  Cancel"

        $choice = Read-Host "Enter choice number"
        if (-not ($choice -match '^\d+$')) { continue }
        $choice = [int]$choice

        switch ($choice) {
            0 { return $current } # Use current OU
            { $_ -ge 1 -and $_ -le $children.Count } {
                $stack.Push($current)
                $current = $children[$choice-1].DistinguishedName
            }
            { $_ -eq $backIndex } {
                if ($stack.Count -gt 0) { $current = $stack.Pop() } else { Write-Host "Already at the starting level." }
            }
            { $_ -eq $cancelIndex } { return $null }
        }
    }
}

function Get-DepartmentFromSelectedDN {
    param(
        [string]$SelectedDN,
        [string]$BaseHead # e.g. "OU=O365 Sync" or "OU=Company Services"
    )
    if (-not $SelectedDN) { return $null }
    $parts = $SelectedDN -split ','
    $ouParts = @()
    foreach ($p in $parts) {
        if ($p -like 'OU=*') {
            if ($p -eq $BaseHead) { break }
            $ouParts += $p
        }
    }
    # ouParts is leaf..upward until just before base. If there are ≥2, department is the LAST before base (e.g., Development).
    if ($ouParts.Count -ge 2) {
        return ($ouParts[-1] -replace '^OU=')
    } elseif ($ouParts.Count -ge 1) {
        return ($ouParts[0] -replace '^OU=')
    } else {
        return $null
    }
}

#endregion

#region Prompt for user input

$FirstName = Read-Host "Enter First Name"
$LastName  = Read-Host "Enter Last Name"
$Username  = ("{0}.{1}" -f $FirstName,$LastName).ToLower()

$Title     = Capitalize-EachWord (Read-Host "Enter Job Title (e.g., Medical Bill Auditor)")
$Company   = "Company Branch"
$Country   = Capitalize-All (Read-Host "Enter Country (US or CA)")
$ManagerName = Read-Host "Enter Manager Name (e.g., Jane Doe)"
$HasLaptop = Read-Host "Does the user have a Company laptop? (Y/N)"
$NeedsTeamsCAone = Read-Host "Assign Teams CAone license? (Y/N)"

$DisplayName = Capitalize-EachWord "$FirstName $LastName"

# Determine Onshore/Offshore + base container
if ($Country -eq 'US') {
    $BaseOU = "OU=O365 Sync,OU=Branch,DC=Company,DC=com"
    $BaseHead = "OU=O365 Sync"
    $LocationStatus = "Onshore (US)"
    $StateInput = Read-Host "Enter State (e.g., NM, GA, NV) or leave blank"
    $State = if ($StateInput) { Capitalize-All $StateInput } else { $null }
} elseif ($Country -eq 'CA') {
    $BaseOU = "OU=Company Services,DC=Company,DC=com"
    $BaseHead = "OU=Company Services"
    $LocationStatus = "Offshore (CA)"
    $State = $null
} else {
    Write-Host "Country not recognized. Exiting..."
    exit 1
}

# Interactive OU selection (stop at any level using option 0)
$OU = Select-OUInteractive -StartDN $BaseOU
if (-not $OU) { Write-Host "OU selection cancelled."; exit 1 }

# Derive Department from the selected OU (you can confirm/edit)
$DerivedDept = Get-DepartmentFromSelectedDN -SelectedDN $OU -BaseHead $BaseHead
$Department  = Read-Host ("Department attribute (press Enter to accept: {0})" -f $DerivedDept)
if ([string]::IsNullOrWhiteSpace($Department)) { $Department = $DerivedDept }
$Department  = Capitalize-EachWord $Department

#endregion

#region Resolve manager DN

$ManagerObj = Get-ADUser -Filter "Name -eq '$ManagerName'"
if (-not $ManagerObj) {
    Write-Host "Manager '$ManagerName' not found. Exiting..."
    exit 1
}
$ManagerDN = $ManagerObj.DistinguishedName

#endregion

#region Validate OU exists

try {
    $null = [adsi]"LDAP://$OU"
} catch {
    Write-Host "OU path is invalid: $OU"
    exit 1
}

#endregion

#region Create user

# Generate secure password (12 chars, 1 non-alCAanumeric)
Add-Type -AssemblyName 'System.Web'
$PasswordPlain  = [System.Web.Security.Membership]::GeneratePassword(12, 1)
$PasswordSecure = ConvertTo-SecureString -String $PasswordPlain -AsPlainText -Force

try {
    $UserParams = @{
        Name                 = $DisplayName
        GivenName            = (Capitalize-EachWord $FirstName)
        Surname              = (Capitalize-EachWord $LastName)
        SamAccountName       = $Username
        UserPrincipalName    = "$Username@Company.com"
        DisplayName          = $DisplayName
        Path                 = $OU
        EmailAddress         = "$Username@Company.com"
        Title                = $Title
        Department           = $Department
        Company              = $Company
        AccountPassword      = $PasswordSecure
        Enabled              = $true
        ChangePasswordAtLogon= $false
        Country              = $Country
        Manager              = $ManagerDN
    }
    if ($State) { $UserParams["Description"] = $State }
    New-ADUser @UserParams
} catch {
    Write-Host "Failed to create user: $_"
    exit 1
}

# Update proxyAddresses
try {
    Set-ADUser $Username -Add @{proxyAddresses=@("smtp:$Username@Company.com","smtp:$Username@CompanyBranch.com")}
} catch {
    Write-Host "Failed to update proxyAddresses: $($_.Exception.Message)"
}

#endregion

#region Group assignment helpers

$GroupResults = @()
function Safe-AddUserToGroup {
    param(
        [string]$GroupName,
        [string]$UserName
    )
    $Group = Get-ADGroup -Filter "Name -eq '$GroupName'" -ErrorAction SilentlyContinue
    if ($Group) {
        try {
            Add-ADGroupMember -Identity $Group -Members $UserName -ErrorAction Stop
            $GroupResults += "Added $UserName to $GroupName"
        } catch {
            $GroupResults += "Failed to add to group ${GroupName}: $($_.Exception.Message)"
        }
    } else {
        $GroupResults += "Group not found: $GroupName"
    }
}

#endregion

#region On-prem groups by country

if ($Country -eq 'US') {
    Safe-AddUserToGroup "Remote Desktop Access - Servers"      $Username
    Safe-AddUserToGroup "Remote Desktop Access - TermServers"  $Username
    Safe-AddUserToGroup "Remote Desktop Users"                 $Username
    if ($Department) { Safe-AddUserToGroup $Department $Username }
} elseif ($Country -eq 'CA') {
    $GroupResults += "No on-prem groups assigned for CA"
}

#endregion

#region Cloud groups to assign manually

$CloudGroupsUS = @(
    "DL-Everyone",
    "DL-US Employees",
    "Paylocity - US",
    "Zendesk",
    "KnowBe4",
    "Company Portals Apps",
    "Intune Managed group",
    "Employee Resources"
)

$CloudGroupsCA = @(
    "DL-Everyone",
    "DL-Company_CA Team",
    "Paylocity CA",
    "Zendesk",
    "KnowBe4",
    "Company Portal CA",
    "Intune managed overseas",
    "LicenseAssignCA",
    "LocalAdminRemoveCA",
    "Standard User Assign CA",
    "Employee Resources"
)

#endregion

#region Summary

Write-Host "`n==== New User Summary ===="
Write-Host "Username: $Username@company.com"
Write-Host "Display Name: $DisplayName"
Write-Host "Temporary Password: $PasswordPlain"
Write-Host "Country: $Country"
Write-Host "Onshore/Offshore: $LocationStatus"
Write-Host "Department: $Department"
Write-Host "Job Title: $Title"
Write-Host "State: $State"
Write-Host "Manager: $ManagerName"
Write-Host "OU Selected: $OU"

Write-Host "`nOn-Prem Group Membership Summary:"
$GroupResults | ForEach-Object { Write-Host $_ }

Write-Host "`nRemaining Manual Tasks:" 
Write-Host "1. Wait for Azure AD sync to complete."
Write-Host "2. Assign Microsoft 365 Business Premium and Power Automate Free licenses."
Write-Host "3. Assign the following Azure groups in Entra/M365:"
if ($Country -eq "US") {
    $CloudGroupsUS | ForEach-Object { Write-Host "   • $_" }
} elseif ($Country -eq "CA") {
    $CloudGroupsCA | ForEach-Object { Write-Host "   • $_" }
}
Write-Host "4. Laptop Required: $HasLaptop"
Write-Host "5. Teams CAone Required: $NeedsTeamsCAone"
if ($NeedsTeamsCAone -eq 'Y') {
    Write-Host "6. Assign Teams CAone with Calling Plan license."
    Write-Host "7. Assign a CAone number in Teams Admin Center and configure emergency location (Main Office)."
}
Write-Host "==========================="
#endregion
