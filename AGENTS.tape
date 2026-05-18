#!/usr/bin/env tape
# AGENTS.tape for `dancinlab/hexa-os`

@V := "tape" :: spec [active]
  version = "1.2"

@X hexa_verify := "hexa verify — verification via hexa CLI only" :: guide [active]
  tldr = "Any correctness / purity / grade / identity claim → verify with `hexa <verb>` or `hexa run <verifier>.hexa` (e.g. `hexa run tool/atlas_verify.hexa`) and paste the verdict VERBATIM. NEVER cite sympy / PyPhi / Wolfram / Mathematica output as evidence."
  detail = "~/core/atlas/VERIFY.tape"

@X wilson_pool := "wilson pool — resource utilization" :: guide [active]
  tldr = "Heavy / deterministic work (build · drill · probe · compile · test-sweep · GPU fire) → do NOT serialize on localhost; route to the host pool: `wilson pool list` then `wilson pool on <host> <cmd>`, or a ToolUse `\"host\"` field. Empty roster = degrade-to-local, fine."
  detail = "~/core/atlas/POOL.tape"

@I id001 := "hexa-os" :: identity-claim [d=2026-05-14 active]
  kind = "HEXA-OS family — operating systems"
  brief = "HEXA-OS family · operating systems"
  parent = "dancinlab"

@L l1 := "repo-layout" :: structure [active]
  .hexa-attrs -> "file"
  .loop -> "file"
  .raw-ref -> "file"
  .roadmap.hexa_os_boot -> "file"
  .roadmap.hexa_os_design -> "file"
  .roadmap.hexa_os_kernel -> "file"
  .roadmap.hexa_os_self_mk2_tuning -> "file"
  AGENTS.tape -> "this file · governance + identity (.tape v1.2)"
  CITATION.cff -> "file"
  CLAUDE.md -> "symlink → AGENTS.tape"
  hexa.toml -> "TOML config"
  LATTICE_POLICY.md -> "project-local copy of dancinlab real-limits standard"
  LIMIT_BREAKTHROUGH.md -> "per-domain HARD/SOFT_WALL · BREAKABLE_WITH_TECH · UNCLEAR audit"
  project.hexa -> "hexa-lang source"
  README.md -> "human intro · 18-block format (atlas/README-FORMAT.md)"
  ROADMAP.md -> "phased plan"
  TAPE-AUDIT.md -> ".tape v1.x adoption audit ledger"
  .hexa-init/ -> "subdir (1 items)"
  .hook-commands/ -> "subdir (1 items)"
  cli/ -> "subdir (1 items)"
  docs/ -> "documentation (4 items)"
  hexa-ios/ -> "subdir (1 items)"
  hexa-macos/ -> "subdir (2 items)"
  hexa_os_mk2_rewrite/ -> "subdir (1 items)"
  hexa_os_self_mk2_tuning/ -> "subdir (1 items)"
  self/ -> "self-hosted compiler (1 items)"
  state/ -> "runtime state (gitignored typically) (2 items)"
  unified-service/ -> "subdir (1 items)"
  verify/ -> "verification scripts (5 items)"

@D g_inherit := "inherits-lattice-policy" :: governance [required]
  rule = "All echoes/LATTICE_POLICY.md rules apply — real-limits-first · lattice-is-tool · verification-anchor-real-limit · no-artificial-ceilings · honesty-obligation-external."
  authority = "[@x_lattice_policy]"
  @> AGENTS.md

@D g1 := "real-limits-first" :: governance [required]
  rule = "The project's ceiling is set by REAL math/physics/engineering limits, NEVER by the n=6 invariant lattice."
  authority = "[@x_lattice_policy]"
  @> AGENTS.md

@D g2 := "lattice-is-tool" :: governance [required]
  rule = "n=6 lattice is a TOOL, not a CONSTRAINT. Use only where it naturally fits."
  <: g1
  @> AGENTS.md

@D g3 := "honesty-obligation-external" :: governance [required deny:write]
  rule = "Claims about external entities (companies · fabs · vendors) must NOT include lattice-fit assertions. Use their OWN invariants."
  @> AGENTS.md

@D g4 := "commit-conventions" :: governance [recommended]
  rule = "AI-assisted commits include \`Co-Authored-By: <model> <noreply@anthropic.com>\` trailer; Conventional Commits title."
  @> AGENTS.md

@D g_arch_vs_log_split := "v1.2 architecture-vs-history split" :: governance [required d=2026-05-14 active]
  rule = "UPPERCASE.tape files are EDITABLE architecture (latest-wins per id). Append-only event history lives in UPPERCASE.log.tape siblings."
  why = "declarative entries (governance · config · layout · identity) evolve naturally; locking them as append-only via ~> supersedes creates noisy histories. The split lets architecture stay current and history stay immutable."
  applies-to = "AGENTS.tape · all UPPERCASE.tape root files"
  authority = "[@x_tape_spec] §Domain-tape sibling §Architecture-vs-history split"
  @> AGENTS.md


@F f1 := "lattice-fit-on-external-entity" :: governance [required deny:write]
  pattern = "applying n=6 lattice as derivation rule to TSMC · ASML · IPCC · NASA · SpaceX · CERN · DeepMind · NIST · or any external vendor"
  exception = "values may coincidentally match — observation OK, derivation NOT OK"

@X x_lattice_policy := "echoes/LATTICE_POLICY.md" :: policy [d=2026-05-12 active]
  url = "https://github.com/dancinlab/echoes/blob/main/LATTICE_POLICY.md"

@X x_tape_spec := "tape v1.2 spec" :: spec [d=2026-05-14 active]
  url = "https://github.com/dancinlab/tape/blob/main/spec/tape.md"
  scope = "this file's grammar reference"

@H h1 := "agents-md-replaced" :: generator [active]
  note = "AGENTS.md replaced by this AGENTS.tape (tape v1.2)"

@H h2 := "claude-md-symlink" :: generator [active]
  rule = "CLAUDE.md → AGENTS.tape symlink"
  command = `ln -sf AGENTS.tape CLAUDE.md`
