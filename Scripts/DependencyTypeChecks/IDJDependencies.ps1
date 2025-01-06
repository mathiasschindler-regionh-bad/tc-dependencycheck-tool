param (
    [string]$DMCName
)

Write-Host "**IDJ Dependencies**"
Write-Host "Follow the steps:"
Write-Host "  1. Open the VDI"
Write-Host "  2. Open SQL Server Management Studio"
Write-Host "  3. Connect to the DEV Server"
Write-Host "  4. Run the query on the staging database (solely available on DEV):`n"
Write-Host "     EXECUTE Custom.CheckIDJMetadata '$DMCName'`n" -ForegroundColor Yellow 

Write-Host "Dependency-free criteria: If no text is printed"
Write-Host "(Press 'Enter' to proceed)"
Read-Host