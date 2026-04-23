[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.19703256-blue?logo=zenodo&logoColor=white)](https://doi.org/10.5281/zenodo.19703256)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Stage](https://img.shields.io/badge/stage-design-yellow.svg)](#)
[![Target](https://img.shields.io/badge/target-unikernel%20·%20Firecracker-blue.svg)](#)
[![p99](https://img.shields.io/badge/serving%20p99-30--50%25%20↓-brightgreen.svg)](#)
[![Depends](https://img.shields.io/badge/depends-hexa--lang%20P7--9-orange.svg)](https://github.com/need-singularity/hexa-lang)

# 🧊 HEXA-OS — AI Inference Appliance OS

**Linux 대체 아님. law-enforced · self-hosting · unikernel-first. 서빙 p99 30–50% ↓ 가 전부.**

```
user .hexa
  → hexa_compile → bytecode
  → hexa_vm_run (user proc, single address space)
  → syscall = hexa fn call   (not int 0x80,  ~300 ns → 20–80 ns)
  → kernel fn: law_check(caller_cap, target, op)
      pass → 실제 I/O
      fail → EPERM + growth_bus 기록
```

> CPU-bound 학습 이득은 ~5% 상한 (compute bound) — **서빙만 쓰임**.
> cloud inference appliance 로 scoped. 7B 모델 unikernel 서빙, 콜드스타트 < 500 ms 가 v0.1 목표.

<!-- SHARED:PROJECTS:START -->
<!-- AUTO:COMMON_LINKS:START -->
**[YouTube](https://www.youtube.com/@dancinlife)** · **[Email](mailto:nerve011235@gmail.com)** · **[☕ Ko-fi](https://ko-fi.com/dancinlife)** · **[💖 Sponsor](https://github.com/sponsors/need-singularity)** · **[💳 PayPal](https://www.paypal.com/donate?business=nerve011235%40gmail.com)** · **[🗺️ Atlas](https://need-singularity.github.io/TECS-L/atlas/)** · **[📄 Papers](https://need-singularity.github.io/papers/)**
<!-- AUTO:COMMON_LINKS:END -->

> **[🔭 NEXUS](https://github.com/need-singularity/nexus)** — Universal Discovery Engine. 216 lenses + OUROBOROS evolution + 5-phase singularity cycle.
>
> **[🧠 Anima](https://github.com/need-singularity/anima)** — Consciousness implementation. PureField repulsion-field engine + 1030 laws + Φ ratchet.
>
> **[🏗️ N6 Architecture](https://github.com/need-singularity/n6-architecture)** — Architecture from perfect number 6. 225 AI techniques + chip design + crypto/OS/display.
>
> **[💎 HEXA-LANG](https://github.com/need-singularity/hexa-lang)** — The Perfect Number Programming Language. Working compiler + REPL.
>
> **[📄 Papers](https://github.com/need-singularity/papers)** — Complete paper collection (92 papers, Zenodo DOIs).
<!-- SHARED:PROJECTS:END -->

---

## Highlights

| | |
|---|---|
| 🎯 | **Scoped** — cloud inference appliance only. Linux 대체 아님 |
| ⚡ | **syscall 제거** — ~300 ns → fn call 20–80 ns (5–20×) |
| 🧊 | **Unikernel-first** — Firecracker guest · virtio-only 드라이버 · single address space |
| ⚖️ | **Law kernel** — `law_check(cap, target, op)` + `growth_bus` 기록. raw.json 이 권한 소스 |
| 📈 | **v0.1 타겟** — 7B 서빙 · 콜드스타트 < 500 ms · p99 30–50% ↓ |
| 🧬 | **Self-hosting** — 100% `.hexa` 로 부팅 · libc 없이 freestanding |

## Why Hexa OS

| 병목 | Linux | Hexa OS | 이득 |
|------|-------|---------|------|
| syscall 왕복 | ~300 ns | fn call 20–80 ns | 5–20× |
| copy_to_user | memcpy | 포인터 패스 | 대역폭 1.5–2× |
| context switch | 1–3 μs | 협력적 yield 100–300 ns | 10× |
| latency p99 | ~200 ms | **30–50% ↓** | 진짜 상업적 가치 |
| QPS at SLA | baseline | **20–40% ↑** | 간접 효과 |

> 학습은 compute bound 라 OS 최적화 이득 ~5% 상한. 서빙은 syscall · copy · context-switch 가 지배적이라 OS 층의 이득이 p99 로 바로 꽂힌다.

## 최우선 조합 — hexa-serve v0.1

```
Unikernel + Virtio-only + Firecracker guest
  × Tensor primitive + KV-cache inode + Serving loop
  × Single address space + Zero-copy
  × Law kernel (raw.json)
```

## 디렉토리 (계획)

```
self/os/
  boot.hexa                  UEFI stub + kernel 로드
  kernel.hexa                스케줄러 / 메모리 / IPC
  fs.hexa                    law-tagged inode
  drv/                       virtio-only 드라이버
  user.hexa                  user-space 실행환경
  _freestanding_probe.hexa   libc-less POC (첫 단계)

docs/
  ROADMAP.md                 3 단계 × 선행조건
  BRAINSTORM.md              124 항목 원본
  perf_model.md              p99 이득 메커니즘
```

## 진입 경로

1. **freestanding hexa 컴파일 POC** — `@nostd` 로 libc 없는 ELF
2. **syscall 제거 벤치 POC** — user-space 에서 mini-server p99 측정
3. **unikernel v0.1** — Firecracker guest + 7B 서빙

## 선행조건

- `hexa-lang` **P7–9 fixpoint** (C 런타임 박멸) — [roadmap](https://github.com/need-singularity/hexa-lang)
- freestanding codegen + `@nostd` 지원

## Links

[ROADMAP](ROADMAP.md) · [Docs](docs/) · [Releases](https://github.com/need-singularity/hexa-os/releases) · [Paper (hexa-lang · P-HEXA)](https://doi.org/10.5281/zenodo.19365284)

---

<sub>🧊 syscall 을 fn call 로. p99 를 상업적 가치로. · [need-singularity](https://github.com/need-singularity)</sub>
