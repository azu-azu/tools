function Test-RebootRequired {
    $registryPaths = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired",
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending"
    )

    if ($registryPaths | Where-Object { Test-Path $_ }) {
        return $true
    }

    $pending = Get-ItemProperty `
        -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" `
        -Name "PendingFileRenameOperations" `
        -ErrorAction SilentlyContinue

    return [bool]$pending
}

if (Test-RebootRequired) {
    Write-Warning "再起動が必要な可能性があります。夜間処理を始める前に Windows を再起動してください。"
    exit 1
}

Write-Host "再起動待ちは検出されませんでした。"
exit 0
