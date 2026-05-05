---
schema: hexa-os/docs/self_mk2_tuning_landed/ai-native/1
last_updated: 2026-05-02
ssot:
  domain_roadmap:   .roadmap.hexa_os_self_mk2_tuning
  marker:           state/markers/hexa_os_self_mk2_tuning_landed.marker
  probe_preserved:  self/os/_freestanding_probe.hexa
  local_rules:      .own-rules.json
  upstream_lang:    hexa-lang (P7-9 fixpoint blocker)
  sister_baseline:  /Users/<user>/core/hive/tool/ai_native_module_readme_lint.hexa
audience: AI
raws_conformant: [9, 10, 270, 271, 272, 273]
roadmap_entry: hexa_os_self_mk2_tuning
---

# hexa-os self/ mk2 tuning — landing handoff

Audience: AI agent reading this cold. Friendly preset = analogy + ASCII map +
phase checklist + raw#10 caveats + file index. The land mode is **strictly
additive**; nothing is migrated and nothing is rewritten in place.

---

## TL;DR (60-second briefing)

- **What.** Domain plan + scaffolding contract for tuning hexa-os `self/`
  tree to mk2 conventions (core+module split + per-group README.ai.md +
  marker/handoff convention). Plan only at this land — no code added under
  `self/core/` or `self/modules/` yet, because all concrete kernel work is
  upstream-blocked by hexa-lang P7-9 fixpoint.
- **Why.** hexa-os currently has exactly one `.hexa` file (`self/os/
  _freestanding_probe.hexa`, 31 LOC skeleton). It already conforms to
  freestanding (HOS1) but does not yet observe the cross-repo
  core+module+README.ai.md convention adopted by anima/hive (raws 270/271).
  The mk2 tuning lays the convention contract so when upstream unblocks,
  the first kernel module pair lands directly into a conformant shape.
- **Land mode.** Additive only. The single existing source file
  (`self/os/_freestanding_probe.hexa`) is preserved byte-identical.
  Migration is explicitly forbidden by directive.
- **Cost.** $0 (mac-local plan + scaffolding contract; no GPU, no LLM).
- **Selftest.** Domain `.roadmap` parses as one JSON object per line after
  header; `state/markers/<name>.marker` follows anima sister-repo schema.

---

## Architecture map (analogy + ASCII)

The structure mirrors a **construction site with permits posted before
breaking ground**: every future module pair (core/ + modules/) is
permitted (READMEs declare what will live there) before any code is poured.
The probe file is the existing tool shed left untouched on the lot — work
goes around it, not through it.

```
hexa-os/
  .raw-ref                         (canonical hexa-lang .raw mirror pin — UNCHANGED)
  .own-rules.json                  (L1 5-rule local rules: HOS1..HOS5 — UNCHANGED)
  project.hexa                     (root marker — UNCHANGED, raw 272 debt flagged)
  .roadmap.hexa_os_self_mk2_tuning (NEW — mk2-schema domain SSOT)
  docs/
    hexa_os_self_mk2_tuning_landed_2026_05_02.ai.md  (NEW — this file)
  state/markers/
    hexa_os_self_mk2_tuning_landed.marker            (NEW — completion attestation)
  self/
    os/
      _freestanding_probe.hexa     (UNTOUCHED — additive-only mandate)
    core/                          (PLANNED phase.2 — empty until first module pair)
    modules/                       (PLANNED phase.2 — empty until first module pair)
```

The mk2 contract:

```
                 ┌─────────────────────────────────────────────┐
                 │  .roadmap.hexa_os_self_mk2_tuning (mk2)     │
                 │  domain SSOT, owner perspective             │
                 └────────────────┬────────────────────────────┘
                                  │
              ┌───────────────────┼───────────────────┐
              ▼                   ▼                   ▼
       ┌─────────────┐    ┌──────────────┐    ┌──────────────┐
       │ phase.1     │    │ phase.2      │    │ phase.3      │
       │ restore +   │    │ first module │    │ law_kernel   │
       │ scaffold    │    │ pair (boot)  │    │ pair         │
       └─────────────┘    └──────────────┘    └──────────────┘
              │                   │                   │
              └───────────────────┼───────────────────┘
                                  ▼
                          ┌──────────────┐
                          │ phase.4      │
                          │ handoff +    │
                          │ marker (now) │
                          └──────────────┘
```

---

## Domain analysis (what hexa-os actually contains today)

