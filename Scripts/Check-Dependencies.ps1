param (
    [string]$DMCName,
    [string]$ColumnName
)

# List of options
$options = @("IDJ Dependencies", "SlicerDicer Dependencies", "Caboodle Dependencies", "GitHub Dependencies")

# Initialize selected items array
$selectedItems = @()

# Display options and allow user to select/deselect
Write-Host "`nSelect checks to perform:"
$index = 0

# Loop for each option to display and handle input
foreach ($option in $options) {
    $isSelected = $false

    # Display the current option with index and checkbox
    Write-Host "$($index + 1). [ ] $option"
    $index++
}

# Prompt user to select options
Write-Host "`nEnter the numbers (comma-separated) of the options you want to select, then press Enter:"
Write-Host "`n(Leave empty to select all)"

# Capture user input
$userInput = Read-Host -Prompt "Selection"
$selections = $userInput -split ',' | ForEach-Object { $_.Trim() }

# Process the user input
foreach ($selection in $selections) {
    if ($selection -match '^\d+$' -and $selection -ge 1 -and $selection -le $options.Length) {
        $selectedItems += $options[$selection - 1]
    } else {
        Write-Host "Invalid selection: $selection"
    }
}

# If no selections were made, select all options by default
if ($selectedItems.Count -eq 0) {
    $selectedItems = $options
}

# Summarizing selections
if ($selectedItems.Count -gt 0) {
    Write-Host "`nYou selected the following checks:"
    $selectedItems | ForEach-Object { Write-Host $_ }
    Write-Host "`n"
} else {
    Write-Host "No checks selected."
}

# Return the selected items as the output of this script
return $selectedItems
