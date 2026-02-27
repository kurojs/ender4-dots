# matrix.ps1 — generates a random stream of sci-fi unicode characters
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$chars = [char[]]([char]0x30A0..[char]0x30F3) + [char[]]@(
    [char]0x221E, [char]0x2605, [char]0x2606,
    [char]0x25B2, [char]0x25BC, [char]0x25C6, [char]0x25C7,
    [char]0x2318, [char]0x2020, [char]0x00D7,
    [char]0x03B1, [char]0x03B2, [char]0x03B3, [char]0x03B4,
    [char]0x03BB, [char]0x03C3, [char]0x03C9
)

$result = -join (1..10 | ForEach-Object { $chars[(Get-Random -Maximum $chars.Count)] })
Write-Output $result
