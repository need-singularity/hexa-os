# TAPE-AUDIT — hexa-os

**Date:** 2026-05-14 · **Lens:** `.tape` (typed events + 5 placements) — heaviest in this audit per spec ("AI inference appliance OS — boot/runtime ledgers possible").

## A. Audit-class ledgers

`state/markers/*.marker` — uniform dancinlab boot-hook touchstones **plus** `hexa_os_self_mk2_tuning_landed.marker`, `hexa_os_mk2_rewrite_landed.marker` (milestone "landed" markers — domain-specific). `state/proposals/inventory.json` — **the unique surface in this audit set**: a JSON inventory of OS proposals (DESIGN-ledger, not cargo — checked-in, structured). `.hook-commands/active.json` — hook-config (state, not event log). `.hook-audit*`/`.raw-audit*` absent (the `.raw-ref` at root is a single 385-byte reference pointer, not an audit). 4 `.roadmap.hexa_os_*` files (boot / design / kernel / self_mk2_tuning) — design ledgers (structured roadmap text, not append-only event JSONL). No `.jsonl`.

## B. Identity surface

`hexa.toml` no `[identity]`. `.hexa-attrs` and `.hexa-init/` hold attrs/init state. OS-substrate identity is per-installation runtime, not in repo. `unified-service/` dir present (deeper subsystem inventory).

## C. Domain.md files

**1 UPPERCASE.md** — `ROADMAP.md`. Plus `hexa-ios/hexa-ios.md` + `hexa-macos/hexa-macos.md` (lowercase). Convention barely adopted at root.

## D. Per-run / per-event history

`state/proposals/inventory.json` is the closest to a structured-event surface (proposal-inventory, append-style by convention). The `.roadmap.*` design files carry phase/milestone progress as structured text. `_landed.marker` files (rare in siblings) encode mk2 rewrite + self-tuning landings as named-event markers — distinct vs the cargo timestamp-only pattern.

## E. Promotion candidates

- **`.tape` boot-event stream** (HIGH semantic fit per spec). An OS boot/runtime is the canonical event-stream shape: `@S` system event · `@K` kept-state · `@D` decision · `@P` provenance. Today: zero live boot ledger, only the static proposal inventory.
- **`<OS>.tape` / atlas tape**: OS proposals + landed milestones are a natural fit for a structured `HEXA-OS.tape` (`@D` proposal · `@R` landed-or-rejected · `@H` per-mk2 milestone).
- **n6 atoms** (LIGHT): kernel/boot invariants — but real-limits dominate.
- **hxc / n12**: kernel byte-level state plausible hxc.

## Verdict

**MEDIUM** — the only repo in this audit with a checked-in structured-state surface (`state/proposals/inventory.json` + `_landed.marker` named-events + `.roadmap.*` design ledgers + `.hook-commands/active.json`). Still pre-impl for live boot/runtime event streams — but the design surface is the heaviest of the application-substrate group.
