$credential = Get-Credential
Write-Host "Actual Effort " $credential.GetNetworkCredential().username