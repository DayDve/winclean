# Remove Microsoft OneDrive Client Script
function Update-Acl {
    param (
        $Path
    )
    # Take Ownsership 
    Write-Progress -ParentId 1 "Исправляем права на: $Path"
    $Acl = Get-ACL -Path $Path
    $curUsr = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    [System.Security.Principal.NTAccount]$Owner = $curUsr
    $Ar = New-Object  system.security.accesscontrol.filesystemaccessrule($curUsr,"FullControl","Allow")
    $Acl.SetOwner($Owner)
    $Acl.SetAccessRule($Ar)
    Set-Acl -Path $Path -AclObject $Acl
}

function Remove-Garbage {
    param (
        $Path,
        $GrbName=$Path
    )
    Remove-Item -Path $Path -Force -Recurse -ErrorAction SilentlyContinue
    Write-Progress -ParentId 1 "Удалено: $GrbName"
}

$ODSetupPath = "$env:SystemRoot\SysWOW64\OneDriveSetup.exe"
$targetPaths = @{
    "$ODSetupPath" = "OneDriveSetup.exe"
    "$env:SystemRoot\SysWOW64\OneDriveSettingSyncProvider.dll" = "OneDriveSettingSyncProvider.dll"
    "$env:SystemRoot\SysWOW64\OneDrive.ico" = "OneDrive icon"
    "$env:LOCALAPPDATA\Microsoft\OneDrive" = "LocalAppData OneDrive"
    "$env:ProgramData\Microsoft OneDrive" = "ProgramData OneDrive"
    "C:\OneDriveTemp" = "OneDriveTemp"
}
Write-Progress -id 0 "Удаление OneDrive" -Status "=============================="
Write-Progress -id 1 -ParentId 0 "Принудительно останавливаем OneDrive" -Status "..."
Stop-Process -Name "OneDrive.exe" -Force -ErrorAction SilentlyContinue

if (Test-Path $ODSetupPath){
    Write-Progress -id 1 -ParentId 0 "Деинсталлируем OneDrive" -Status "..."
    Start-Process -FilePath $ODSetupPath -ArgumentList @("/uninstall") -Wait -NoNewWindow -ErrorAction SilentlyContinue
}
Write-Progress -id 1 -ParentId 0 "Подчищаем хвосты" -Status "..."

foreach ($target in $targetPaths.Keys) {
    if (Test-Path $target) {Update-Acl -Path $target}
}

Write-Progress -ParentId 1 "Чистим реестр..." -Status "..."
New-PSDrive -PSProvider registry -Root "HKEY_CLASSES_ROOT" -Name "HKCR" -ErrorAction SilentlyContinue| Out-Null
"","Wow6432Node\" | ForEach-Object {Remove-Item -Path "HKCR:$($_)CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Force -ErrorAction SilentlyContinue}
Remove-PSDrive HKCR -ErrorAction SilentlyContinue

Write-Progress -ParentId 1 "Перезапускаем Проводник (чтобы освободился FileSyncShell64.dll)" -Status "..."
Stop-Process -Name "explorer" -Force

foreach ($target in $targetPaths.Keys) {
    if (Test-Path $target) {Remove-Garbage -Path $target -GrbName $targetPaths[$target]}
}
