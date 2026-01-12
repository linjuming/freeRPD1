$ErrorActionPreference = "Stop"

# ===============================
# 1. 下载并安装软件（所有用户）
# ===============================

$downloadUrl = "https://clouddrive.huawei.com/f/89208a85de5562f0f292be80ee903a63"
$downloadDir = "$env:TEMP\custom_app"
$installerPath = "$downloadDir\installer.exe"

Write-Host "Creating download directory..."
New-Item -ItemType Directory -Force -Path $downloadDir | Out-Null

Write-Host "Downloading software..."
Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath -UseBasicParsing

Write-Host "Download completed."

Write-Host "Installing software for ALL users..."

# 尝试常见全局静默参数
try {
    Start-Process -FilePath $installerPath `
        -ArgumentList "/S", "/silent", "/quiet", "/allusers" `
        -Wait
    Write-Host "Silent install attempted."
}
catch {
    Write-Host "Silent install failed, launching installer normally..."
    Start-Process -FilePath $installerPath
}

# ===============================
# 2. 创建所有用户桌面快捷方式
# ===============================

$publicDesktop = "C:\Users\Public\Desktop"
$wsh = New-Object -ComObject WScript.Shell

function Create-WebShortcut($name, $url) {
    $shortcutPath = Join-Path $publicDesktop "$name.lnk"
    Write-Host "Creating shortcut: $name"

    $shortcut = $wsh.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $url
    $shortcut.IconLocation = "shell32.dll, 220"
    $shortcut.Save()
}

# 华为入会
Create-WebShortcut `
    -name "华为入会" `
    -url "https://imeeting.huawei.com/meeting/joinwelink?id=95979031&pwd=MTIzMzIx&token=rz3Uutv1CTht1LP2mGJpNBnBhhJh8Pjq4&stype=0"

# 谷歌远程桌面
Create-WebShortcut `
    -name "谷歌远程桌面连接" `
    -url "https://remotedesktop.google.com/access/"

Write-Host "All-user desktop shortcuts created successfully."
