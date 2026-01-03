# Install Chinese (Simplified) language pack
Install-Language zh-CN -CopyToSettings

# Set the system locale
Set-SystemLocale -SystemLocale zh-CN

# Set the display language
Set-WinUILanguageOverride -Language zh-CN

# Set the user language list
$list = New-WinUserLanguageList -Language "zh-CN"
$list.Add("en-US")
Set-WinUserLanguageList -LanguageList $list -Force

# Set the input method
Set-WinDefaultInputMethodOverride -InputTip "0804:00000804"
