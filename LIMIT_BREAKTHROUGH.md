<!-- @created: 2026-05-12 -->
<!-- @scope: real-limits audit — OS-level limits (syscall / context-switch / scheduling / memory hierarchy) -->
<!-- @authority: per LATTICE_POLICY.md §1.2 -->
<!-- @wave: M (limit-breakthrough audit, application repos) -->

# LIMIT_BREAKTHROUGH.md — hexa-os real-limits audit

> **Honest scope**: hexa-os is an **AI-inference appliance OS**
> (unikernel, law-enforced, hexa-lang self-hosted). It is NOT a
> Linux replacement and explicitly caps training-side improvement at
> ~5% (compute-bound). The serving-side p99 30–50% ↓ claim is the
> entire reason this OS exists. This audit names the HARD walls
> that bound that claim and the SOFT envelopes that gate it.

---

## §1 Domain

`hexa-os` targets **single-tenant 7B–70B model serving** on a unikernel
running on Firecracker / KVM. The architecture trades multi-user
generality (which Linux excels at) for **lower syscall cost + lower
context-switch cost + capability-checked I/O** in the inference path.

The dominant performance budgets are:
- **Syscall overhead** — Linux: ~300 ns user→kernel→user; hexa-os
  target: 20–80 ns (function-call cost, single address space)
- **Context-switch cost** — ~3–10 μs on x86-64 Linux (TLB flush +
  cache-pollution + scheduler)
- **Cold-start to first-token** — target <500 ms for 7B model
- **p99 serving latency** — target 30–50% reduction vs Linux baseline

---

## §2 Limits

### §2.1 HARD walls (physics / computability / hardware)

| # | Limit | Bound | Origin |
|---|-------|-------|--------|
| H1 | **Halting / decidability** | Undecidable | Turing 1936 — no OS can prove arbitrary user-code termination |
| H2 | **Context-switch floor** | ~1–3 μs (L1 + TLB + register-save) | Cache + TLB flush; HARD on current ISA/MMU |
| H3 | **Syscall floor (call/ret round trip)** | ~10 ns | Function-call cost (CALL + RET + cache); HARD |
| H4 | **Memory access latency** | L1 ~1 ns, L2 ~4 ns, L3 ~12 ns, DRAM ~80–120 ns | Speed of light + cache hierarchy; HARD |
| H5 | **PCIe / NVMe access** | ~10 μs NVMe Gen4 read | Bus + media; HARD |
| H6 | **CAP theorem** | C·A·P ≤ 2 under partition | Brewer / Gilbert–Lynch — distributed serving (multi-replica) cannot have all three |
| H7 | **Byzantine fault tolerance** | n ≥ 3f+1 for f Byzantine nodes | Lamport–Shostak–Pease; HARD lower bound on replication |
| H8 | **Scheduling: NP-hard general scheduling** | P ≠ NP (assumed) | Multiprocessor scheduling decision problem; HARD optimum |
| H9 | **Speed of light** | 3.3 ns / m | Inter-host latency floor; HARD |

### §2.2 SOFT envelopes (engineering)

| # | Envelope | Current | Breakthrough margin |
|---|----------|---------|---------------------|
| S1 | **Linux syscall round-trip** | ~300 ns (post-Spectre mitigations) | hexa-os target 20–80 ns (10–15× via single-address-space + capability check) |
| S2 | **Linux context-switch** | 3–10 μs | hexa-os: avoid by being unikernel (1 process, no switch) |
| S3 | **Cold-start (containerized 7B serve)** | 5–30 s typical | hexa-os target <500 ms (40–60× via prewarmed unikernel + memory mapping) |
| S4 | **Linux CFS fairness latency** | sched_latency_ns default 6 ms | NP-hard general case; SOFT bound by epoch granularity |
| S5 | **Page-fault cost** | ~1–10 μs | SOFT (huge-pages, mlock can eliminate in hot path) |
| S6 | **TLB miss cost** | 50–200 cycles | SOFT (1 GiB pages, mlocked) |
| S7 | **NUMA cross-socket latency** | 2–3× local DRAM | SOFT (pinning, replicate-on-write) |

### §2.3 Negotiated / standard

- **POSIX API surface** — historical contract; hexa-os deliberately
  abandons it (law-enforced cap-based I/O instead). Not a physical wall.
- **ELF / Mach-O binary format** — standard; hexa-os uses hexa-lang
  bytecode + VM. Not a physical wall.
- **systemd-style service contract** — convention; replaced by
  hexa fn-call dispatch.

---

## §3 Assessment

The **30–50% p99 reduction** claim is bounded by 3 facts:

1. **Syscall savings are real**: ~280 ns saved per syscall × ~10⁴
   syscalls/request → ~3 ms saved per request. For a 7B inference
   serving at p99 ~200 ms (Linux baseline), that is 1.5%. The 30–50%
   p99 gain must come from elsewhere.
2. **Context-switch elimination dominates**: by being unikernel, hexa-os
   pays zero context-switch cost in the serving loop. For p99 tail
   (where Linux scheduler jitter adds 5–30 ms), this is the actual win.
