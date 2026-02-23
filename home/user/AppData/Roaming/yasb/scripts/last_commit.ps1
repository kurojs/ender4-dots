# GitHub commits today counter
# Uses Search API which gives accurate count including private repos
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$token = [System.Environment]::GetEnvironmentVariable('YASB_GITHUB_TOKEN', 'User')
$headers = @{ Authorization = "Bearer $token"; 'User-Agent' = 'yasb-widget' }
$choco = [System.Char]::ConvertFromUtf32(0x1F36B)

try {
    $today = (Get-Date).ToString("yyyy-MM-dd")
    $search = Invoke-RestMethod -Uri "https://api.github.com/search/commits?q=author:kurojs+author-date:$today" -Headers $headers -TimeoutSec 5 -ErrorAction Stop
    $count = $search.total_count
    if ($count -eq 1) {
        Write-Output "$choco 1 commit today"
    } else {
        Write-Output "$choco $count commits today"
    }
} catch {
    Write-Output "$choco github"
}
