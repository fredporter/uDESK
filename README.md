# uDESK v1.0.6 on TinyCore — Roadmap & Architecture Plan 

> Status: **Draft for review**  
> Scope: Integrate uDOS 1.0.5 tightly with TinyCore Linux as uDESK, adopt a role‑based permission model with extension stacking, and treat the full system as an isolated environment (while still using Python virtualenvs where helpful).  
> Branching: 1.0.5 is capped; create **v1.0.6-main** (or promote to **main** post‑cutover) and maintain **release/1.0.5.x** for patches.

---

## 0) Objectives

- **Deep TinyCore integration**: use TinyCore core functions, boot flow, persistence, and official extensions instead of custom packaging.
- **Role‑based permissions**: higher roles inherit features of lower roles; enforce least privilege; ship features as stacked extension bundles.
- **“Whole‑system venv”**: uDOS runs inside a TinyCore image/VM/USB live system (safe to enable GUI & Python servers). Still use Python venvs for app isolation when appropriate.
- **Modular UX**: GUI, dev tools, and servers enabled by role and by installed bundles — not by default.
- **Reproducible builds**: deterministic packaging, CI pipeline, test matrix, and signed artefacts (TCZ/ISO).

---

## 1) Architecture Overview

### 1.1 Layered architecture (concept)

```
+--------------------------------------------------------------+
|                     User Space / Apps                        |
|  Optional apps (browser, editor, IDE, tauri UI, servers)     |
+--------------------- Role Packs (TCZ) -----------------------+
|  udos-role-admin   |  udos-role-standard  | udos-role-basic  |
|  (inherits lower)  |  (inherits basic)    |  (base features)  |
+----------------------- uDOS Core (TCZ) ----------------------+
|  udos-core: configs, services, policies, first-boot, tools   |
+------------------- TinyCore Extensions (TCZ) ----------------+
|  X/FLWM | net | ssh | python | git | compiletc | ...         |
+------------------------ TinyCore Base -----------------------+
|         Kernel | init | busybox | rootfs | bootloader        |
+------------------------ Hardware / VM -----------------------+
```

### 1.2 Packaging model

- **udos-core.tcz** — common configs, artwork/branding, service scripts, policy stubs, first‑boot wizard.
- **udos-role-basic.tcz** — minimal desktop/shell toolchain; no sudo for general user; kiosk‑capable.
- **udos-role-standard.tcz** — adds GUI, user apps, limited sudo, developer conveniences (without compilers).
- **udos-role-admin.tcz** — adds compilers/SDKs, Python + venv tooling, optional servers and admin utilities.
- Optional **meta‑bundles** (e.g. `udos-devkit.tcz`, `udos-creative.tcz`, `udos-media.tcz`) that depend on role packs.

> Each higher pack **depends on** the lower pack(s). TinyCore will auto‑pull dependencies when loading TCZs.

---

## 2) Roles & Permissions

### 2.1 Role tiers (inheritance)

| Role                | Account model                 | Privileges (indicative)                              | Typical features |
|---------------------|-------------------------------|------------------------------------------------------|------------------|
| **Basic**           | `udos` user (no sudo)         | Run whitelisted apps; no system changes              | Minimal shell + optional minimal GUI |
| **Standard**        | `udos` user + limited sudo    | Install user apps; manage user services; no system‑wide pkg ops | Full GUI, editors, browser, user‑level dev tools |
| **Admin**           | `tc` or `udos-admin` (sudo ALL)| Full administration; install/remove TCZ; develop/build | Compilers, Python, servers, networking tools |

### 2.2 Enforcement

- **Users/groups**: create `udos`, `udos-admin` and groups `udos`, `udos-wheel`.
- **sudoers**: `/etc/sudoers.d/udos-roles` (persisted) —
  - Basic: **no** sudo.
  - Standard: `NOPASSWD:` for a **narrow** set of commands (e.g. service control in `/usr/local/etc/init.d`), no package ops.
  - Admin: `NOPASSWD:ALL` or passworded sudo, project decision.
- **FS permissions**: root‑owned system dirs; ACLs only if required. App configs under `/home/udos/.config/`.
- **Policy scripts**: shell wrappers in `udos-core` to gate sensitive ops by `id -u`/group and role markers.

---

## 3) Extension Stacks (indicative)

> Names are indicative; confirm against TinyCore repo during implementation.

