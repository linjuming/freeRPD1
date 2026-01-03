# Install Chocolatey
Write-Host "Installing Chocolatey..."
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install Google Chrome
Write-Host "Installing Google Chrome..."
choco install googlechrome -y --force

# Set Chrome as default browser
Write-Host "Setting Google Chrome as default browser..."
$xmlContent = @"
<?xml version="1.0" encoding="UTF-8"?>
<DefaultAssociations>
  <Association Identifier=".htm" ProgId="ChromeHTML" ApplicationName="Google Chrome" />
  <Association Identifier=".html" ProgId="ChromeHTML" ApplicationName="Google Chrome" />
  <Association Identifier="http" ProgId="ChromeHTML" ApplicationName="Google Chrome" />
  <Association Identifier="https" ProgId="ChromeHTML" ApplicationName="Google Chrome" />
</DefaultAssociations>
"@
$xmlPath = Join-Path $env:TEMP "app-associations.xml"
$xmlContent | Out-File -FilePath $xmlPath -Encoding utf8
try {
    Dism.exe /Online /Import-DefaultAppAssociations:"$xmlPath"
    Write-Host "Successfully imported default app associations."
} catch {
    Write-Host "Failed to import default app associations. Error: $_"
}

# Install Sogou Pinyin
Write-Host "Installing Sogou Pinyin..."
choco install sogou-pinyin -y --force

Write-Host "Chrome and Sogou Pinyin installation script finished."
