# DOX universal workspace installer/updater.
#
# Installs portable Agent Skills for Codex, Google Antigravity, Cline, and
# Claude Code, plus small rule adapters for each host. Run from a project root:
#   irm https://raw.githubusercontent.com/jpbaking/dox/main/install.ps1 | iex
#
# Existing DOX-owned skill and rule files are overwritten on update. Existing
# root AGENTS.md and CLAUDE.md files are never overwritten.
# Override the source with $env:DOX_REPO and $env:DOX_REF.

$ErrorActionPreference = "Stop"

$Repo = if ($env:DOX_REPO) { $env:DOX_REPO } else { "jpbaking/dox" }
$Ref = if ($env:DOX_REF) { $env:DOX_REF } else { "main" }
$Base = "https://raw.githubusercontent.com/$Repo/$Ref"
$Skills = @("dox-init", "dox-child", "dox-audit", "dox-fix", "dox-remap", "dox-upgrade")

function Fetch {
    param(
        [string]$Source,
        [string]$Destination
    )

    $sourceUrl = "$Base/$Source"
    $destinationDirectory = Split-Path -Parent $Destination
    if ($destinationDirectory -and -not (Test-Path $destinationDirectory)) {
        New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
    }
    Invoke-WebRequest -Uri $sourceUrl -OutFile $Destination -UseBasicParsing
    Write-Host "  + $Destination"
}

function Copy-Local {
    param(
        [string]$Source,
        [string]$Destination
    )

    $destinationDirectory = Split-Path -Parent $Destination
    if ($destinationDirectory -and -not (Test-Path $destinationDirectory)) {
        New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
    }
    Copy-Item -Path $Source -Destination $Destination -Force
    Write-Host "  + $Destination"
}

function Has-Text {
    param(
        [string]$Path,
        [string]$Text
    )

    return (Test-Path $Path -PathType Leaf) -and [bool](Select-String -Path $Path -SimpleMatch $Text -Quiet)
}

Write-Host "DOX universal workspace install from $Repo@$Ref"
Write-Host "  into $(Get-Location)"

# Codex, Antigravity, and current Cline share the open .agents location.
# Claude Code uses the same skill format from its own discovery directory,
# so each skill is fetched once and copied there.
foreach ($skill in $Skills) {
    Fetch "skills/shared/$skill/SKILL.md" (Join-Path ".agents\skills" "$skill\SKILL.md")
    Copy-Local (Join-Path ".agents\skills" "$skill\SKILL.md") (Join-Path ".claude\skills" "$skill\SKILL.md")
}

# The rule text is shared; only its discovery path is host-specific.
Fetch "rules/shared/dox.md" ".agents\rules\dox.md"
foreach ($ruleFile in @(".claude\rules\dox.md", ".clinerules\dox.md")) {
    Copy-Local ".agents\rules\dox.md" $ruleFile
}

# Codex discovers AGENTS.md. Antigravity and Cline also understand it.
if (-not (Test-Path "AGENTS.md")) {
    Fetch "AGENTS.md" "AGENTS.md"
} elseif (Has-Text "AGENTS.md" "# DOX framework") {
    Write-Host "  ! AGENTS.md is a legacy (pre-v3) DOX framework root; run the dox-upgrade skill to migrate it"
} elseif (-not (Has-Text "AGENTS.md" "DOX.md")) {
    Write-Host "  ! kept existing AGENTS.md; make sure it tells agents to read DOX.md"
} else {
    Write-Host "  = kept existing AGENTS.md"
}

# Claude Code discovers CLAUDE.md and supports importing AGENTS.md.
if (-not (Test-Path "CLAUDE.md")) {
    Fetch "CLAUDE.md" "CLAUDE.md"
} elseif (-not (Has-Text "CLAUDE.md" "AGENTS.md") -and -not (Has-Text "CLAUDE.md" "DOX.md")) {
    Write-Host "  ! kept existing CLAUDE.md; add @AGENTS.md or tell Claude to read DOX.md"
} else {
    Write-Host "  = kept existing CLAUDE.md"
}

# Installed adapters are generated files; keep them out of the target's history.
$GitignoreMark = "# DOX installer-managed agent adapters (generated; do not edit or commit)"
if (Has-Text ".gitignore" $GitignoreMark) {
    Write-Host "  = kept existing .gitignore DOX adapter block"
} else {
    $entries = @($GitignoreMark)
    foreach ($skill in $Skills) {
        $entries += ".agents/skills/$skill/"
        $entries += ".claude/skills/$skill/"
    }
    $entries += @(".agents/rules/dox.md", ".claude/rules/dox.md", ".clinerules/dox.md")
    $block = ($entries -join "`n") + "`n"
    if ((Test-Path ".gitignore") -and (Get-Item ".gitignore").Length -gt 0) {
        $block = "`n" + $block
    }
    Add-Content -Path ".gitignore" -Value $block -NoNewline
    Write-Host "  + .gitignore (DOX adapter entries; AGENTS.md / CLAUDE.md bridges stay tracked)"
}

Write-Host "Done. Installed skills: $($Skills -join ', ')"
Write-Host "Next: ask your agent to use the dox-init skill to add the framework."
Write-Host 'Explicit syntax varies: Codex uses a $ skill mention; Claude, Antigravity, and Cline support /dox-init.'
