# Run this script in an elevated PowerShell (Run as Administrator) to stop
# Windows Defender from locking Gradle cache files during Android builds.
$paths = @(
    "$env:USERPROFILE\.gradle",
    "C:\gradle-home",
    "$PSScriptRoot\..\android"
)

foreach ($path in $paths) {
    $resolved = (Resolve-Path $path -ErrorAction SilentlyContinue).Path
    if ($null -eq $resolved) {
        Write-Host "Skipping missing path: $path"
        continue
    }
    Add-MpPreference -ExclusionPath $resolved
    Write-Host "Excluded: $resolved"
}

Write-Host "Done. Restart your terminal and run: flutter run"
