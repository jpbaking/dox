# DOX — installer/updater for the Cline skills and rule.
#
# Workspace install (run from your project root):
#   irm https://raw.githubusercontent.com/jpbaking/dox/main/install-cline.ps1 | iex
# Global install (all projects):
#   $env:DOX_GLOBAL = "1"; irm https://raw.githubusercontent.com/jpbaking/dox/main/install-cline.ps1 | iex
#
# Existing DOX skill/rule files are overwritten, so re-running updates them.
# Override the source with $env:DOX_REPO (owner/repo) and $env:DOX_REF (branch or tag).

$ErrorActionPreference = "Stop"

$Repo = if ($env:DOX_REPO) { $env:DOX_REPO } else { "jpbaking/dox" }
$Ref = if ($env:DOX_REF) { $env:DOX_REF } else { "main" }
$Base = "https://raw.githubusercontent.com/$Repo/$Ref"
$Skills = @("dox-init", "dox-child", "dox-audit", "dox-fix", "dox-remap", "dox-upgrade")

$Mode = if ($env:DOX_GLOBAL) { "global" } else { "workspace" }

if ($Mode -eq "global") {
    $SkillsDir = Join-Path $HOME ".cline\skills"
    $RulesDir = Join-Path $HOME "Documents\Cline\Rules"
} else {
    $SkillsDir = ".cline\skills"
    $RulesDir = ".clinerules"
}

function Fetch {
    param(
        [string]$Src,
        [string]$Dest
    )
    $srcUrl = "$Base/$Src"
    $destDir = Split-Path -Parent $Dest
    if ($destDir -and -not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }
    Invoke-WebRequest -Uri $srcUrl -OutFile $Dest -UseBasicParsing
    Write-Host "  + $Dest"
}

Write-Host "DOX Cline install ($Mode) from $Repo@$Ref"
if ($Mode -eq "workspace") {
    Write-Host "  into $(Get-Location)"
}

foreach ($s in $Skills) {
    Fetch "skills/cline/$s/SKILL.md" (Join-Path $SkillsDir "$s\SKILL.md")
}
Fetch "rules/cline/dox.md" (Join-Path $RulesDir "dox.md")

Write-Host "Done. Skills: /dox-init /dox-child /dox-audit /dox-fix /dox-remap /dox-upgrade"
Write-Host "Note: this does not add the framework itself - run /dox-init in Cline"
Write-Host "(or copy DOX.md from https://github.com/$Repo) to set up a project."
