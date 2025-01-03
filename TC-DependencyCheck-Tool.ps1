# Save the current directory path at the start
$initialDirectory = Get-Location
# $scriptPath = ".\Scripts"

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

# Prompt user for dependency type checks
$selectedItems = & "$initialDirectory\Scripts\Check-Dependencies.ps1" -DMCName $DMCName -ColumnName $ColumnName
    if ($selectedItems -contains "Git Dependencies") {
        if ($selectedItems -contains "Git Dependencies") {
        # Prompt user for the path to store temporary Git clones
        $gitClonePath = Read-Host -Prompt "Select path to store temporary git clones (default: .\TEMP-git-clone)"

        # If the user didn't provide a path, use the default
        if (-not [string]::IsNullOrWhiteSpace($gitClonePath)) {
            $gitClonePath = $gitClonePath.Trim()
        } else {
            $gitClonePath = "$initialDirectory\TEMP-git-clone"
        }

        # Ensure the directory exists
        if (-not (Test-Path $gitClonePath)) {
            Write-Host "Creating directory $gitClonePath"
            New-Item -ItemType Directory -Path $gitClonePath
        }
    }
}

if ($selectedItems -contains "IDJ Dependencies") { & "$initialDirectory\Scripts\DependencyTypeChecks\IDJDependencies.ps1" -DMCName $DMCName }
if ($selectedItems -contains "SlicerDicer Dependencies") { & "$initialDirectory\Scripts\DependencyTypeChecks\SlicerDicerDependencies.ps1" -DMCName $DMCName }
if ($selectedItems -contains "Caboodle Dependencies") { & "$initialDirectory\Scripts\DependencyTypeChecks\CaboodleDependencies.ps1" -DMCName $DMCName -ColumnName $ColumnName }

if ($selectedItems -contains "Git Dependencies") {
    Write-Host "Running Git operations ... (might take some minutes)`n`n"

    # Initialize remote git addresses
    $repos = @(
        "git@github.com:RegionHovedstaden/Analytics.git",
        "git@github.com:RegionHovedstaden/Clarity.git",
        "git@github.com:RegionHovedstaden/Metrikker.git",
        "git@github.com:RegionHovedstaden/Reports.git",
        "git@github.com:RegionHovedstaden/Research.git",
        "git@github.com:RegionHovedstaden/SP-Power-BI-Development.git"
    )

    # Check the current configuration of core.longpaths to allow very long filenames if necessary
    $coreLongPaths = git config --global core.longpaths
    if ($coreLongPaths -ne "true") {
        Write-Host "`ncore.longpaths is not set to true. Attempting to set it to true (in order to allow extraordinarily long file names)..." -ForegroundColor DarkGray
        try {
            # Set core.longpaths to true
            git config --global core.longpaths true
            Write-Host "Successfully set core.longpaths to true." -ForegroundColor DarkGray
        } catch {
            Write-Host "Failed to set core.longpaths to true. Error: $_" -ForegroundColor DarkGray
            Write-Host "Proceding without setting parameter to appropriate value ..." -ForegroundColor DarkGray
        }
    }

    # Clone the repositories
    Set-Location $gitClonePath
    foreach ($repo in $repos) {
        git clone $repo
    }

    # Loop through each repository folder to set default branches and pull latest changes 
    $clonedRepos = Get-ChildItem -Path $gitClonePath -Directory # gets the list of directories from the clone path
    foreach ($repo in $clonedRepos) {
        Set-Location $repo

        # Find the default branch, pull changes, and print the status
        $defaultBranch = git symbolic-ref refs/remotes/origin/HEAD --short
        $branch = $defaultBranch -split '/' | Select-Object -Last 1
        Write-Host "Checking out branch $branch for $repoName ..." -ForegroundColor DarkGray
        git checkout $branch
        Write-Host "Pulling latest changes in branch $branch for $repoName ..." -ForegroundColor DarkGray
        git pull

        Set-Location $gitClonePath
    }

    # Search for the column if specified, otherwise the DMC name
    $searchString = if (-not [string]::IsNullOrWhiteSpace($ColumnName)) { $ColumnName } else { $DMCName }
    # Create a output file
    $outputFilePath = "$initialDirectory\output.md"
    Set-Content -Path $outputFilePath -Value "# Dependency Search Results for $DMCName.$ColumnName`n"
    
    # Loop through each repository and run `git grep` with the search string
    Write-Host "`n`nRunning git grep for '$searchString' in repositories..."
    foreach ($repo in $clonedRepos) {
        Set-Location $repo
        Write-Host "`nRunning git grep for '$searchString' in $repo"
        
        
        # Search through repo for search term; Append to markdown output file
        $grepResults = git grep $searchString
        Add-Content -Path $outputFilePath -Value "## Repository: $repo`n"
        if (-not [string]::IsNullOrWhiteSpace($grepResults)) {
            Write-Host "`n$grepResults" -ForegroundColor Yellow
            Add-Content -Path $outputFilePath -Value $grepResults 
        } else {
            Write-Host "No matches found.`n" -ForegroundColor DarkGray
            Add-Content -Path $outputFilePath -Value "No matches found.`n" 
        }

        Set-Location $gitClonePath
    } 
    Write-Host "`nSearch results saved to $outputFilePath" -ForegroundColor Black -BackgroundColor Yellow 

    # Return to the initial script directory
    Set-Location $initialDirectory
}

Write-Host "`n`nClosing program ..."
Start-Sleep -Seconds 2
Write-Host "Goodbye (ʘ‿ʘ)╯"