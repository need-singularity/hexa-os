# 배포 가능성 — 어느 클라우드에 설치되는가

## 결론 요약

> **"OS 를 바꾸려면 OS 를 줘야 하는 클라우드로 가라. 앱만 주는 클라우드엔 못 들어간다."**

## 제공자별 매트릭스

| 제공자 | 가능? | 조건 / 이유 |
|--------|-------|------------|
| **RunPod** | ❌ | managed Linux 호스트 + Docker 컨테이너만 |
| **Vast.ai** | ❌ | RunPod 유사 |
| **Colab / Kaggle** | ❌ | Jupyter 레이어 고정 |
| **AWS EC2 (일반)** | ❌ | Xen/Nitro Linux 강제 |
| **AWS EC2 .metal** | ✅ | bare metal 인스턴스, 커스텀 AMI |
| **GCP metal** | ✅ | 예약 필요, 비쌈 |
| **Azure BareMetal** | ✅ | SAP/HANA 용 제공 |
| **Hetzner dedicated** | ✅ | IPMI 로 ISO 부팅, 저렴 |
| **Equinix Metal** | ✅ | API 로 커스텀 이미지 |
| **Latitude.sh** | ✅ | Hetzner 유사 |
| **Vultr bare metal** | ✅ | 지원 |
| **OVH dedicated** | ✅ | KVM console |
| **Lambda Labs bare metal** | ✅ | GPU 전용, H100 / A100 |
| **Crusoe** | ✅ | GPU cloud + bare metal |
| **Foundry** | ✅ | GPU bare metal |
| **자체 서버 (colo)** | ✅ | 당연 |

**핵심 기준**: "IPMI / 커스텀 ISO 부팅" 지원 여부. managed container 만 준다 = 불가.

## 왜 RunPod 에 안 들어가는가

```
[RunPod 하드웨어]
  ↓
[그들의 Linux 호스트] ← Hexa OS 가 들어가야 할 자리, 잠김
  ↓
[Docker 컨테이너]   ← 네가 받는 공간
  ↓
[네 앱]
```

호스트 OS 위치는 공급자가 장악. Hexa OS 는 그 위치에 들어가야 의미 있음.

## 우회로 평가

### #1 Firecracker guest on RunPod
```
[RunPod Linux] → Docker (--privileged) → Firecracker microVM → hexa-os
```
문제:
- KVM 모듈 접근 필요 (`--privileged` — 대부분 거부)
- GPU passthrough 2 단계 (컨테이너→VM) — NVIDIA 드라이버가 한 곳만 바인딩
- 성능 손해, 복잡도 증가. **실익 없음.**

### #2 QEMU CPU-only on RunPod
- ✅ 부팅 / syscall / 법 enforcement 검증만
- ❌ 성능 수치 참값 아님 (에뮬레이션)
- 용도: "돌긴 돈다" 증명. 벤치 X.

## 추천 Phase 경로

### Phase 1 — 로컬 M4 (이번 주~한달)
- QEMU / UTM 부팅 테스트
- Firecracker CPU-only arm64
- 콜드스타트 측정

### Phase 2 — Hetzner dedicated ($50-200/월, 1-2개월)
- IPMI 로 커스텀 ISO 부팅
- CPU-only 7B 서빙 벤치
- p99 실측

### Phase 3 — GPU bare metal (시간당, 2-3개월)
- Lambda Labs / Crusoe / AWS .metal
- A100 / H100 passthrough
- vs vLLM on Linux 직접 비교

### Phase 4 — 제품 (6-12개월)
- Lambda / Crusoe / Foundry 번들
- 또는 자체 colo (Equinix rack)
- OEM 파트너십

## 목표 하드웨어 매트릭스

| 하드웨어 | 용도 | 우선순위 |
|---------|------|---------|
| Apple M-series | 로컬 개발 | ⭐⭐⭐⭐⭐ |
| Hetzner AX series (AMD) | CPU 서빙 벤치 | ⭐⭐⭐⭐ |
| AWS c7g.metal (Graviton) | ARM 서버 검증 | ⭐⭐⭐ |
| Lambda Labs H100 | GPU 서빙 실측 | ⭐⭐⭐⭐⭐ |
| Crusoe A100 | 비용 효율 서빙 | ⭐⭐⭐⭐ |
| Equinix c3.medium.x86 | OEM 검토 | ⭐⭐⭐ |

## 제외

- RunPod, Vast.ai, Colab, Jupyter 호스팅 — abstraction 층 깸
- Heroku 류 PaaS — 논외
- Vercel Edge / Cloudflare Workers — 다른 생물체
