<#
package_release.ps1

Creates a zip package for release, including the game, README, license, scripts, and workflow files.
Run from C:\Users\(youruser).
#>

$files = @(
  'index.html',
  'README.md',
  'LICENSE',
  'publish_repo.ps1',
  'package_release.ps1',
  '.gitignore',
  '.github\workflows\ci.yml'
)

$missing = $files | Where-Object { -not (Test-Path $_) }
if ($missing) {
  Write-Host "Missing files:" -ForegroundColor Yellow
  $missing | ForEach-Object { Write-Host " - $_" }
  Write-Host "Please ensure the listed files exist before packaging."
  exit 1
}

$dest = 'StarDodger-full.zip'
if (Test-Path $dest) { Remove-Item $dest -Force }
Compress-Archive -Path $files -DestinationPath $dest -Force
Write-Host "Created release package: $dest" -ForegroundColor Green
