# hexa-serve v0.1 — 첫 제품 스펙

## 한 줄 정의

> **"AWS Lambda 스타일 hexa 7B serving unikernel, 법 enforcement 내장, 콜드스타트 < 500ms, p99 30% 감소"**

## 단어별 풀이

### 1. "AWS Lambda 스타일" = 실행 모델

요청이 올 때만 실행, 끝나면 꺼짐. 평소엔 메모리/CPU 0.

**전통 서빙 (vLLM)**:
```
서버 부팅 → 모델 로드 (30s) → 메모리 상주 (20GB) → 요청 waiting
→ 요청 처리 → 계속 상주
```
비용: 요청 없어도 GPU/메모리 점유.

**Lambda 스타일**:
```
요청 옴 → unikernel 부팅 (<500ms) → 모델 mmap → 응답 → 즉시 shutdown
```
비용: 요청당 ms 단위 과금.

### 2. "hexa 7B serving" = 워크로드 특정

**범용 OS 아님.** 7B LLM 추론 전용 하드코딩.
- fs: weights 파일만 서빙
- network: gRPC / HTTP 한 포트
- scheduler: prefill / decode 2가지 태스크
- 다른 워크로드 (웹서버, DB) 는 못 돌림

이 scope 한정이 속도의 원천. 범용이면 Linux 가 이김. 특화면 hexa-os 가 이김.

### 3. "unikernel" = 아키텍처

```
[Linux]                         [Unikernel]
user app .so/.py                ─┐
  ↓ syscall (ring 3→0)           │
kernel (100MB+, 수천 드라이버) ─┤ 합쳐서 하나의 바이너리 (50MB)
  ↓ driver                       │ 단일 주소공간
hardware                       ─┘
```

- OS + 앱 = **하나의 ELF**
- `hexa-serve-7b` 실행 = OS 부팅 + 서빙 시작
- kernel/user 구분 없음 → syscall 왕복 제거 (300ns → 20ns fn call)
- 드라이버 = virtio (VM 전용). 물리 하드웨어 드라이버 0.

### 4. "법 enforcement 내장" = kernel level raw.json

```
기존 프로세스:
  hexa app → write() syscall → Linux kernel → fs 쓰기 (아무도 안 막음)

hexa-os:
  hexa app → write() = kernel fn call
              → law_check(caller, path, content) ← raw.json 평가
              → 통과만 실제 쓰기
              → 실패 = EPERM + growth_bus 로그
```

"법" = `shared/hexa-lang/raw.json` 6 규칙 + L1 local `.own-rules.json`.

차별화: Redox / Linux 는 DAC / SELinux 정도. 여긴 **프로젝트 고유 법** 을 kernel 이 직접 해석.

### 5. "콜드스타트 < 500ms"

**Firecracker guest (AWS Lambda 실제 엔진) 실측 기준**:

| 단계 | Linux microVM | Unikernel |
|------|--------------|-----------|
| microVM 부팅 | 125-300ms | 20-100ms |
| OS init | 500-2000ms | 0 (없음) |
| 앱 기동 | 100-500ms | 0 (합쳐짐) |
| 모델 로드 | 5-30s (full) | 100-400ms (lazy mmap) |
| **총** | **5-30s** | **120-500ms** |

**10-60x 개선.** serverless LLM 서빙을 처음으로 경제적으로 만드는 지점.

### 6. "p99 30% 감소"

p99 = 100 요청 중 99번째로 느린 것. SLA 계약 숫자.

| 원인 | Linux tail | Hexa OS |
|------|-----------|---------|
| sched_tick jitter | 1-3ms | 제거 |
| kv-cache page fault | 0-20ms | 사전 arena |
| syscall 왕복 | 0.3ms × N | fn call |
| daemon 간섭 | 0-10ms | 단일 proc |

**p50: 50ms → 48ms (4%)**
**p99: 200ms → 130ms (35%)**

같은 하드웨어에서 QPS 20-40% 증가 → **매출 1.5x**.

## 한 줄 요약

> **"최소 부품 · 최대 속도 · 법 강제 — 한 바이너리로 배포되는 7B 서빙 머신"**

Linux 는 everything OS. hexa-serve 는 one-app OS. 공학적으로 다른 생물체.

## 구현 순서

### 사전 조건
- hexa-lang P7-9 fixpoint (runtime.c 박멸)
- 3층 law enforcement 착지 (#38+39+29+4)

### Phase 0 — Probe (1 week)
- `@nostd` attr
- freestanding ELF 생성 가능 여부 검증
- linker script

### Phase 1 — Skeleton (2 weeks)
- UEFI / Multiboot2 stub
- 최소 kernel (printk 만)
- QEMU 부팅 확인

### Phase 2 — Core (1 month)
- virtio-blk / virtio-net
- single address space 메모리
- cooperative scheduler
- 법 kernel (raw.json 로드)

### Phase 3 — Inference (1 month)
- tensor first-class syscall
- weight mmap
- kv-cache arena
- decode loop primitive

### Phase 4 — Serving (2 weeks)
- HTTP/gRPC 서빙 루프
- token streaming
- Firecracker guest 패키징

### Phase 5 — Bench (2 weeks)
- p99 측정 (vs vLLM)
- 콜드스타트 측정
- QPS at SLA 측정

**총: ~4 개월** (선행조건 충족 후).
