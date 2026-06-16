# DOX framework

DOX is a hierarchy of AGENTS.md files that keeps a project understandable. Each folder's AGENTS.md is the local contract for everything beneath it; together they form a tree from the repository root down to each work area. Follow DOX across every edit in this project.

## Core Contract

- Each AGENTS.md is the binding contract for its subtree.
- Any work product, source material, instruction, record, asset, or durable doc must stay understandable from the nearest AGENTS.md plus every AGENTS.md above it.
- No child doc may weaken a rule set by a parent doc.

## Hierarchy

- The root AGENTS.md holds project-wide instructions, global preferences, durable workflow rules, and the top-level Child DOX Index.
- Each child AGENTS.md owns the instructions for its own folder and lists its own children.
- The closer a doc is to the work, the more specific and practical it is. Broad rules live in parents; concrete details live in children.
- Each parent explains what its direct children cover and what the parent keeps for itself.

## Child Doc Shape

A child AGENTS.md uses these sections, in this order. Omit a section if it would be empty — except keep the Child DOX Index and mark it `(none)` at a leaf, so the tree stays explicit.

- **Purpose** — what this folder is for.
- **Ownership** — what this doc governs and what it leaves to parent or child docs.
- **Local Contracts** — rules, interfaces, or constraints specific to this folder.
- **Work Guidance** — current standards or user instructions for work here. Leave empty if none exist yet.
- **Verification** — how to check work here (tests, lint, build). Leave empty if no such check exists yet.
- **Child DOX Index** — one line per direct child AGENTS.md, naming what it covers.

Example child AGENTS.md:

```markdown
# services/auth

## Purpose
Authentication service: login, sessions, and token issuance.

## Ownership
Owns code under services/auth/. Database schema is owned by ../db.

## Local Contracts
- All endpoints return the shared Error shape from ../shared/errors.
- Never log raw tokens.

## Verification
- `npm test` in this folder must pass before any commit.

## Child DOX Index
- (none)
```

## Initialization

Run this when asked to initialize or index the project.

1. **Map the repo.** List the directory tree, skipping vendored, build, and version-control dirs (node_modules, dist, .git, and similar). Note each top-level area and its purpose.
2. **Pick boundaries.** Create a child AGENTS.md for a folder only when it is a durable boundary — it has its own purpose, its own audience, or its own build/run/test story (for example src/, services/<name>/, docs/, infra/). When unsure, do not create one; the nearest parent covers it.
3. **Stay shallow first.** Cover the root plus the obvious top-level areas. Go deeper only where a subtree is clearly its own domain. Aim for the fewest docs that keep the project understandable.
4. **Write the docs.** Keep the DOX rules in the root AGENTS.md. Write each child using Child Doc Shape above. Leave Work Guidance and Verification empty where no standard or check exists yet.
5. **Wire the indexes.** In every doc that has children, fill the Child DOX Index with one line per direct child, naming what it covers.
6. **Report.** State the tree you created and name any folder you deliberately left without a doc.

Done when: the root Child DOX Index is populated, every boundary folder has an AGENTS.md, and no Child DOX Index still reads "Not yet indexed."

## Read Before Editing

Before editing any file:

1. Read the root AGENTS.md.
2. List the files and folders you expect to touch.
3. For each target, walk from the root down to it, reading every AGENTS.md along the way.
4. Treat the nearest AGENTS.md as the local contract and the parents as repo-wide rules.
5. If two docs conflict, the closer one controls local details — but no child may weaken DOX itself.

Re-read the applicable chain in the current session. Do not rely on memory.

## Update After Editing

Every meaningful change requires a DOX pass before the task is done. Update the closest owning AGENTS.md when a change affects:

- purpose, scope, ownership, or responsibilities;
- durable structure, contracts, workflows, or operating rules;
- required inputs, outputs, permissions, constraints, side effects, or artifacts;
- user preferences about behavior, communication, process, organization, or quality;
- any AGENTS.md creation, deletion, move, rename, or index change.

Update a parent when parent-level structure, ownership, workflow, or its child index changes. Update a child when a parent change alters its local rules. Remove stale or contradictory text immediately. A change that alters no behavior or contract may leave docs unchanged — but still do the pass to confirm that.

## Style

- Keep docs concise, current, and operational. Document stable contracts, not history.
- Prefer direct bullets with explicit names.
- Do not duplicate a rule across files unless each scope needs its own version.
- Delete stale notes instead of explaining how things used to be.
- Trim obvious statements, repeated rules, misplaced detail, and warnings for risks that no longer exist.

## Closeout

1. Re-check changed paths against the DOX chain.
2. Update the nearest owning docs and any affected parents or children.
3. Refresh every affected Child DOX Index.
4. Remove stale or contradictory text.
5. Run existing verification when relevant.
6. Report any docs you intentionally left unchanged and why.

## User Preferences

When the user requests a durable behavior change, record it here or in the relevant child AGENTS.md.

## Child DOX Index

_Not yet indexed._ Run the Initialization procedure above: scan the project, build the DOX tree, and replace this line with the actual index.
