# Generate dotted module names from the .py files under the target package.
# Output is formatted for pasting into e.g. PyInstaller's hiddenimports.
# The result is printed to the screen and also copied to the clipboard.

# File names to exclude. Add more entries to this array as needed.
$excludeNames = @(
    "__init__.py"
)

$packageDir = Split-Path $PSScriptRoot -Parent
$srcDir = Split-Path $packageDir -Parent

$lines = Get-ChildItem $packageDir -Recurse -Filter *.py |
Where-Object {
    $_.Name -notin $excludeNames -and
    $_.FullName -notlike "$PSScriptRoot\*"
} |
ForEach-Object {
    $relativePath = $_.FullName.Substring($srcDir.Length + 1)

    $module = $relativePath `
        -replace "\\", "." `
        -replace "\.py$", ""

    "    `"$module`","
}

# Print to screen
$lines

# Copy to clipboard
$lines | Set-Clipboard
Write-Host "Copied $($lines.Count) module name(s) to the clipboard." -ForegroundColor Green
