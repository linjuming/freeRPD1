# .github/workflows/scripts/win-create-user.ps1

# --- 删除了原来复杂的密码生成逻辑 ---
# 直接设置一个简单的密码
$password = "inHeart@007"
# ------------------------------------

# 将明文密码转换为安全字符串，后续步骤需要
$securePass = ConvertTo-SecureString $password -AsPlainText -Force

# 创建用户并设置密码永不过期
New-LocalUser -Name "vum" -Password $securePass -AccountNeverExpires

# 将用户添加到管理员组和远程桌面用户组
Add-LocalGroupMember -Group "Administrators" -Member "vum"
Add-LocalGroupMember -Group "Remote Desktop Users" -Member "vum"

# 将凭据输出到 GitHub Actions 的环境变量中，以便后续步骤使用
echo "RDP_CREDS=User: vum | Password: $password" >> $env:GITHUB_ENV

# 检查用户是否创建成功
if (-not (Get-LocalUser -Name "vum")) { throw "User creation failed" }
