$ErrorActionPreference = "Stop"

$downloadUrl = "https://clouddrive.huawei.com/f/89208a85de5562f0f292be80ee903a63"
$downloadDir = "C:\Temp\HuaweiDownload"

New-Item -ItemType Directory -Force -Path $downloadDir | Out-Null

# ===============================
# 1. 用 Edge 触发真实下载
# ===============================

$edge = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"

Write-Host "Launching Edge to download installer..."

Start-Process $edge `
  -ArgumentList @(
    "--no-first-run",
    "--disable-popup-blocking",
    "--disable-extensions",
    "--disable-infobars",
    "--user-data-dir=$downloadDir\profile",
    "--download-default-directory=$downloadDir",
    "--download-prompt-for-download=false",
    $downloadUrl
  )

# ===============================
# 2. 等待真正的安装包出现
# ===============================

Write-Host "Waiting for installer download..."

$timeout = 300
$elapsed = 0
$installer = $null

while ($elapsed -lt $timeout) {
    $files = Get-ChildItem $downloadDir -File |
        Where-Object {
            $_.Extension -match "\.(exe|msi)$" -and $_.Length -gt 5MB
        }

    if ($files) {
        $installer = $files[0].FullName
        break
    }

    Start-Sleep 5
    $elapsed += 5
}

if (-not $installer) {
    throw "Installer download failed or not detected."
}

Write-Host "Installer detected: $installer"

# ===============================
# 3. 安装（所有用户）
# ===============================

if ($installer.EndsWith(".msi")) {
    Start-Process "msiexec.exe" `
        -ArgumentList "/i `"$installer`" /qn ALLUSERS=1" `
        -Wait
} else {
    Start-Process $installer `
        -ArgumentList "/S", "/silent", "/quiet", "/allusers" `
        -Wait
}

Write-Host "Software installed successfully."
