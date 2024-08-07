# Enable WSL 1 feature
Write-Host "Enabling WSL feature..."
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Install a WSL distribution (Ubuntu in this case)
Write-Host "Downloading and installing Ubuntu..."
wsl.exe --install Ubuntu-22.04

# Initialize WSL and set the default version to WSL 1
Write-Host "Setting WSL version to 1..."
wsl --set-version 1

# Run WSL and install Git
Write-Host "Installing Git in WSL..."
wsl -d Ubuntu-22.04 -u root -- apt-get update
wsl -d Ubuntu-22.04 -u root -- apt-get install -y git

Write-Host "WSL 1 and Git installation completed."