### 3.1 Base
- `ca-certificates.tcz`, `curl.tcz`, `wget.tcz`, `openssh.tcz`, `git.tcz`, `nano.tcz`/`vim.tcz`.
- Networking: `wireless_tools.tcz`/`wifi.tcz` (as needed), `dhcpcd.tcz`.
- GUI (switchable): `Xorg-7.7.tcz` or `Xvesa.tcz`, `flwm.tcz`, `aterm.tcz`.

### 3.2 Standard add‑ons
- Editors (micro/vscode‑server optional), file manager, web browser.
- Quality‑of‑life: clipboard, fonts, locale packs.

### 3.3 Admin add‑ons
- `compiletc.tcz` (toolchain), `python3.tcz` + `python3-pip.tcz`, `make.tcz`, `cmake.tcz`.
- Optional: `node.tcz`, `go.tcz`, `docker.tcz` (if available/appropriate), DB clients, Wi‑Fi/BT dev tools.

### 3.4 uDOS meta packs (examples)
- **udos-devkit**: depends on Admin + adds `git`, `python venv` bootstrap, `supervisor` (or runit/s6), test runners.
- **udos-creative**: depends on Standard + media codecs, image tools.
- **udos-network**: depends on Admin + networking diagnostics, SSH tooling.

---

## 4) “Whole‑System venv” & Python

- **System isolation**: uDOS is shipped as a TinyCore ISO/IMG/VM; safe to enable GUI and local servers without impacting a host OS.
- **Python strategy**: ship Python via TCZ in Admin role; for apps/labs create **per‑app venvs** under `/opt/udos/venv/<app>` to avoid polluting the base.
- **Service model**: optional `supervisord` (or runit/s6) to run user‑approved services; Standard can start user‑space services, Admin can register system‑wide.

---

## 5) Boot, Persistence & Services

### 5.1 Boot flow
```
Bootloader → TinyCore kernel/init → load base TCZ → load udos-core →
read role (kernel cmdline or /etc/udos/role) → load role bundle(s) →
first-boot (if needed) → start X/desktop (if enabled) → launch UDOS UI/Welcome
```

### 5.2 Persistence (TinyCore idioms)
- Use `/opt/.filetool.lst` for files to back up; `/opt/.xfiletool.lst` to exclude.
- Defaults to persist: `/home/udos`, `/home/tc`, `/etc/sudoers.d/udos-roles`, `/etc/udos/*`, select app configs.
- Keep logs ephemeral by default; add a toggle to persist logs for debugging.

### 5.3 Services
- Prefer TinyCore’s init hooks: `/opt/bootlocal.sh` for startup; `/opt/shutdown.sh` for shutdown.
- Store service scripts under `/usr/local/etc/init.d/` (packaged in `udos-core`).
- Provide `udos-service` helper to list/enable/disable role‑safe services.

---

## 6) Security Model

- **Least privilege** by role; no passwordless escalation for non‑Admin.
- **Network hardening**: firewall rules (optional TCZ), disable inbound services by default.
- **Supply‑chain**: pin TCZ versions for releases; verify hashes; sign uDOS packs and ISO.
- **User data**: segregate per‑user under `/home/…`; encrypted persistence is an opt‑in (documented).

---

## 7) UX Policy (GUI, CLI, and Apps)

- **Basic**: CLI‑first; optional minimal X for kiosk/launcher; curated app set.
- **Standard**: Full desktop; editors, browser, file manager; no compilers by default.
- **Admin**: Desktop + dev tools; can run local servers (docs clarify safe defaults & ports).
- **Tauri / uNETWORK**: ship as optional app in Standard/Admin bundles; disabled in Basic.
- **uSCRIPT**: shipped but locked in Basic; unlocked progressively (Standard: user scripts; Admin: system scripts/services).

---

## 8) Repository & Branching

