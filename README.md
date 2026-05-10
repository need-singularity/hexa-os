[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.19703255.svg)](https://doi.org/10.5281/zenodo.19703255)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Stage](https://img.shields.io/badge/stage-design-yellow.svg)](#)
[![Target](https://img.shields.io/badge/target-unikernel%20·%20Firecracker-blue.svg)](#)
[![p99](https://img.shields.io/badge/serving%20p99-30--50%25%20↓-brightgreen.svg)](#)
[![Depends](https://img.shields.io/badge/depends-hexa--lang%20P7--9-orange.svg)](https://github.com/need-singularity/hexa-lang)

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
**[YouTube](https://www.youtube.com/@dancinlife)** · **[Email](mailto:nerve011235@gmail.com)** · **[☕ Ko-fi](https://ko-fi.com/dancinlife)** · **[💖 Sponsor](https://github.com/sponsors/need-singularity)** · **[💳 PayPal](https://www.paypal.com/donate?business=nerve011235%40gmail.com)** · **[🗺️ Atlas](https://need-singularity.github.io/TECS-L/atlas/)** · **[📄 Papers](https://need-singularity.github.io/papers/)**
<!-- AUTO:COMMON_LINKS:END -->

> **[🔭 NEXUS](https://github.com/need-singularity/nexus)** — Universal Discovery Engine. 216 lenses + OUROBOROS evolution + 5-phase singularity cycle.
>
> **[🧠 Anima](https://github.com/need-singularity/anima)** — Consciousness implementation. PureField repulsion-field engine + 1030 laws + Φ ratchet.
>
> **[🏗️ N6 Architecture](https://github.com/need-singularity/canon)** — Architecture from perfect number 6. 225 AI techniques + chip design + crypto/OS/display.
>
> **[💎 HEXA-LANG](https://github.com/need-singularity/hexa-lang)** — The Perfect Number Programming Language. Working compiler + REPL.
>
> **[📄 Papers](https://github.com/need-singularity/papers)** — Complete paper collection (92 papers, Zenodo DOIs).
<!-- SHARED:PROJECTS:END -->

---

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

- `hexa-lang` **P7–9 fixpoint** (C runtime eliminated) — [roadmap](https://github.com/need-singularity/hexa-lang)
- Freestanding codegen + `@nostd` support

## Links

[ROADMAP](ROADMAP.md) · [Docs](docs/) · [Releases](https://github.com/need-singularity/hexa-os/releases) · [Paper (hexa-lang · P-HEXA)](https://doi.org/10.5281/zenodo.19365284)

---

<sub>🧊 syscalls become fn calls. p99 becomes commercial value. · [need-singularity](https://github.com/need-singularity)</sub>