| dimension | finding |
|-----------|---------|
| repo size | 364K disk, ~10 top-level entries |
| source code | 1 `.hexa` file (`self/os/_freestanding_probe.hexa`, 31 LOC, skeleton) |
| design docs | 4 markdown (BRAINSTORM 124-item, DEPLOYMENT matrix, HEXA_SERVE_V01 6-phase, PERF_P99 mechanism) |
| L1 rules | 5 (`.own-rules.json`: HOS1..HOS5 — freestanding, no .c, law invariant, single addr space, virtio-only) |
| upstream pin | `.raw-ref` → hexa-lang .raw (pinned-hash placeholder, never synced) |
| working tree | uncommitted: deleted `.own`, deleted `.roadmap`, modified `.gitignore` (mk2 .workspace exclusion), untracked `.hook-commands/` |
| recent commit cadence | Apr 19 init → Apr 21 SSOT scaffold → Apr 23 project.hexa → May 2 README badges |
| compile status | nothing compiles (P7-9 blocker; probe is `// 지금은 placeholder`) |

The repo is in **design + brainstorm phase**, not implementation phase.
Every line of forward kernel work waits on hexa-lang.

---

## raw 270/271/272/273 plan (the triplet)

The directive references the `raw 270/271/272/273` quartet (see anima
`raw_270_271_core_module_readme_ai_native_landed.marker` for canonical
text + hexa-lang `modules/attr_format/README.ai.md` cross-link).

| raw | what it requires | hexa-os today | mk2 plan |
|-----|------------------|---------------|----------|
| 270 | core+module split for any new `*/modules/<group>/` directory | not yet applicable (0 modules) | scaffold `self/core/` + `self/modules/` empty in phase.1; first split lands in phase.2 (boot module pair) |
| 271 | README.ai.md per group with frontmatter (schema, last_updated, ssot) + 4 sections (TL;DR, API, Caveats\|Failure, File index) | only README.md (project root) | per-group README.ai.md committed alongside each new module pair (phase.2+) |
| 272 | BR-NO-USER-VERBATIM (no `/Users/<name>/` paths or @-handles in committed text) | violation: `project.hexa` line 17 has a `/Users/<name>/core/hexa-lang` literal | flagged as pre-existing debt; additive-only honors this by NOT touching project.hexa; tracked in `.roadmap.hexa_os_self_mk2_tuning` cond.7 |
| 273 | additive-only land (no destructive migration, no in-place rewrite) | mandate honored | every phase explicitly forbids touching `self/os/_freestanding_probe.hexa` byte-identical preservation verifier |

The triplet (technically a quartet) collectively defines the **mk2 module
shape**: every new code group is a triple (core/<group>/, modules/<group>/,
README.ai.md), landed additively, with no user-identifying strings.

---

## Phases (plan, not execution — compute-bound on upstream)

### phase.1 — restore + scaffold (1-2 days, $0)

1. User decides: A=`git restore .own .roadmap` (preserve L1 inheritance) /
   B=rewrite as mk2-shaped. Bg subagent does NOT decide unilaterally
   (uncommitted deletions are user-domain).
2. `mkdir self/core/ self/modules/` — empty scaffolding only.
3. Emit `.ai-native-readme-baseline` to grandfather pre-existing
   `self/os/` skeleton (1-line entry: `grandfathered/self/os`).
4. Run `hive/tool/ai_native_module_readme_lint.hexa` against hexa-os root;
   register baseline conformance (expected: groups_found=0,
   conformant=0, grandfathered=1, violations=0 → PASS).

### phase.2 — first module pair land (3-5 days, $0)

1. Candidate first split: `self/core/boot/` (UEFI stub fn signatures only,
   no impl) + `self/modules/boot/uefi.hexa` (impl skeleton, depends on
   `@nostd` + linker script — both upstream-blocked).
2. README.ai.md per group (frontmatter + 4 sections).
3. `hexa run self/core/boot/boot_main.hexa --selftest` (only feasible once
   hexa-lang P7-9 lands; until then, syntax-only check).

### phase.3 — law kernel module pair (1-2 weeks, $0)

1. `self/core/law_kernel/` (raw.json loader fn signatures + law_check
   trait skeleton).
2. `self/modules/law_kernel/raw_loader.hexa` (impl, depends on hexa-lang
   stdlib YAML/JSON parser).