- **release/1.5.x** — frozen for patches only; tag `v1.5.⟨n⟩`.
- **v1.6-main** — new default development branch for 1.6.
- **packaging/** — TCZ specs, `mksquashfs` recipes, post‑install scripts.
- **isos/** — build scripts for ISO/IMG remastering.
- **docs/** — INSTALL, ROLES, SECURITY, BUILD, RELEASE, FAQ.

---

## 9) Build & CI/CD

- **Build steps**:
  1) Resolve extension lists; `tce-load -wi …` in a controlled chroot/VM.
  2) Build `udos-*.tcz` via `mksquashfs` with post‑install hooks.
  3) Remaster ISO/IMG with base + udos packs (e.g. ezremaster or custom script).
  4) Embed role selector and first‑boot wizard.
- **CI**: GitHub Actions to produce TCZs + ISO/IMG per commit; sign artefacts; attach to Releases.
- **Reproducibility**: lock TCZ versions; publish SBOM; cache artefacts.

---

## 10) Testing Matrix (minimum)

| Area         | Basic | Standard | Admin |
|--------------|:-----:|:--------:|:-----:|
| Boot & login |  ✅   |    ✅    |  ✅   |
| Persistence  |  ✅   |    ✅    |  ✅   |
| GUI desktop  |  △(opt) |  ✅    |  ✅   |
| Role switch  |  ✅   |    ✅    |  ✅   |
| Sudo policy  |  ✅   |    ✅    |  ✅   |
| Network      |  ✅   |    ✅    |  ✅   |
| Python/venv  |  —    |   △     |  ✅   |
| Services     |  —    |   △     |  ✅   |

Legend: ✅ covered / △ partial / — not applicable

---

## 11) Milestones & Deliverables

### M0 — Scope & Baseline (1 sprint)
- Finalise role definitions; lock extension lists; cut `v1.6-main`.
- Deliverables: Role spec, extension manifest, repo scaffolding.

### M1 — Core Integration (1–2 sprints)
- Package `udos-core.tcz`; implement boot hooks; persistence defaults.
- Deliverables: Boot to CLI with `udos-core` active; first‑boot runs.

### M2 — Roles & Policies (1–2 sprints)
- Implement users/groups, sudoers, `udos-service` helper; role detection.
- Deliverables: Switchable roles; enforcement verified; tests green.

### M3 — GUI & Apps (1–2 sprints)
- Standard desktop; app set; kiosk profile for Basic; optional Tauri/uNETWORK.
- Deliverables: Desktop images; kiosk mode demo.

### M4 — Dev & Python (1 sprint)
- Admin toolchain; Python + venv helper; sample service via supervisor.
- Deliverables: `udos-devkit.tcz`; example app running in venv.

### M5 — Packaging & ISO (1 sprint)
- Remastered ISO/IMG; signing; SBOM; docs first pass.
- Deliverables: Installable image + TCZs published.

### M6 — Beta & Feedback (1 sprint)
- Wider testing (old hardware & VM); perf and polish.
- Deliverables: `v1.6.0-beta` artefacts, bug triage list.

### M7 — RC & GA (1 sprint)
- Documentation freeze; release notes; final sign‑off.
- Deliverables: `v1.6.0` release (ISO/IMG + TCZs), docs set.

---

## 12) Documentation Set (required)
- **INSTALL.md** — ISO/IMG boot, USB prep, VM how‑to, persistence.
- **ROLES.md** — role matrix, permissions, how to change roles safely.
- **SECURITY.md** — defaults, sudoers policy, network posture, updates.
- **BUILD.md** — building TCZs & images, version pinning, signing.
- **RELEASE.md** — versioning, branching, artefact checklist.
- **FAQ.md** — common ops (add package, reset persistence, recover admin).

---

## 13) Open Questions / Decisions
- Passworded vs NOPASSWD sudo for Admin in default images.
- Whether Standard can install TCZ on‑demand (leaning **no**, keep to Admin).
- Default desktop (Xvesa vs Xorg) and compositor; font set.
- Whether to include container tooling (e.g., Docker) in Admin by default.

---

## 14) Quick Start (developer)

```bash
# 1) Clone and set up build env
$ git clone https://github.com/<org>/uDOS && cd uDOS
$ git switch -c v1.6-main

# 2) Build core TCZs (scripted)
$ ./packaging/build_udos_core.sh
$ ./packaging/build_udos_roles.sh  # basic, standard, admin

# 3) Assemble ISO/IMG
$ ./isos/make_image.sh --role admin --with-devkit

# 4) Boot in VM and test
$ ./isos/run_qemu.sh --image out/udos-v1.6-admin.img
```

---

## 15) Appendix — Sample Persistence Lists

**/opt/.filetool.lst** (persist)
```
/home/udos
/home/tc
/etc/udos
/etc/sudoers.d/udos-roles
/usr/local/etc/init.d
/opt/udos
```

**/opt/.xfiletool.lst** (exclude from backup)
```
/var/log/*
/tmp/*
/cache/*
```

---

### End

