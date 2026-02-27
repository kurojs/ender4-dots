# Add WinaeroTweaker exclusions: folder + process (needed for AMSI bypass)
Add-MpPreference -ExclusionPath 'C:\Program Files\Winaero Tweaker' -ErrorAction SilentlyContinue
Add-MpPreference -ExclusionProcess 'WinaeroTweaker.exe' -ErrorAction SilentlyContinue

# Also remove the threat from history so it stops triggering
$threat = Get-MpThreat -ErrorAction SilentlyContinue | Where-Object { $_.ThreatID -eq 2147927549 }
if ($threat) {
    Remove-MpThreat -ThreatID 2147927549 -ErrorAction SilentlyContinue
    "Threat removed from history" | Add-Content 'C:\Users\kuuro\.config\yasb\scripts\winaero_fix_out.txt'
}

$prefs = Get-MpPreference
"ExclusionPath: $($prefs.ExclusionPath)" | Set-Content 'C:\Users\kuuro\.config\yasb\scripts\winaero_fix_out.txt' -Encoding UTF8
"ExclusionProcess: $($prefs.ExclusionProcess)" | Add-Content 'C:\Users\kuuro\.config\yasb\scripts\winaero_fix_out.txt'
"Done" | Add-Content 'C:\Users\kuuro\.config\yasb\scripts\winaero_fix_out.txt'
