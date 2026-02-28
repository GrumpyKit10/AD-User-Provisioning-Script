# Active Directory Bulk User Creation Script

## Overview

This project demonstrates automated Active Directory user provisioning using PowerShell in a Windows domain lab environment.

The script:

- Imports users from a CSV file  
- Generates `SamAccountName` and `UserPrincipalName`  
- Assigns a temporary password  
- Creates users in a specified OU  
- Logs success and failure events  
- Detects and skips existing users  
- Supports dry-run testing  

This simulates real-world Systems Engineer workflow for onboarding automation.

---

## Lab Environment

- 1 Domain Controller VM  
- 2 Domain-Joined Client VMs  
- Domain: `lab.local`  
- OU: `OU=LabUsers,DC=lab,DC=local`  

The script was executed in an isolated AD lab environment.

---

## Technologies Used

- PowerShell  
- ActiveDirectory Module  
- Windows Server Domain Services  

---

## CSV Format

The script expects a CSV file structured as follows:

```csv
FirstName,LastName,Department
Alice,Johnson,IT
Bob,Smith,HR
Chris,Williams,Finance
```

---

## Features

### 1. Username Generation

Creates:

* `SamAccountName` = first initial + last name (lowercase)
* `UserPrincipalName` = [username@lab.local](mailto:username@lab.local)

Example:

```
Alice Johnson → ajohnson@lab.local
```

---

### 2. Duplicate Detection

Before creating a user, the script checks:

```powershell
Get-ADUser -Filter "SamAccountName -eq '$($username)'"
```

If the account already exists:

* User creation is skipped
* Event is logged

---

### 3. Logging

All actions are logged with timestamps.

Example output:

```
26-02-27 17:01:24 - Successfully created ajohnson
26-02-27 17:03:48 - User ajohnson already exists.
```

This provides:

* Auditability
* Debug visibility
* Safer bulk operations

---

### 4. Temporary Password Assignment

Users are created with a default temporary password:

```
TempP@ss123!
```

In a production environment, this would be:

* Randomized
* Forced to change at next logon
* Generated securely per user

---

## Script Workflow

1. Import CSV
2. Loop through users
3. Generate username
4. Check if user exists
5. Create AD user if not present
6. Log result

---

## Testing Process

The script was validated using:

* Initial run with syntax error (logged correctly)
* Corrected filter syntax
* Successful dry-run testing
* Successful user creation
* Re-run to confirm duplicate detection works

This verifies:

* Error handling
* Logging functionality
* Idempotent behavior

---

## Security Considerations

In enterprise environments:

* Scripts should be executed from a management workstation, not a Domain Controller
* Privileged accounts should be separated from standard user accounts
* Password handling should avoid plaintext
* Role-based delegation should be implemented

This lab simulates those principles where possible.

---

## Future Improvements

* Add `-WhatIf` support
* Add `-Verbose` support
* Random password generation
* Force password change at next logon
* Add group membership assignment
* Add OU validation check
* Add parameterization for domain and OU
* Convert script into reusable PowerShell module

---

## Why This Matters

Bulk user provisioning is a real-world responsibility of:

* Systems Engineers
* Identity Engineers
* Infrastructure Engineers

This project demonstrates:

* Active Directory automation
* Structured error handling
* Logging discipline
* Idempotent scripting
* Secure architecture thinking

---

## Author

Matthew Wilson
