param (
    [string]$DMCName,
    [string]$ColumnName
)

Write-Host "**SlicerDicer Dependencies**"
Write-Host "Follow the steps:"
Write-Host "  1. Open the VDI"
Write-Host "  2. Open SQL Server Management Studio"
Write-Host "  3. Connect to the DEV Server"
Write-Host "  4. Run the query on the staging database (available on DEV and POC):`n"
if (-not [string]::IsNullOrWhiteSpace($ColumnName)) {
    # Split the column names into an array and format each one individually
    $ColumnNamesArray = ($ColumnName -split ',' | ForEach-Object { $_.Trim() })        
    foreach ($columnNameFormatted in $ColumnNamesArray) {
        Write-Host "     EXEC Custom.SdDependencyCheck '$DMCName', '$columnNameFormatted'`n" -ForegroundColor Yellow 
    }
} else {
    Write-Host "     EXEC Custom.SdDependencyCheck '$DMCName'`n" -ForegroundColor Yellow 
}

Write-Host "Dependency-free criteria: If no text is printed"
Write-Host "(Press 'Enter' to proceed)"
Read-Host