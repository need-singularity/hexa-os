# hexa-os

> AI 추론 어플라이언스 OS. law-enforced, self-hosting, unikernel-first.

Linux 대체 목표 아님. **cloud inference appliance** 로 scoped.
CPU-bound 학습 이득 0. 서빙 p99 30-50% ↓ 가 핵심 가치.

## 현재 상태

- 설계 단계 — 브레인스토밍 124 항목 → Top 5 수렴 완료 (see `ROADMAP.md`)
- 선행조건: `hexa-lang` P7-9 fixpoint (C 런타임 박멸)
- 타겟 v0.1: hexa-serve unikernel (Firecracker guest, 7B 서빙, 콜드스타트 < 500ms)

## 왜 Hexa OS

| 병목 | Linux | Hexa OS | 이득 |
|------|-------|---------|------|
| syscall 왕복 | ~300 ns | fn call 20-80 ns | 5-20x |
| copy_to_user | memcpy | 포인터 패스 | 대역폭 1.5-2x |
| context switch | 1-3 μs | 협력적 yield 100-300 ns | 10x |
| latency p99 | ~200ms | **30-50% ↓** | 진짜 상업적 가치 |
| QPS at SLA | baseline | **20-40% ↑** | 간접 효과 |

학습 이득 ~5% 상한 (compute bound). 서빙만 쓰임.

## 최우선 조합: hexa-serve v0.1

```
Unikernel + Virtio-only + Firecracker guest
  × Tensor primitive + KV-cache inode + Serving loop
  × Single address space + Zero-copy
  × Law kernel (raw.json)
```

## 아키텍처

```
user .hexa
  → hexa_compile → bytecode
  → hexa_vm_run (user proc, single address space)
  → syscall = hexa fn call  (not int 0x80)
  → kernel fn: law_check(caller_cap, target, op)
  → pass → 실제 I/O
  → fail → EPERM + growth_bus 기록
```

## 디렉토리 (계획)

```
self/os/
  boot.hexa          UEFI stub + kernel 로드
  kernel.hexa        스케줄러 / 메모리 / IPC
  fs.hexa            law-tagged inode
  drv/               virtio-only 드라이버
  user.hexa          user-space 실행환경
  _freestanding_probe.hexa   libc-less POC (첫 단계)

docs/
  ROADMAP.md         3 단계 × 선행조건
  BRAINSTORM.md      124 항목 원본
  perf_model.md      p99 이득 메커니즘
```

## 진입 경로

1. **freestanding hexa 컴파일 POC** — `@nostd` 로 libc 없는 ELF
2. **syscall 제거 벤치 POC** — user-space 에서 mini-server p99 측정
3. **unikernel v0.1** — Firecracker guest + 7B 서빙

## 관련

- [hexa-lang](https://github.com/need-singularity/hexa-lang) — 컴파일러 + 언어. 선행.
- [anima](https://github.com/need-singularity/anima) — AGI substrate. 최종 사용처.
- [nexus-6](https://github.com/need-singularity/nexus-6) — 공진화 렌즈.

## License

TBD.
