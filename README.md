<p align="center">
  <img src="docs/logo.svg" width="140" alt="hexa-os">
</p>

<h1 align="center">🖥️ hexa-os</h1>

<p align="center"><strong>HEXA-OS Family</strong> — AI inference appliance OS · law-enforced · self-hosting · unikernel-first</p>

<p align="center">
  <a href="LICENSE"><img alt="License" src="https://img.shields.io/badge/license-MIT-blue"></a>
  <a href=".github/workflows/lint.yml"><img alt="CI" src="https://github.com/dancinlab/hexa-os/actions/workflows/lint.yml/badge.svg"></a>
  <img alt="Spec" src="https://img.shields.io/badge/spec-v0.1-success">
  <img alt="Modules" src="https://img.shields.io/badge/modules-6-informational">
  <img alt="Verify" src="https://img.shields.io/badge/verify-4%2F4_PASS-informational">
  <img alt="Closure" src="https://img.shields.io/badge/closure-SPEC__FIRST-informational">
  <a href="https://doi.org/10.5281/zenodo.19703255"><img alt="DOI" src="https://zenodo.org/badge/DOI/10.5281/zenodo.19703255.svg"></a>
  <img alt="Family" src="https://img.shields.io/badge/family-hexa--os%20·%20hexa--ios%20·%20hexa--macos-blueviolet">
</p>

<p align="center">Operating systems · unikernel · Firecracker · law kernel · syscall-free · p99-first · self-hosting · serving-only</p>

---

**Not a Linux replacement. law-enforced · self-hosting · unikernel-first. Serving p99 30–50% ↓ is the whole point.**

```
user .hexa
  → hexa_compile → bytecode
  → hexa_vm_run (user proc, single address space)
  → syscall = hexa fn call   (not int 0x80,  ~300 ns → 20–80 ns)
  → kernel fn: law_check(caller_cap, target, op)
      pass → real I/O
      fail → EPERM + growth_bus record
```

> Training gains are capped at ~5% (compute-bound) — **serving only**.
> Scoped as a cloud inference appliance. v0.1 target: 7B-model unikernel serving, cold-start < 500 ms.

