# hexa-os Brainstorm (free → smash, 124 항목)

2026-04-19 hexa-lang 세션에서 고갈 선언까지 도출.

## A. Kernel 아키텍처 (9)
1. Monolithic hexa — 비추
2. Microkernel — seL4/Redox. POC 무난
3. **Unikernel** — cloud 한정, 실현성 최고 ⭐
4. Exokernel — 성능 최고, 복잡
5. No-kernel — 단일 주소공간
6. Hybrid AI-kernel — GPU 직접 kernel 관리
7. Language kernel — hexa VM = kernel
8. Capability-native — ambient 제거
9. **Law-kernel** — syscall 마다 raw.json 체크 ⭐

## B. 메모리 모델 (10)
10. **Single address space** ⭐
11. Tagged pointer (NaN-box 확장)
12. Region-based alloc
13. Linear types kernel
14. Arena per-request — GC 스파이크 제거
15. Persistent memory first-class (PMEM/CXL)
16. HBM as heap — CPU↔HBM UMA
17. Weight-mmap — 모델 = 실행 바이너리
18. **Zero-copy universal** ⭐
19. Page-less small proc

## C. 스케줄러 (8)
20. Cooperative-only — HFT/serving
21. **Batch-aware scheduler** ⭐ (prefill/decode)
22. Work-stealing (Go runtime 스타일)
23. EDF (earliest deadline first)
24. Priority lane per @attr
25. SLA-law 스케줄러
26. AI agent as process
27. GPU co-scheduling

## D. 파일시스템 (9)
28. **Law-tagged inode** ⭐
29. Content-addressable FS — 모델 dedup
30. Log-structured (LFS)
31. Tensor-FS — 파일 = shape+dtype
32. **KV-cache FS** ⭐ — 세션 이어받기
33. Append-only by default
34. Capability FS
35. No FS (unikernel 모드)
36. Versioned FS (git-native)

## E. 네트워크 (8)
37. Kernel bypass 기본
38. RDMA-native
39. QUIC in kernel
40. Tensor transport (NCCL 대체)
41. Smart NIC offload
42. Zero-copy socket
43. Law-firewall (exfiltration 차단)
44. Agent-mesh primitive

## F. 드라이버 (8)
45. **Virtio-only** ⭐ (단계 1)
46. Linux driver shim (binary 호환)
47. user-space 드라이버
48. SPDK-style NVMe
49. Metal/Vulkan passthrough
50. NVIDIA open kernel module 포크
51. NIC-only native
52. USB 포기

## G. 부트 (6)
53. UEFI stub
54. Multiboot2
55. linuxboot (kexec 점프)
56. PXE + unikernel
57. **firecracker microVM** ⭐
58. coreboot payload

## H. Security (9)
59. Law in TEE (SGX/SEV)
60. Sealed inference
61. Confidential compute GPU (H100 CCM)
62. Attestation-native
63. Capability passing over network
64. Memory safe by default
65. Sandbox per model
66. Law audit log (growth_bus)
67. Incident replay

## I. AI-specific 추상화 (12)
68. **Tensor first-class** ⭐ — kernel primitive
69. Batch as process (vLLM continuous batching)
70. **KV-cache as inode** ⭐
71. Attention kernel syscall
72. Model as executable (`hexa run 7b.model`)
73. **Serving loop primitive** ⭐
74. Quantization-aware alloc
75. Speculative decoding native
76. Router kernel (MoE expert 라우팅)
77. Gradient tape as GC root
78. Checkpoint atomic op
79. Token streaming primitive

## J. HW 타겟 (6)
80. M-series 로컬 (개발/데모)
81. **x86 cloud (AWS/GCP nitro)** ⭐ 상용
82. ARM server (Graviton/Ampere)
83. RISC-V (미래)
84. Cerebras / Groq (포기)
85. TPU (포기)

## K. 개발 툴링 (8)
86. QEMU 하네스 (`hexa os run`)
87. JTAG/gdb 통합
88. Deterministic replay
89. ftrace equivalent (hexa tracer)
90. OS fuzzer (syzkaller 하위)
91. Formal proof harness
92. OS unit test
93. Live law patching

## L. 배포 (7)
94. Docker image (unikernel)
95. OCI runtime
96. **Kubernetes node OS** ⭐ (Talos/flatcar 대체)
97. edge appliance (1U 박스)
98. WASI 호환 모드
99. Firecracker guest (Lambda 스타일)
100. Bare metal colo (Hetzner)

## M. 상호운용 (6)
101. Linux ABI 레이어 (Wine 스타일)
102. WASI syscall binding
103. POSIX subset
104. gVisor-like user-space kernel
105. Python interop 최소
106. gRPC/REST 서빙 native

## N. 거버넌스 (6)
107. **law live-update** ⭐
108. growth_bus kernel event
109. blowup 연동 (OS panic 원인 분석)
110. CDO 수렴 게이트
111. dependency quarantine
112. incident auto-bisect

## O. 비즈니스 (5)
113. Inference appliance OSS
114. Cloud provider
115. Open core + 엔터프라이즈
116. Research 라이선스
117. **OEM 파트너십 (Hetzner/Equinix)** ⭐

## P. 실험 (7)
118. AI agent 가 OS 운영
119. OS 자체 AI 학습용 피드백
120. self-healing kernel
121. law 에 의한 auto-patch
122. synthetic benchmark auto-optimize
123. OS 자체 업그레이드 컴파일
124. consciousness 영역 (Anima OS 통합)

## 고갈 선언

124 항목 도달. 이 이상 = 중복 or SF (#124 consciousness 가 경계).
카테고리 A~P 망라. Top 5 → ROADMAP.md.
