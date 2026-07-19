<#
publish_repo.ps1
Usage:
  - Open PowerShell in C:\Users\1102813
  - Run: .\publish_repo.ps1
  - Or provide parameters: .\publish_repo.ps1 -RepoName StarDodger -Private:$false -RemoteUrl "git@github.com:you/StarDodger.git"

What it does:
  - Verifies `git` is installed
  - Initializes a local repo (if none), stages all files and makes an initial commit
  - If GitHub CLI (`gh`) is available and you're logged in, it will create the remote repo and push
  - Otherwise, it will optionally add a provided remote URL and push, or print manual instructions
#>

param(
  [string]$RepoName = "StarDodger",
  [switch]$Private = $false,
  [string]$RemoteUrl = ""
)

function Write-ErrAndExit($msg){ Write-Host $msg -ForegroundColor Red; exit 1 }

# Ensure script runs in the script folder
Push-Location -Path (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Check git
if (-not (Get-Command git -ErrorAction SilentlyContinue)){
  Write-ErrAndExit "git is not installed or not in PATH. Please install Git for Windows: https://git-scm.com/download/win"
}

# Check current folder
Write-Host "Working directory: " (Get-Location)

# Init git if needed
if (-not (Test-Path .git)){
  Write-Host "Initializing new git repository..."
  git init || Write-ErrAndExit "git init failed"
} else {
  Write-Host ".git already exists — using existing repo"
}

# Stage and commit
Write-Host "Staging files..."
git add . || Write-ErrAndExit "git add failed"

# Only commit if there are staged changes
$changes = git status --porcelain
if ($changes) {
  git commit -m "Initial commit: $RepoName - single-file game and README" || Write-ErrAndExit "git commit failed"
} else {
  Write-Host "No changes to commit."
}

# Attempt to create remote with gh if available
if (Get-Command gh -ErrorAction SilentlyContinue){
  Write-Host "GitHub CLI detected. Creating repository on GitHub..."
  $pub = $Private.IsPresent ? "--private" : "--public"
  gh repo create $RepoName $pub --source=. --remote=origin --push --confirm || Write-Host "gh repo create failed or aborted. You can create manually and run the manual push steps below."
  Write-Host "Done — repo pushed using gh."
  Pop-Location; exit 0
}

# If gh not available, use provided remote URL or print instructions
if ($RemoteUrl -ne ""){
  Write-Host "Adding remote origin: $RemoteUrl"
  git remote add origin $RemoteUrl || Write-ErrAndExit "git remote add failed"
  git branch -M main || Write-ErrAndExit "branch rename failed"
  git push -u origin main || Write-ErrAndExit "git push failed"
  Write-Host "Pushed to remote: $RemoteUrl"
  Pop-Location; exit 0
}

# Otherwise, instruct the user to create a remote
Write-Host "\nNo GitHub CLI detected and no remote URL provided. To finish, create a GitHub repository named '$RepoName' then run these commands:" -ForegroundColor Yellow
Write-Host "1) Create repository on GitHub.com (choose Public or Private as you prefer)."
Write-Host "2) Add the remote and push (replace <your-remote-url> with the SSH or HTTPS URL shown on GitHub):\n"

Write-Host "git remote add origin <your-remote-url>"
Write-Host "git branch -M main"
Write-Host "git push -u origin main"

Pop-Location
Write-Host "publish_repo.ps1 finished."
