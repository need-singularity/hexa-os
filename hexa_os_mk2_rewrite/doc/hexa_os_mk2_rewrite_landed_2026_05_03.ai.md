---
schema: hexa-os/docs/mk2_rewrite_landed/ai-native/1
last_updated: 2026-05-03
ssot:
  domain_roadmap_kernel:  .roadmap.hexa_os_kernel
  domain_roadmap_boot:    .roadmap.hexa_os_boot
  domain_roadmap_design:  .roadmap.hexa_os_design
  meta_parent:            .roadmap.hexa_os_self_mk2_tuning
  marker:                 state/markers/hexa_os_mk2_rewrite_landed.marker
  probe_preserved:        self/os/_freestanding_probe.hexa
  local_rules:            .own-rules.json
  upstream_lang:          hexa-lang (P7-9 fixpoint blocker)
  sister_baseline:        hive/tool/ai_native_module_readme_lint.hexa
audience: AI
raws_conformant: [9, 10, 270, 271, 272, 273]
roadmap_entry: hexa_os_mk2_rewrite
predecessor: hexa_os_self_mk2_tuning (2026-05-02)
---

# hexa-os mk2-rewrite — landing handoff (3-domain spawn)

Audience: AI agent reading this cold. Friendly preset = analogy + ASCII map +
additive**; the deleted `.own` and `.roadmap` (working tree) are NOT restored
per user directive (rewrite, not restore).

---

## TL;DR (60-second briefing)

- **What.** Three new mk2-schema domain SSOT files spawned from the
  predecessor `.roadmap.hexa_os_self_mk2_tuning` (2026-05-02 land):
  `.roadmap.hexa_os_kernel` (HOS L1 5-rule scaffold), `.roadmap.hexa_os_boot`
  (first raw 270 module pair candidate), `.roadmap.hexa_os_design`
  (organize-only metadata layer for 5 design docs). Plan-only at this land
  for kernel + boot (compute-bound on hexa-lang P7-9 fixpoint upstream);
  fully-met for design (organize-only).
- **Why.** User directive: mk2-rewrite path chosen over mk1-restore for the
  deleted `.own` and `.roadmap` working-tree files. mk2 spawns
  per-domain `.roadmap.<domain>` SSOTs (sibling pattern) instead of
  restoring monolithic mk1. Design doc analysis maps cleanly to 3 domains
  (kernel + boot + design) per HEXA_SERVE_V01.md 6-phase + ROADMAP.md
  3-stage decomposition.
- **Land mode.** Additive only (raw 273). Zero pre-existing files modified.
  `self/os/_freestanding_probe.hexa` byte-identical preserved
  (sha256 `94060f9b...` unchanged from Apr 19 baseline). Pre-existing raw
  272 violation at `project.hexa:17` flagged but NOT touched (additive
  mandate honors backlog as backlog).
- **Cost.** $0 (mac-local plan + 4 files written: 3 roadmaps + this
  handoff + 1 marker; no GPU, no LLM).
- **Selftest.** All 3 domain roadmaps parse as JSONL (one JSON object per
  line after header comment). All declared `status:met` conditions
  re-verified by their own verifier commands at land time (PASS).

---

## Architecture map (analogy + ASCII)

The mk2-rewrite mirrors a **construction site site-plan splitting**: the
predecessor land posted the umbrella permit (self_mk2_tuning); this land
splits the lot into 3 zoned sub-permits (kernel + boot + design), each with
its own contractor (verifier) and inspection schedule (cond.* status). No
ground broken — all 3 sub-permits are paperwork, ready for ground-break
when upstream materials (hexa-lang P7-9) arrive.

```
hexa-os/
  .raw-ref                            (canonical hexa-lang .raw mirror pin — UNCHANGED)
  .own-rules.json                     (L1 5-rule local rules: HOS1..HOS5 — UNCHANGED)
  project.hexa                        (root marker — UNCHANGED, raw 272 debt flagged)
  .roadmap.hexa_os_self_mk2_tuning    (predecessor 2026-05-02 — UNCHANGED)
  .roadmap.hexa_os_kernel             (NEW 2026-05-03 — HOS L1 5-rule scaffold)
  .roadmap.hexa_os_boot               (NEW 2026-05-03 — first raw 270 pair)
  .roadmap.hexa_os_design             (NEW 2026-05-03 — design organize SSOT)
  docs/
    BRAINSTORM.md                     (124-item — UNCHANGED, design.cond.1)
    DEPLOYMENT.md                     (16-provider matrix — UNCHANGED, design.cond.2)
    HEXA_SERVE_V01.md                 (6-phase product spec — UNCHANGED, design.cond.3)
    PERF_P99.md                       (8-cause mechanism — UNCHANGED, design.cond.4)
    hexa_os_self_mk2_tuning_landed_2026_05_02.ai.md  (predecessor — UNCHANGED)
    hexa_os_mk2_rewrite_landed_2026_05_03.ai.md      (NEW — this file)
  state/markers/
    hexa_os_self_mk2_tuning_landed.marker            (predecessor — UNCHANGED)
    hexa_os_mk2_rewrite_landed.marker                (NEW — this land attestation)
  ROADMAP.md                          (3-stage path — UNCHANGED, design.cond.5)
  self/
    os/
      _freestanding_probe.hexa        (UNTOUCHED — additive-only mandate)
    core/                             (PLANNED — kernel+boot phase.1)
    modules/                          (PLANNED — kernel+boot phase.1)
```

