$ErrorActionPreference = "Stop"

# ===============================
# 基本参数
# ===============================

$downloadUrl  = "https://github.com/linjuming/freeRPD1/releases/download/v1.0/mt.exe"
$workDir      = "C:\Temp\mt-install"
$installer    = "$workDir\mt.exe"

$publicDesktop = "C:\Users\Public\Desktop"

# ===============================
# 1. 下载真正的安装包
# ===============================

Write-Host "Preparing work directory..."
New-Item -ItemType Directory -Force -Path $workDir | Out-Null

Write-Host "Downloading installer from GitHub Releases..."
Invoke-WebRequest -Uri $downloadUrl -OutFile $installer -UseBasicParsing

# 校验文件是否为有效 exe（避免下载到 HTML）
if ((Get-Item $installer).Length -lt 5MB) {
    throw "Downloaded file is too small, not a valid installer."
}

Write-Host "Installer downloaded successfully."

# ===============================
# 2. 安装（所有用户）
# ===============================

Write-Host "Installing software for ALL users..."

# 先尝试静默（如果失败，不阻断）
try {
    Start-Process -FilePath $installer `
        -ArgumentList "/S", "/silent", "/quiet", "/allusers" `
        -Wait
    Write-Host "Silent install attempted."
}
catch {
    Write-Host "Silent install failed, launching installer normally..."
    Start-Process -FilePath $installer -Wait
}

# ===============================
# 3. 创建所有用户桌面快捷方式（网页）
# ===============================

$wsh = New-Object -ComObject WScript.Shell

function Create-WebShortcut {
    param (
        [string]$FileName,
        [string]$DisplayName,
        [string]$Url
    )

    $shortcutPath = Join-Path $publicDesktop "$FileName.lnk"
    Write-Host "Creating shortcut: $DisplayName"

    $shortcut = $wsh.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $Url
    $shortcut.Description = $DisplayName
    $shortcut.IconLocation = "shell32.dll, 220"
    $shortcut.Save()
}

# 华为入会
Create-WebShortcut `
    -FileName "Huawei-Meeting" `
    -DisplayName "华为入会" `
    -Url "https://imeeting.huawei.com/meeting/joinwelink?id=95979031&pwd=MTIzMzIx&token=rz3Uutv1CTht1LP2mGJpNBnBhhJh8Pjq4&stype=0"

# 谷歌远程桌面
Create-WebShortcut `
    -FileName "Google-Remote-Desktop" `
    -DisplayName "谷歌远程桌面连接" `
    -Url "https://remotedesktop.google.com/access/"

Write-Host "All-user desktop shortcuts created successfully."
Write-Host "Installation workflow finished."
