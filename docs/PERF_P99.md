# p99 이득 메커니즘 — 왜 30% 감소가 가능한가

## p99 정의

100명이 요청하면 응답시간 100개. 빠른 순 정렬:
- **p50** = 50번째 (중앙값, 보통 경험)
- **p95** = 95번째
- **p99** = 99번째 (100명 중 1명이 겪는 최악)
- **p99.9** = 1000명 중 1명

평균은 거짓말한다. SLA 는 p99 로 계약.

## 예시 숫자

```
1000 요청의 응답시간:
  p50   =  48 ms   ← 절반은 이보다 빠름
  p90   =  90 ms
  p95   = 120 ms
  p99   = 200 ms   ← 10명이 200ms 이상 대기
  p99.9 = 850 ms   ← 1명이 850ms 고생
```

모바일 / 대화 AI 는 p99 400ms 넘으면 유저 이탈.

## Linux p99 튀는 원인

1. **sched_tick 컨텍스트 스위치** — 1-3ms jitter, 주기적
2. **kv-cache page fault** — lazy alloc, 첫 접근 때 튐
3. **I/O wait on token streaming** — syscall 왕복 + copy_to_user
4. **GC / background daemon 간섭** — systemd, cron, kthread
5. **TLB shootdown** — multi-core 에서 page table 동기화
6. **interrupt coalescing** — NIC IRQ 병합 지연
7. **CPU frequency scaling** — idle → turbo 램프업 100μs
8. **NUMA migration** — 스케줄러가 노드 옮기며 캐시 miss

## Hexa OS 각 원인 제거

| 원인 | 메커니즘 | Hexa OS 해결 |
|------|---------|-------------|
| sched_tick jitter | 주기적 preempt | **cooperative-only** → 1ms 틱 제거 |
| kv-cache page fault | lazy mmap | **arena per-request** → 사전 commit |
| I/O wait | syscall 왕복 | **single address space** → fn call |
| daemon 간섭 | 다른 프로세스 | **unikernel** → 단일 프로세스 |
| TLB shootdown | shared MMU | **per-core arena** → IPI 불필요 |
| IRQ 지연 | coalescing | **poll mode I/O** → IRQ off |
| freq scaling | idle ramp | **pinned max freq** |
| NUMA migration | 스케줄러 | **pinned CPU** (cooperative) |

## 예측 숫자

| 메트릭 | Linux + vLLM | Hexa OS | 변화 |
|--------|-------------|---------|------|
| prefill tok/s | HBM bound | 동일 | 0 |
| decode tok/s | ~30 | ~33 | +5-10% |
| latency p50 | 50ms | 48ms | -4% |
| **latency p99** | **200ms** | **130ms** | **-35%** |
| QPS at SLA | baseline | +20-40% | 간접 |
| 동시 세션 | 100-500 | 2-5x | 큰 이득 |

## p50 은 왜 거의 안 변하는가

p50 = 정상 경로. 모든 분기가 평소대로 돌아가면 CPU/메모리 대역폭 bound.
Linux 든 Hexa OS 든 같은 HW 에서 같은 matmul 실행.
p50 이득 3-5% 는 syscall 제거 한 번의 차이.

p99 = 이상 경로. tail 은 "뭔가 꼬인 케이스" 의 합.
각 원인별 몇 ms 씩 절약 → 합쳐서 큰 폭.

**핵심**: p99 는 평균의 5-10배. 절약 절대값도 5-10배.
Linux p50 50ms × 5 % = 2.5ms 절약
Linux p99 200ms × 35% = 70ms 절약

## SLA 경제학

SaaS 계약 :
> "p99 < 200ms 보장, 위반 시 월정액 5% 환불"

Linux 에서 p99 = 195ms 라면:
- 여유 5ms
- 트래픽 10% 증가 시 p99 240ms → SLA 위반
- 즉 트래픽 성장 = 하드웨어 증설 강제

Hexa OS 에서 p99 = 130ms 라면:
- 여유 70ms
- 트래픽 50% 증가 수용
- **같은 하드웨어로 1.5x 매출**

이것이 p99 30% 감소의 진짜 가치. 단순 "빠름" 이 아니라 "유닛 경제학 혁명".

## 벤치 설계 (미래)

### 필수 측정 항목
1. p50 / p90 / p95 / p99 / p99.9 / p99.99
2. 콜드스타트 (첫 요청 latency)
3. 동시 세션 (QPS at fixed p99)
4. 튀는 구간 원인 분석 (어느 syscall 에서)

### 비교 기준
- vLLM (Linux) on 동일 HW
- TGI (HuggingFace) on 동일 HW
- TensorRT-LLM on 동일 HW
- Hexa OS + hexa-serve on 동일 HW

### 측정 워크로드
- **Synthetic**: 고정 input 길이, 고정 output 길이
- **Realistic**: Azure ChatGPT trace 재생
- **Adversarial**: 매우 긴 context + 짧은 output (prefill-heavy)

## 한 줄

> **"p50 은 보통, p99 는 진실, p99.9 는 재난. Hexa OS 는 진실과 재난을 동시에 압축."**