3. Synthetic raw.json → law_check pass/fail dispatch golden test.
4. Wire to `growth_bus` event log skeleton (signatures only, no logging
   backend wired this phase — appliance backend is its own future cycle).

### phase.4 — handoff + marker (~1 hour, $0) ← THIS LAND

1. This document (`docs/hexa_os_self_mk2_tuning_landed_2026_05_02.ai.md`).
2. Marker (`state/markers/hexa_os_self_mk2_tuning_landed.marker`).
3. Future: append entry to `state/proposals/inventory.json` with completion
   record (deferred — additive-only avoids writing to inventory until user
   accepts).

---

## File index

| path | purpose | new? |
|------|---------|------|
| `.roadmap.hexa_os_self_mk2_tuning` | mk2-schema domain SSOT (1 header + 4 phases + 7 caveats) | NEW |
| `docs/hexa_os_self_mk2_tuning_landed_2026_05_02.ai.md` | this handoff | NEW |
| `state/markers/hexa_os_self_mk2_tuning_landed.marker` | completion attestation (anima-sister schema) | NEW |
| `self/os/_freestanding_probe.hexa` | pre-existing skeleton — UNTOUCHED | preserved |
| `self/core/` | future scaffold — phase.1 will mkdir, empty until phase.2 | planned |
| `self/modules/` | future scaffold — phase.1 will mkdir, empty until phase.2 | planned |
| `.own` | working-tree deletion — user must decide restore/rewrite | undecided |
| `.roadmap` | working-tree deletion — user must decide restore/rewrite | undecided |

---

## raw#10 caveats (authoritative — see also .roadmap.hexa_os_self_mk2_tuning)

1. hexa-os has **1 .hexa file total** (skeleton). `self mk2 tuning` here is
   convention adoption + scaffolding contract, not refactor. Migration is
   explicitly forbidden.
2. All concrete kernel work blocks on hexa-lang P7-9 fixpoint
   (runtime.c eradication) + 3-layer law enforcement wire-up. phase.2-3
   can lay scaffolding + signatures but cannot compile/run until upstream
   unblocks.
3. Working tree has uncommitted deletes (.own, .roadmap) and mods
   (.gitignore). This session does NOT commit per session policy. User
   decides restore vs rewrite before phase.1 executes.
4. raw 272 audit found `/Users/<name>/` literal at `project.hexa:17`
   (hexa_lang field). Pre-existing debt; additive-only mandate honors
   this by not modifying project.hexa. Tracked in domain `.roadmap` cond.7.
5. The token "mk2" is overloaded: hexa-os "self mk2 tuning" = local
   convention adoption (core+module+README.ai.md). anima/hive "mk2 schema"
   = the JSON-line .roadmap file format used in this domain SSOT. Two
   senses, same token.
6. Lint dependency on `hive/tool/ai_native_module_readme_lint.hexa` is
   cross-repo. hexa-os does not vendor a copy. If hive moves or is
   absent, phase.1 verifier degrades to manual checks.
7. Domain `.roadmap.hexa_os_self_mk2_tuning` is mk2-schema (one JSON object
   per line after header). The deleted (in working tree) free-form
   `.roadmap` was markdown checkpoint-diary style. Coexistence intended:
   `.roadmap` = diary, `.roadmap.<domain>` = structured per-domain SSOT.

---

## Cost + destructive change accounting

- cost_usd: 0 (mac-local plan + handoff + marker only)
- destructive_changes: 0 (additive-only mandate honored — no file
  modified, no file deleted, no git operation invoked)
- wallclock budget: 45 min cap; actual ~25 min (read + draft + write 3 files)

---

## Next-cycle recommendations (priority order)

1. **User decision on .own / .roadmap** (uncommitted deletes — restore vs
   rewrite). Blocks phase.1 entry.
2. **`.raw-ref` first-sync**: pinned-hash currently `TO_BE_FILLED_ON_FIRST_SYNC`.
   Run `hexa tool/raw_sync.hexa check` from hexa-lang to populate.
3. **project.hexa raw 272 cleanup**: replace the absolute
   `/Users/<name>/core/hexa-lang` literal with relative path or env-var
   indirection. Tracked as backlog (additive-only forbids touching this
   land).
4. **hexa-lang P7-9 watch**: when upstream lands runtime.c eradication +
   3-layer law enforcement, phase.2 (first module pair) becomes feasible.
5. **state/proposals/inventory.json append**: this handoff's completion
   entry (currently deferred — additive-only).
