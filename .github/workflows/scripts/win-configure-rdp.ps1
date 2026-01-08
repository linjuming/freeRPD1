# Configure Core RDP Settings and firewall
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0 -Force
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "UserAuthentication" -Value 0 -Force
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "SecurityLayer" -Value 0 -Force
netsh advfirewall firewall delete rule name="RDP-Tailscale"
netsh advfirewall firewall add rule name="RDP-Tailscale" dir=in action=allow protocol=TCP localport=3389
Restart-Service -Name TermService -Force

# add by linjuming 2026-1-9
# 禁用RDP断开时锁屏
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -Name "fEnableScreenSaver" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -Name "fPromptForPassword" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Value 0 -Type DWord -Force

# 禁用屏幕保护和空闲锁屏
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "ScreenSaveActive" -Value 0 -Force
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "ScreenSaverIsSecure" -Value 0 -Force
Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Control Panel\Desktop" -Name "ScreenSaveTimeOut" -Value 0 -Force

# 应用组策略更新（可选，重启后生效，但Actions中可强制刷新）
gpupdate /force
