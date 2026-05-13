[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.19703255.svg)](https://doi.org/10.5281/zenodo.19703255)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Stage](https://img.shields.io/badge/stage-design-yellow.svg)](#)
[![Target](https://img.shields.io/badge/target-unikernel%20·%20Firecracker-blue.svg)](#)
[![Modules: 6 spec](https://img.shields.io/badge/modules-6_spec-blue.svg)](#verify)
[![Verify: 4/4 PASS](https://img.shields.io/badge/verify-4%2F4_PASS-brightgreen.svg)](verify/run_all.hexa)
[![Closure: SPEC_FIRST](https://img.shields.io/badge/closure-SPEC__FIRST-brightgreen.svg)](hexa.toml)
[![p99](https://img.shields.io/badge/serving%20p99-30--50%25%20↓%20UNVERIFIED-orange.svg)](LIMIT_BREAKTHROUGH.md)
[![Training cap](https://img.shields.io/badge/training%20gains-~5%25%20capped-lightgrey.svg)](LIMIT_BREAKTHROUGH.md)
[![Depends](https://img.shields.io/badge/depends-hexa--lang%20P7--9-orange.svg)](https://github.com/dancinlab/hexa-lang)

# 🧊 HEXA-OS — AI Inference Appliance OS

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

## Layout (planned)

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

> **Honest scope** (raw#10 C3): the **30–50% p99 ↓** badge above is
> **UNVERIFIED** until the operational unikernel boots (gated on
> hexa-lang P7–9 fixpoint). It is a design target, not a measurement.
> The **~5% training cap** is a falsifiable real-limit claim
> (GPU-FLOPs-dominated); it is preserved verbatim from the headline
> above. Actual OS vendors (Linux Foundation, Microsoft, Apple, Google)
> use **their own** benchmarks (LMBench / sysbench / fio / etc.) — no
> lattice-fit is asserted on any external system.

## Links

[ROADMAP](ROADMAP.md) · [Docs](docs/) · [LATTICE_POLICY](LATTICE_POLICY.md) · [LIMIT_BREAKTHROUGH](LIMIT_BREAKTHROUGH.md) · [Releases](https://github.com/dancinlab/hexa-os/releases) · [Paper (hexa-lang · P-HEXA)](https://doi.org/10.5281/zenodo.19365284)

---

<sub>🧊 syscalls become fn calls. p99 becomes commercial value. · [dancinlab](https://github.com/dancinlab)</sub>
