Import-Module ActiveDirectory

$csvPath = "C:\Dev\newusers.csv"
$logPath = "C:\Dev\user_creation_log.txt"

$users = Import-Csv $csvPath

$DryRun = $false

foreach ($user in $users) {
	try {
		$username = ($user.FirstName.Substring(0,1) + $user.LastName).ToLower()

		$DomainSuffix = "lab.local"

		$upn = "$username@$DomainSuffix"

		$existingUser = Get-ADUser -Filter "SamAccountName -eq '$username'"

		if ($existingUser) {
			Add-Content $logPath "$(Get-Date -Format 'yy-MM-dd HH:mm:ss') - User $username already exists."
			continue
		}

		$password = ConvertTo-SecureString "TempP@ss123!" -AsPlainText -Force

		if (-not $DryRun) {
			New-ADUser `
				-Name "$($user.FirstName) $($user.LastName)" `
				-GivenName $user.FirstName `
				-Surname $user.LastName `
				-SamAccountName $username `
				-UserPrincipalName $upn `
				-Department $user.Department `
				-accountPassword $password `
				-Enabled $true `
				-Path "OU=LabUsers,DC=lab,DC=local"
		}

		Add-Content $logPath "$(Get-Date -Format 'yy-MM-dd HH:mm:ss') - Successfully created $username"
	}
	catch {
		Add-Content $logPath "$(Get-Date -Format 'yy-MM-dd HH:mm:ss') - Failed to create $username - $_"
	}
}