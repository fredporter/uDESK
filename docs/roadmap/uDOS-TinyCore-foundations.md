# uDOS Foundations × TinyCore Integration

## 1. Users & Sessions
- **TinyCore provides:** `tc` user, `sudo`; optional `shadow.tcz`, `pam.tcz`, `openssh.tcz`, `slim.tcz`.
- **uDOS plan:**  
  - Require `shadow.tcz` and `sudo.tcz`.  
  - Optionally use `slim.tcz` for GUI login.  
  - Use `/etc/skel` to seed new user accounts with uDOS defaults.  
  - Each user has `~/.udos/` for vars, data, templates, logs.

## 2. Variables (uVAR)
- **TinyCore provides:** shell env, filetool persistence.  
- **uDOS plan:**  
  - Persistent store: `~/.udos/vars/*.env` or JSON.  
  - CLI helpers: `udos var set/get/list`.  
  - System defaults in `/usr/local/share/udos/vars/`.  

## 3. Data Layers (uDATA)
- **TinyCore provides:** `/home` (persistent), `/var` (ephemeral).  
- **uDOS plan:**  
  - Persistent: `~/.udos/data/` (added to filetool).  
  - Ephemeral: `/var/tmp/udos/` for scratch.  
  - Project data optionally at `/mnt/sdXN/udos/`.  

## 4. Templates (uTEMPLATE)
- **TinyCore provides:** `/etc/skel` for defaults, `/usr/local/share` for app data.  
- **uDOS plan:**  
  - Ship templates in `/usr/local/share/udos/templates/`.  
  - Copy/override to `~/.udos/templates/`.  
  - CLI: `udos tpl render`; Desktop: “New From Template” menu.  

## 5. Desktop UX (uDOS Desktop)
- **TinyCore provides:** Xorg/Xvesa, window managers, tint2, rofi as extensions.  
- **uDOS plan:**  
  - Use Openbox + tint2 + rofi in grid mode.  
  - Config defaults in `/usr/local/share/udos/desktop/`.  
  - Per-user overrides in `~/.udos/desktop/`.  
  - Session started by `~/.xsession` or display manager.  

## 6. Persistence, Housekeeping & Logging

### Persistence
- **TinyCore provides:** `/opt/.filetool.lst`, `filetool.sh`.  
- **uDOS plan:**  
  - Auto-add `~/.udos/**` and configs to `.filetool.lst` via `tce.installed` hook.  
  - Backups ensure persistence across reboots.  

### Housekeeping
- **TinyCore provides:** `cronie.tcz` for scheduled jobs, `/opt/bootlocal.sh` for startup.  
- **uDOS plan:**  
  - `udos-clean` to prune caches/logs.  
  - Hook into `cronie` if present for scheduled tasks.  

### Logging
- **TinyCore provides:** optional `syslog.tcz`.  
- **uDOS plan:**  
  - Default per-user logs at `~/.udos/logs/`.  
  - Integrate with syslog if installed (tagged `udos`).  

## 7. Packaging & Lifecycle
- **TinyCore provides:** `.tcz`, `.dep`, `.info`, onBoot vs OnDemand, `ezremaster.tcz`.  
- **uDOS plan:**  
  - Ship `uDOS-core.tcz`, `uDOS-desktop.tcz`, later `uDOS-extra.tcz`.  
  - Use `.dep` to pull official extensions.  
  - Provide `.info` for Apps browser integration.  
  - Remaster ISO with `ezremaster` once stable.  

---

# Recommendations

| uDOS area | Reuse from TinyCore/Linux | Build in uDOS |
|---|---|---|
| Users/sessions | `shadow.tcz`, `sudo.tcz`, `slim.tcz`, `/etc/skel` | Scaffold uDOS defaults; `~/.udos/` per-user |
| Variables | shell env, filetool | `udos var` CLI + persistent `~/.udos/vars` |
| Data | `/home` persistence, `/var` tmpfs | `~/.udos/data`; `/var/tmp/udos`; optional mount dirs |
| Templates | `/usr/local/share`, `/etc/skel` | uTEMPLATE engine (CLI+GUI) |
| Desktop | Xorg, Openbox, tint2, rofi | uDOS theme + grid configs |
| Persistence | `.filetool.lst`, `filetool.sh` | auto-registration via `tce.installed` |
| Housekeeping | `cronie.tcz`, boot scripts | `udos-clean`, log rotation |
| Logging | `syslog.tcz` | `~/.udos/logs`, syslog integration |
| Packaging | `.tcz`, `.dep`, `.info` | uDOS bundles + installer script |

---

# TinyCore Features to Leverage
- **Boot codes:** `tce=UUID`, `waitusb=5`, `home=`, `opt=`, `restore=`.  
- **OnBoot vs OnDemand:** keep uDOS-core onBoot, extras OnDemand.  
- **/etc/skel:** seed new accounts with uDOS defaults.  
- **/usr/local/share/udos:** canonical system-wide templates, themes, defaults.  

---

# Strategy
- Use TinyCore’s existing structures (persistence, user mgmt, extensions).  
- Publish uDOS as `.tcz` layers, not a fork.  
- Distribute via GitHub Releases first, then optionally TinyCore repo.  
- Provide a remastered ISO (“uDOS-TinyCore Edition”) for turnkey installs.  

---

# Next Steps
1. Create `uDOS-core.tcz.dep` with shadow, sudo, bash, coreutils, util-linux, git, curl.  
2. Add `tce.installed/uDOS-core` script to seed `/etc/skel` and `/usr/local/share/udos`.  
3. Create `uDOS-desktop.tcz` with configs + post-install hook.  
4. Provide initial CLI tools: `udos var`, `udos data`, `udos tpl`, `udos-clean`.  
5. Document persistence and boot codes in `USER-GUIDE.md`.  
