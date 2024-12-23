$scriptPath = ".\Scripts"

# Clear console
Clear-Host

# Prompt user for DMC
Write-Host "Enter DMC name to check dependencies for. Press 'Enter' to proceed"

# Save entered DMC in variable
$DMCName = Read-Host -Prompt "DMC Name"

# Prompt user for column(s)
Write-Host "`n(Optional) Enter column name(s) to check dependencies for; separate them by comma. Press 'Enter' to proceed"

# Get the column name (or nothing if they press 'Enter')
$ColumnName = Read-Host -Prompt "Column Name (optional)"

# Summarizing 
if (-not [string]::IsNullOrWhiteSpace($ColumnName)) {
    $ColumnNamesFormatted = ($ColumnName -split ',' | ForEach-Object { $_.Trim() }) -join ', '
    Write-Host "`nChecking dependencies for columns: $ColumnNamesFormatted in $DMCName"
} else {
    Write-Host "`nChecking dependencies for entire DMC: $DMCName"
}

# Path to the new script (assuming it's in a subfolder called Scripts)
$selectedItems = & "$scriptPath\Check-Dependencies.ps1" -DMCName $DMCName -ColumnName $ColumnName

if ($selectedItems -contains "IDJ Dependencies") { & "$scriptPath\DependencyTypeChecks\IDJDependencies.ps1" -DMCName $DMCName }
if ($selectedItems -contains "SlicerDicer Dependencies") { & "$scriptPath\DependencyTypeChecks\SlicerDicerDependencies.ps1" -DMCName $DMCName }
if ($selectedItems -contains "Caboodle Dependencies") { & "$scriptPath\DependencyTypeChecks\CaboodleDependencies.ps1" -DMCName $DMCName -ColumnName $ColumnName }
