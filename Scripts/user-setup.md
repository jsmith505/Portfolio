## New-ADUser-InteractiveOU.ps1

Interactive AD user creation with a safe OU browser.

### Prereqs
- Windows PowerShell 5.1 or PowerShell with the AD module
- RSAT: ActiveDirectory
- AD permissions to create users and manage group membership

### Configure
Edit the **Config** block in the script:
- CompanyName, PrimaryDomain, AltEmailDomain
- Locations: per-country BaseOU, BaseHead, OnPremGroups, CloudGroups

### Run
```powershell
Import-Module ActiveDirectory
.\New-ADUser-InteractiveOU.ps1
