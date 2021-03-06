$appxlist=get-content "$Script:PSScriptRoot\appx.txt"
Write-Progress -id 1 "Удаление мусорных UWP-приложений (текущий пользователь)"
Get-AppxPackage  | Select-Object name | Foreach-Object {
    Write-Progress -ParentId 1 $_
    $appxlist | select-string $_.Name | Foreach-Object {
        Get-AppxPackage | Where-Object name -eq $_
    } | Remove-AppxPackage
}

Write-Progress -id 1 "Удаление мусорных UWP-приложений (Все пользователи)"
Get-AppxPackage -AllUsers | Select-Object name | Foreach-Object {
    Write-Progress -ParentId 1 $_
    $appxlist | select-string $_.Name | Foreach-Object {
        Get-AppxPackage -AllUsers | Where-Object name -eq $_
    } | Remove-AppxPackage -AllUsers
}

Write-Progress -id 1 "Удаление мусорных APPXProvisioned-прлиожений"
Get-AppxProvisionedPackage -Online | Select-Object displayname | Foreach-Object {
    $appxlist | select-string $_.DisplayName | Foreach-Object {
        Get-AppxProvisionedPackage -Online | Where-Object displayname -eq $_
    } | Select-Object packagename | Foreach-Object {
        Write-Progress -ParentId 1 $_
        Remove-AppxProvisionedPackage -Online -PackageName $_.packagename
    }
}
