$ErrorActionPreference = "Stop"

# ===============================
# 1. 下载并安装软件（所有用户）
# ===============================

$downloadUrl = "https://clouddrive.huawei.com/f/89208a85de5562f0f292be80ee903a63"
$downloadDir = "$env:TEMP\custom_app"
$installerPath = "$downloadDir\installer.exe"

New-Item -ItemType Directory -Force -Path $downloadDir | Out-Null
Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath -UseBasicParsing

Start-Process -FilePath $installerPath `
    -ArgumentList "/S", "/silent", "/quiet", "/allusers" `
    -Wait

# ===============================
# 2. 创建所有用户桌面快捷方式
# ===============================

$publicDesktop = "C:\Users\Public\Desktop"
$wsh = New-Object -ComObject WScript.Shell

function Create-WebShortcut {
    param (
        [string]$FileName,     # 英文文件名（关键）
        [string]$DisplayName,  # 中文显示名
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
