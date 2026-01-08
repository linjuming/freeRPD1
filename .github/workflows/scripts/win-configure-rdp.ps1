# Configure Core RDP Settings and firewall
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0 -Force
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "UserAuthentication" -Value 0 -Force
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "SecurityLayer" -Value 0 -Force
netsh advfirewall firewall delete rule name="RDP-Tailscale"
netsh advfirewall firewall add rule name="RDP-Tailscale" dir=in action=allow protocol=TCP localport=3389
Restart-Service -Name TermService -Force

# add by linjuming 2026-01-09
# 禁用 RDP 会话锁屏 / 断开后要求密码
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -Name "fPromptForPassword" -Value 0 -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -Name "fEnableScreenSaver" -Value 0 -Type DWord

# 禁用系统级屏保
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Control Panel\Desktop" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Control Panel\Desktop" -Name "ScreenSaveActive" -Value 0 -Type String
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Control Panel\Desktop" -Name "ScreenSaveTimeOut" -Value "0" -Type String