The 4-domain mk2 contract:

```
                    ┌──────────────────────────────────────────────────┐
                    │  .roadmap.hexa_os_self_mk2_tuning (predecessor)  │
                    │  meta-parent — umbrella domain                   │
                    └──────────────────┬───────────────────────────────┘
                                       │
              ┌────────────────────────┼────────────────────────────┐
              ▼                        ▼                            ▼
     ┌───────────────────┐    ┌───────────────────┐    ┌───────────────────┐
     │ .roadmap.         │    │ .roadmap.         │    │ .roadmap.         │
     │   hexa_os_kernel  │    │   hexa_os_boot    │    │   hexa_os_design  │
     │                   │    │                   │    │                   │
     │ HOS L1 5-rule     │    │ first raw 270     │    │ design SSOT       │
     │ scaffold          │    │ module pair       │    │ (organize-only)   │
     │ (HOS1..HOS5)      │    │ (boot)            │    │                   │
     │                   │    │                   │    │                   │
     │ 3/7 cond met      │    │ 1/8 cond met      │    │ 8/8 cond met      │
     │ (vacuous)         │    │ (probe preserve)  │    │ (organize-only)   │
     └───────────────────┘    └───────────────────┘    └───────────────────┘
              │                        │                            │
              └────────────────────────┼────────────────────────────┘
                                       │
                              ┌────────────────┐
                              │ cross-link via │
                              │ cross_link tag │
                              └────────────────┘
```

---

## Domain split rationale