<!-- SHARED:PROJECTS:START -->
<!-- AUTO:COMMON_LINKS:START -->
**[YouTube](https://www.youtube.com/@dancinlife)** · **[Email](mailto:nerve011235@gmail.com)** · **[💖 Sponsor](https://github.com/sponsors/dancinlab)** · **[💳 PayPal](https://www.paypal.com/donate?business=nerve011235%40gmail.com)** · **[🗺️ Atlas](https://dancinlab.github.io/TECS-L/atlas/)** · **[📄 Papers](https://dancinlab.github.io/papers/)**
<!-- AUTO:COMMON_LINKS:END -->

> **[🔭 NEXUS](https://github.com/dancinlab/nexus)** — Universal Discovery Engine. 216 lenses + OUROBOROS evolution + 5-phase singularity cycle.
>
> **[🧠 Anima](https://github.com/dancinlab/anima)** — Consciousness implementation. PureField repulsion-field engine + 1030 laws + Φ ratchet.
>
> **[🏗️ CANON](https://github.com/dancinlab/canon)** — Architecture from perfect number 6. 225 AI techniques + chip design + crypto/OS/display.
>
> **[💎 HEXA-LANG](https://github.com/dancinlab/hexa-lang)** — The Perfect Number Programming Language. Working compiler + REPL.
<!-- SHARED:PROJECTS:END -->

---

## Status

- v0.1 spec live (design stage) — 6 modules, SPEC_FIRST closure, 4/4 verify scripts PASS
- 6 modules: `boot` · `kernel` · `serving` · `deployment` · `ios` · `macos`
- Family substrate: this repo + sibling `hexa-ios/` + `hexa-macos/` placeholders
- Depends on `hexa-lang` P7–9 fixpoint (C runtime eliminated, `@nostd` freestanding codegen)
- Operational unikernel UNVERIFIED — design target, not a measurement; **~5% training cap** is the falsifiable real-limit claim
- DOI 10.5281/zenodo.19703255 (concept release)

## Install

```bash
# 1. Install hexa-lang (gives you `hexa` + `hx` package manager)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/dancinlab/hexa-lang/main/install.sh)"

# 2. Install hexa-os
hx install hexa-os
```

## Highlights

| | |
|---|---|
| 🎯 | **Scoped** — cloud inference appliance only. Not a Linux replacement |
| ⚡ | **No syscalls** — ~300 ns → fn call 20–80 ns (5–20×) |
| 🧊 | **Unikernel-first** — Firecracker guest · virtio-only drivers · single address space |
| ⚖️ | **Law kernel** — `law_check(cap, target, op)` + `growth_bus` log. raw.json is the capability source |
| 📈 | **v0.1 target** — 7B serving · cold-start < 500 ms · p99 30–50% ↓ |
| 🧬 | **Self-hosting** — boots 100% in `.hexa` · freestanding, no libc |

## Why Hexa OS

| Bottleneck | Linux | Hexa OS | Gain |
|------------|-------|---------|------|
| syscall round-trip | ~300 ns | fn call 20–80 ns | 5–20× |
| copy_to_user | memcpy | pointer pass | bandwidth 1.5–2× |
| context switch | 1–3 μs | cooperative yield 100–300 ns | 10× |
| latency p99 | ~200 ms | **30–50% ↓** | real commercial value |
| QPS at SLA | baseline | **20–40% ↑** | downstream effect |

> Training is compute-bound, so OS-layer gains cap at ~5%. Serving is dominated by syscall · copy · context-switch, so OS-layer wins land directly on p99.

## Flagship combo — hexa-serve v0.1

```
Unikernel + Virtio-only + Firecracker guest
  × Tensor primitive + KV-cache inode + Serving loop
  × Single address space + Zero-copy
  × Law kernel (raw.json)
```

## Run

```sh
# closure verification (the SPEC_FIRST entry point)
hexa run verify/run_all.hexa            # → 4/4 scripts passed

# individual verify scripts
hexa run verify/spec_presence.hexa       # 6/6 module spec docs at declared paths
hexa run verify/lattice_arithmetic.hexa  # n=6 lattice identities (aux check)
hexa run verify/real_limits_anchor.hexa  # H1/H5/H6/H7/H9/S1 real-limit anchors
hexa run verify/closure_consistency.hexa # scoreboard cross-check

# inspect spec docs
ls docs/                                  # PERF_P99 · HEXA_SERVE_V01 · DEPLOYMENT · BRAINSTORM
cat hexa-ios/hexa-ios.md                  # mobile target spec
cat hexa-macos/hexa-macos.md              # desktop target spec
```

Operational `boot` / `kernel` / `serving` invocations are pre-impl (gated on `hexa-lang` P7–9 fixpoint).

## Repo layout

```
self/os/
  boot.hexa                  UEFI stub + kernel load
  kernel.hexa                scheduler / memory / IPC
  fs.hexa                    law-tagged inode
  drv/                       virtio-only drivers
  user.hexa                  user-space runtime
  _freestanding_probe.hexa   libc-less POC (first step)

docs/
  ROADMAP.md                 3 stages × prerequisites
  BRAINSTORM.md              124 raw items
  perf_model.md              p99 gain mechanism
```

## Entry path

1. **Freestanding hexa compile POC** — `@nostd` ELF, no libc
2. **Syscall-free bench POC** — measure p99 on a user-space mini-server
3. **Unikernel v0.1** — Firecracker guest + 7B serving

## Prerequisites

- `hexa-lang` **P7–9 fixpoint** (C runtime eliminated) — [roadmap](https://github.com/dancinlab/hexa-lang)
- Freestanding codegen + `@nostd` support

## Verify

hexa-os is a **SPEC_FIRST** substrate: 6 design modules, each backed by a
spec doc on disk. Closure is verified by 4 small `.hexa` scripts under
`verify/`:

```bash
# from repo root:
hexa run verify/run_all.hexa
# expected: 4/4 scripts passed
```

| # | script | what it checks |
|---|--------|----------------|
| 1 | `verify/spec_presence.hexa` | 6/6 module spec docs at declared paths (+ 2 crosslink sub-specs) |
| 2 | `verify/lattice_arithmetic.hexa` | n=6 lattice identities (aux per [`LATTICE_POLICY.md`](LATTICE_POLICY.md) §1.3 rule 1 — never sole verification) |
| 3 | `verify/real_limits_anchor.hexa` | [`LIMIT_BREAKTHROUGH.md`](LIMIT_BREAKTHROUGH.md) anchors (Turing H1 · Brewer H6 · Lamport H7 · NVMe H5 · speed of light H9 · Linux syscall S1 baseline) |
| 4 | `verify/closure_consistency.hexa` | scoreboard cross-check (CLI registry · `hexa.toml` · README badge · AGENTS.md policy registration) |

The 6 modules:

| # | module | spec doc |
|---|--------|----------|
| 1 | `boot` | [`ROADMAP.md`](ROADMAP.md) — UEFI / Multiboot2 / Firecracker guest |
| 2 | `kernel` | [`docs/PERF_P99.md`](docs/PERF_P99.md) — scheduler · memory · IPC · `law_check` |
| 3 | `serving` | [`docs/HEXA_SERVE_V01.md`](docs/HEXA_SERVE_V01.md) — hexa-serve v0.1 (7B unikernel) |
| 4 | `deployment` | [`docs/DEPLOYMENT.md`](docs/DEPLOYMENT.md) — operational notes |
| 5 | `ios` | [`hexa-ios/hexa-ios.md`](hexa-ios/hexa-ios.md) — mobile target spec |
| 6 | `macos` | [`hexa-macos/hexa-macos.md`](hexa-macos/hexa-macos.md) — desktop target spec |

> **UNVERIFIED** until the operational unikernel boots (gated on
> hexa-lang P7–9 fixpoint). It is a design target, not a measurement.
> The **~5% training cap** is a falsifiable real-limit claim
> (GPU-FLOPs-dominated); it is preserved verbatim from the headline
> above. Actual OS vendors (Linux Foundation, Microsoft, Apple, Google)
> use **their own** benchmarks (LMBench / sysbench / fio / etc.) — no
> lattice-fit is asserted on any external system.

## Links

[ROADMAP](ROADMAP.md) · [Docs](docs/) · [LATTICE_POLICY](LATTICE_POLICY.md) · [LIMIT_BREAKTHROUGH](LIMIT_BREAKTHROUGH.md) · [Releases](https://github.com/dancinlab/hexa-os/releases) · [Paper (hexa-lang · P-HEXA)](https://doi.org/10.5281/zenodo.19365284)

## License

[MIT](LICENSE) — permissive open source.

---

<sub>🖥️ syscalls become fn calls. p99 becomes commercial value. · [dancinlab](https://github.com/dancinlab)</sub>