3. **Cold-start gain is largest**: 5–30 s → <500 ms is 10–60× and is
   the strongest claim. This is achievable via *prewarmed image +
   weight mmap + single address space*.

**Honest framing**: 30–50% p99 ↓ is plausible *at the tail*, not the
median. Median latency is GPU-bound and OS can't help much.

H1 (halting) and H6 (CAP) and H7 (Byzantine) are HARD walls hexa-os
**explicitly does not try to break** — instead it sidesteps:
- H1 → law_check refuses unbounded ops; user must use total functions
- H6 → single-tenant single-replica; partition-tolerance traded away
- H7 → no Byzantine consensus in v0.1; out of scope

---

## §4 Top-3 breakthroughs (most plausible 12–24 month)

### B1 — Syscall replacement via single-address-space + capability check (SOFT envelope move on S1)

Replacing trap-based syscalls (INT 0x80 / SYSCALL) with direct function
calls inside a capability-checked single address space cuts the
user→kernel→user round-trip from ~300 ns to ~20–80 ns. The HARD floor
is H3 (~10 ns function call). Existence proofs: MirageOS, IncludeOS,
Unikraft — all report 10×+ syscall improvements. Honest caveat: works
only when the kernel and user code share a trust boundary (no malicious
user code in same address space).

### B2 — Prewarmed unikernel image + weight-mmap → 40–60× cold-start (SOFT envelope move on S3)

Pre-paging the model weights into a Firecracker microVM that boots
from a memory-snapshot image hits <500 ms cold-start for 7B
models — confirmed by Firecracker + vLLM-style snapshotting on AWS
Lambda for ML. The HARD floor is H5 (NVMe ~10 μs/page) × pages
required (~14 GiB / 4 KiB = 3.5M pages) → ~35 s without mmap-on-demand.
Demand-paging the hot subset gets to ~500 ms. Honest caveat: first
inference token is slower (page-faults during forward pass) — must
amortize.

### B3 — Static scheduling via hexa-lang law-checked total-function constraint (SOFT envelope move on S4 + sidesteps H8)

By requiring user code to be expressed in hexa-lang (which enforces
total functions + bounded-loop annotations via type system), the
scheduler can compute a *static* worst-case execution time and
schedule deadline-monotonically. This sidesteps H8 (NP-hard general
scheduling) by restricting the input domain to a tractable subset.
Existence proofs: AUTOSAR / DO-178C / seL4 — all use restricted
function classes for static-schedulable code. Honest caveat: this
restricts what user code is expressible (Turing-incompleteness in the
restricted dialect), trading generality for predictability.

---

## §5 Caveats

1. **Training is capped at ~5%**: hexa-os explicitly does NOT promise
   training speedups beyond ~5% (training is compute-bound by GPU
   FLOPs, not OS overhead). Serving-only.
2. **Linux is not "broken"**: the 30–50% p99 ↓ claim is *for inference
   serving workloads*, not general-purpose computing. Linux remains
   correct for multi-tenant general compute.
3. **Halting is undecidable** (H1) — hexa-os does NOT promise
   termination proofs for arbitrary user code; it restricts the
   language to total functions in the law-checked subset.
4. **CAP and Byzantine** (H6, H7) — not addressed in v0.1; explicitly
   out of scope. Distributed replicated serving is future work.
5. **No n=6 magic**: per `LATTICE_POLICY.md §1.2`, syscall floor /
   context-switch cost / cache hierarchy are not determined by σ(6)=12.
   The lattice is organizing vocabulary inside this repo.
6. **Cold-start measurements** assume warm image cache + warm weight
   tier; first-ever cold-start (image pull + weights from S3) is
   30–60 s and bounded by network throughput.

---

## §6 References

- Turing, A. M. *On Computable Numbers* (1936) — H1
- Brewer, E. *CAP Theorem* (2000); Gilbert & Lynch *Brewer's conjecture and the feasibility of consistent, available, partition-tolerant web services* (2002) — H6
- Lamport, Shostak, Pease, *The Byzantine Generals Problem* (1982) — H7
- Madhavapeddy et al., *Unikernels: Library Operating Systems for the Cloud* (ASPLOS 2013) — B1 evidence
- Firecracker team, *Firecracker: Lightweight Virtualization for Serverless Applications* (NSDI 2020) — B2 evidence
- seL4 team, *seL4: From General Purpose to a Proof of Information Flow Enforcement* (S&P 2013) — B3 evidence (capability + verified kernel)
- Liu & Layland, *Scheduling Algorithms for Multiprogramming in a Hard-Real-Time Environment* (1973) — B3 deadline-monotonic basis
- Intel Optimization Reference Manual — H4 cache latency numbers
- Linux kernel docs `Documentation/scheduler/sched-design-CFS.rst` — S4 CFS bound

---

> *"Inference-serving p99 30–50% ↓ is plausible at the tail.
> The HARD wall is the speed of light. The SOFT envelope is the scheduler."*

— hexa-os Wave M audit (2026-05-12)