| domain | scope | maturity | cond met | upstream blocker |
|--------|-------|----------|----------|------------------|
| `hexa_os_kernel` | HOS L1 5-rule (HOS1..HOS5) compliance scaffold + future law_kernel pair contract | scaffold (cond.2,4,5,6 vacuous met; cond.1,3,7 unmet) | 4/7 | hexa-lang P7-9 + 3-layer law (#38+#39+#29+#4) |
| `hexa_os_boot` | first raw 270 module pair candidate (boot: UEFI/Multiboot2/Firecracker stubs + linker) | plan-only (cond.8 met; 1-7 unmet) | 1/8 | hexa-lang P7-9 + UEFI ABI variant + asm! macro |
| `hexa_os_design` | organize-only SSOT for 5 design docs (BRAINSTORM/DEPLOYMENT/HEXA_SERVE_V01/PERF_P99/ROADMAP) | content-complete | 8/8 | none (organize-only) |

The split honors the design-vs-implementation separation visible in the
repo state: design phase is fully articulated (5 docs, 124-item brainstorm,
3-stage roadmap, 6-phase product spec, 8-cause perf mechanism), while
implementation phase has 1 file (probe skeleton, 31 LOC). Each domain
SSOT tracks the dimension it owns:

- **kernel** = the 5 L1 rules (the "what is allowed" spec)
- **boot** = the first concrete module pair contract (the "what gets built first")
- **design** = the metadata layer over docs (the "what we already know")

---

## raw 270/271/272/273 conformance per file

| raw | requirement | kernel | boot | design |
|-----|-------------|--------|------|--------|
| 270 | core+module split for any new `*/modules/<group>/` dir | tracks via cond.7 (delegates to boot domain) | cond.1 directly enforces | n/a (no modules) |
| 271 | README.ai.md per group (frontmatter + 4 sections) | n/a (no modules yet) | cond.2 enforces (lints with hive sister tool) | n/a (organize-only) |
| 272 | BR-NO-USER-VERBATIM (no `/Users/<name>/`, no @-handles) | PASS (zero violations) | PASS (zero violations) | cond.6 audited PASS (zero violations across all 5 docs + ROADMAP) |
| 273 | additive-only (no destructive migration) | cond.6 byte-identical probe | cond.8 byte-identical probe | cond.7 byte-identical docs/ + ROADMAP.md |

All 4 raws conformant across all 3 new files. The only known repository
debt is the pre-existing `project.hexa:17` literal (`/Users/<user>/core/hexa-lang`),
flagged in predecessor `.roadmap.hexa_os_self_mk2_tuning` cond.7 — this
land does not touch it (additive mandate honors backlog).

---

## File index

| path | purpose | sha256 | new? |
|------|---------|--------|------|
| `.roadmap.hexa_os_kernel` | HOS L1 5-rule scaffold + future law_kernel pair contract | `eba2a03e9263...` | NEW |
| `.roadmap.hexa_os_boot` | first raw 270 module pair (boot: UEFI/Multiboot2/Firecracker) | `20e2b1800086...` | NEW |
| `.roadmap.hexa_os_design` | organize-only SSOT for 5 design docs | `e6507cd66af8...` | NEW |
| `docs/hexa_os_mk2_rewrite_landed_2026_05_03.ai.md` | this handoff | self-referential | NEW |
| `state/markers/hexa_os_mk2_rewrite_landed.marker` | completion attestation (anima-sister schema) | self-referential | NEW |
| `.roadmap.hexa_os_self_mk2_tuning` | predecessor meta-parent | `f691c6f5a693...` | UNCHANGED |
| `self/os/_freestanding_probe.hexa` | pre-existing probe skeleton | `94060f9b8d22...` | preserved |
| `.own` | working-tree deletion — NOT restored (mk2-rewrite path chosen) | n/a | undecided |
| `.roadmap` | working-tree deletion — NOT restored (mk2-rewrite path chosen) | n/a | undecided |

---


1. **Plan-only at land.** Kernel + boot domains are scaffolding contracts
   only. No `self/core/` or `self/modules/` directories created yet. No
   boot stubs authored. Phase.1 of each domain is the next concrete step
   but requires user go-ahead per session policy (additive land for plan,
   not for files).
2. **Upstream-blocked.** All concrete kernel + boot work blocks on
   hexa-lang P7-9 fixpoint (runtime.c eradication, @nostd codegen, libc-less
   ELF emission) plus 3-layer law enforcement wire-up (#38+#39+#29+#4)
   plus UEFI ABI variant + asm! macro support. None of these have ETAs
   tracked in this land.
3. **rewrite, not restore.** User directive: deleted `.own` and `.roadmap`
   (working tree) are NOT restored. mk2-rewrite path spawns per-domain
   SSOT files instead. The deleted files remain as working-tree deletions
   (uncommitted) until user decides next action.
4. **raw 272 pre-existing debt unchanged.** `project.hexa:17` literal
   (`/Users/<user>/core/hexa-lang`) is flagged in predecessor roadmap
   cond.7 but additive-only mandate forbids touching it. Tracked, not
   fixed.
5. **Domain count is 3 not 4.** No `.roadmap.hexa_os_serving` spawned
   (deferred to future land per `.roadmap.hexa_os_design` design.blk.3 +
   phase.3). HEXA_SERVE_V01 phases 3-5 (Inference + Serving + Bench) need
   the future serving domain.
6. **Cross-repo lint dependency.** `hive/tool/ai_native_module_readme_lint.hexa`
   is referenced by `boot.cond.2` verifier. hexa-os does not vendor a copy.
   If hive moves or is absent, lint cannot run; verifier degrades to manual
   README inspection.
7. **Token "mk2" is overloaded** (carried over from predecessor caveat 5).
   "hexa-os mk2-rewrite" here = adopt mk2-shaped per-domain `.roadmap.<domain>`
   format AND spawn 3 sibling roadmaps. anima/hive "mk2 schema" is the
   JSON-line file format used. Two senses share the token; both apply
   simultaneously here.

---

## Cost + destructive change accounting

- cost_usd: 0 (mac-local plan + handoff + marker only; no GPU, no LLM, no pod)
- destructive_changes: 0 (additive-only mandate honored — no file modified,
  no file deleted, no git operation invoked)
- files_added: 5 (3 roadmaps + 1 handoff + 1 marker)
- files_modified: 0
- files_deleted: 0
- byte-identical preservations verified: 6 (probe + 4 design docs + ROADMAP.md +
  predecessor roadmap + predecessor handoff + predecessor marker — git diff
  --quiet PASS for all)
- wallclock budget: 60 min cap; actual ~30 min (read 7 + draft 3 roadmaps +
  validate JSONL + verify met conditions + write handoff + write marker)

---

## Next-cycle recommendations (priority order)

1. **User decision on .own / .roadmap** (uncommitted deletes). mk2-rewrite
   path chosen → no restore. But the working-tree deletions still need a
   commit-or-discard decision. Recommend: commit deletions (since mk2-rewrite
   path is now established) in a separate user-driven commit.
2. **Phase.1 of `.roadmap.hexa_os_design`** is already met at this land
   (organize-only). Phase.2 (`docs/BRAINSTORM_TRIAGE.md` + `docs/DEPLOYMENT_PROVISION_NOTES.md`)
   can land additively without upstream blockers.
3. **Phase.1 of `.roadmap.hexa_os_kernel`** authoring `tool/hos_lint.hexa`
   skeleton is feasible without upstream (selftest mode only — fires when
   kernel code exists).
4. **Phase.1 of `.roadmap.hexa_os_boot`** scaffold (mkdir + READMEs +
   uefi_stub.hexa fn signatures) is feasible without upstream — only
   compile/run blocks.
5. **`.raw-ref` first-sync** (carried over from predecessor next-step):
   pinned-hash currently `TO_BE_FILLED_ON_FIRST_SYNC`.
6. **`project.hexa` raw 272 cleanup** (carried over): replace absolute
   `/Users/<user>/core/hexa-lang` literal with relative path or env-var
   indirection. Tracked as backlog (additive-only forbids touching this
   land).
7. **hexa-lang P7-9 watch** (carried over): unblocks kernel + boot phase.2
   actual compile attempts.
8. **Future `.roadmap.hexa_os_serving` spawn** when boot phase.2 completes
   (per `.roadmap.hexa_os_design` design.blk.3 resolution path).
