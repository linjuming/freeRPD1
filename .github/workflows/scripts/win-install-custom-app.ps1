$ErrorActionPreference = "Stop"

# ===============================
# 基本参数
# ===============================
$downloadUrl = "https://github.com/linjuming/freeRPD1/releases/download/v1.0/mt.exe"

$publicDesktop = "C:\Users\Public\Desktop"
$fallbackDir    = "D:\"

$mtFileName     = "mt.exe"
$mtPublicPath   = Join-Path $publicDesktop $mtFileName
$mtFallbackPath = Join-Path $fallbackDir $mtFileName

# ===============================
# 1. 准备目录 & 下载 mt.exe
# ===============================
Write-Host "正在下载 mt.exe ..."

# 确保公共桌面存在（一般都存在，但以防万一）
New-Item -ItemType Directory -Force -Path $publicDesktop | Out-Null

Invoke-WebRequest -Uri $downloadUrl -OutFile $mtPublicPath -UseBasicParsing

# 简单校验文件大小（避免下载到错误页面）
if ((Get-Item $mtPublicPath).Length -lt 1MB) {
    throw "下载的文件太小，可能不是有效的 mt.exe，请检查下载链接"
}

Write-Host "mt.exe 已下载到公共桌面: $mtPublicPath"

# 复制一份到 D:\
Write-Host "复制 mt.exe 到 D: 根目录..."
Copy-Item -Path $mtPublicPath -Destination $mtFallbackPath -Force
Write-Host "已复制到: $mtFallbackPath"

# ===============================
# 2. 创建网页快捷方式（公共桌面 + D:\ 各一份）
# ===============================
$wsh = New-Object -ComObject WScript.Shell

function Create-WebShortcut {
    param (
        [string]$BasePath,
        [string]$FileName,
        [string]$DisplayName,
        [string]$Url
    )
    $shortcutPath = Join-Path $BasePath "$FileName.lnk"
    Write-Host "创建快捷方式: $DisplayName → $BasePath"

    $shortcut = $wsh.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $Url
    $shortcut.Description = $DisplayName
    # 使用系统图标（文件夹或浏览器图标）
    $shortcut.IconLocation = "shell32.dll, 220"
    $shortcut.Save()
}

# 定义两个位置
$locations = @(
    @{ Path = $publicDesktop; Desc = "公共桌面" },
    @{ Path = $fallbackDir;    Desc = "D: 根目录"   }
)

foreach ($loc in $locations) {
    $base = $loc.Path

    Create-WebShortcut `
        -BasePath $base `
        -FileName "Huawei-Meeting" `
        -DisplayName "华为入会" `
        -Url "https://imeeting.huawei.com/meeting/joinwelink?id=95979031&pwd=MTIzMzIx&token=rz3Uutv1CTht1LP2mGJpNBnBhhJh8Pjq4&stype=0"

    Create-WebShortcut `
        -BasePath $base `
        -FileName "Google-Remote-Desktop" `
        -DisplayName "谷歌远程桌面连接" `
        -Url "https://remotedesktop.google.com/access/"
}

Write-Host "`n所有操作完成："
Write-Host "  • mt.exe 位于："
Write-Host "    - $mtPublicPath"
Write-Host "    - $mtFallbackPath"
Write-Host "  • 两个网页快捷方式已分别创建在 公共桌面 和 D:\ 根目录"
Write-Host "安装/准备流程结束。"
