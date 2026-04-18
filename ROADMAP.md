# hexa-os Roadmap

## 3 단계 실현 경로

### 단계 1 — Unikernel (3-6 개월)

**목표**: Firecracker guest 에서 단일 hexa 앱 + 최소 kernel 부팅.

- [ ] P7-9 fixpoint 대기 (hexa-lang runtime.c 박멸)
- [ ] `@nostd` attr — libc 의존 제거, linker flag `-nostdlib`
- [ ] `@irq` attr + 컨텍스트 스위치 intrinsic
- [ ] inline asm: `asm!("mrs x0, ..")` ARM64 레지스터
- [ ] UEFI stub / Multiboot2 로더
- [ ] virtio-blk / virtio-net 드라이버
- [ ] single address space 메모리 모델
- [ ] cooperative scheduler
- [ ] 법 kernel — raw.json 을 kernel space 에 로드 + syscall hook

**증명 포인트**: 콜드스타트 < 500ms, 메모리 footprint < 10MB.

### 단계 2 — Microkernel (1-2 년)

**목표**: kernel = scheduler + MMU + IPC 만. fs/net/drv 는 user-space hexa daemon.

- [ ] IPC primitive (msg passing)
- [ ] user-space driver framework (`@driver` attr)
- [ ] law capability 전달 (distributed cap)
- [ ] content-addressable FS
- [ ] KV-cache inode
- [ ] tensor first-class syscall
- [ ] batch-aware scheduler
- [ ] SPDK-style NVMe (poll mode)

**증명 포인트**: Redox 대비 AI workload 에서 p99 20%+ 우세.

### 단계 3 — 일반 서빙 OS (2-3 년)

**목표**: Kubernetes node OS 대체 (Talos/flatcar). NVIDIA GPU passthrough.

- [ ] OCI runtime 호환
- [ ] Linux ABI subset (Wine 스타일)
- [ ] Metal/Vulkan passthrough
- [ ] confidential compute (SEV/TDX)
- [ ] HBM as heap (CXL 대비)
- [ ] law live-update (hot reload raw.json)
- [ ] self-healing kernel
- [ ] incident auto-bisect

## Top 5 우선순위

| # | 항목 | 기간 | 가치 | 리스크 |
|---|------|------|------|--------|
| 1 | Unikernel + Virtio + Firecracker | 3-6 개월 | ⭐⭐⭐⭐⭐ | 낮음 |
| 2 | AI primitive + law kernel | 6-12 개월 | ⭐⭐⭐⭐⭐ | 중 |
| 3 | Single addr space + zero-copy | 3-6 개월 | ⭐⭐⭐⭐ | 중 |
| 4 | Hetzner OEM + edge appliance | 12-18 개월 | ⭐⭐⭐⭐ | 높음 |
| 5 | Versioned FS + law live-update | 6-9 개월 | ⭐⭐⭐ | 낮음 |

## 포기 항목

- 일반 desktop OS — SerenityOS 수준 10+ 년
- NVIDIA closed 드라이버 자체 작성 — 영원히 불가
- USB / HID / audio — 서버 전용
- RISC-V / TPU / Cerebras — 조기투자
- Windows ABI — scope 밖

## 선행 의존

- **hexa-lang P7-9 fixpoint** — runtime.c 박멸. 이게 닫혀야 출발선.
- **hexa-lang 3층 law enforcement** — #38+39+29+4 (stdlib/runtime/parser/hook). 현재 설계 완료, wire-up 대기.
- **ARM64/x86_64 codegen** — P7-5 완료. ELF/Mach-O 완료.

## 성능 예측 (근거)

### AI 학습
- GPU compute: 85-95% → Hexa OS 이득 **0**
- all-reduce: NCCL 이 kernel bypass → **0**
- dataloader: **3-5%**
- 체크포인트: 드문 이벤트 → 측정 불가
- **총: ~5% 상한** → 투자 가치 없음

### AI 서빙
- prefill: HBM bound → **0**
- decode: syscall + scheduler → **5-10%**
- latency p50: **5-10%**
- latency **p99**: **30-50% ↓** ← 진짜 가치
- QPS at SLA: **20-40% ↑**
- 동시 세션: **2-5x**

## 실험 우선순위

1. **freestanding hexa 컴파일 POC** (1 week) — libc-less ELF
2. **syscall 제거 벤치 POC** (1 week) — user-space p99 측정
3. 위 숫자 기반 unikernel 진입 결정 (go/no-go)

## 관련 프로젝트 비교

| 프로젝트 | 유사성 | Hexa OS 차별화 |
|---------|--------|----------------|
| Redox (Rust) | microkernel, memsafe | AI-native + law enforcement |
| MirageOS (OCaml) | unikernel | AI workload 특화 |
| IncludeOS | 단일 앱 unikernel | 컴파일러+OS 동일 언어 self-host |
| seL4 | 증명 microkernel | raw.json 이 증명 대체 |
| Talos Linux | K8s node OS | 언어 자체가 OS |
| Firecracker | microVM | guest OS 레이어 |
| gVisor | user-space kernel | language-level kernel |
