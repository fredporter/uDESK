# uDOS Role Hierarchy System
## M2: 8-Level Progressive User Capability Framework

### Overview
uDOS implements an 8-tier role system that progressively unlocks capabilities based on user skill and system requirements. Each role is a bolt-on module that extends the base uCORE system.

### Role Architecture
```
Level 100: WIZARD    - Full system architect
Level  80: SORCERER  - Advanced automation & AI
Level  60: IMP       - Network & security specialist  
Level  40: KNIGHT    - DevOps & deployment expert
Level  30: DRONE     - Basic automation worker
Level  20: CRYPT     - Data & security handler
Level  15: TOMB      - File & storage manager
Level  10: GHOST     - Basic CLI user (default)
```

---

## Role Definitions

### GHOST (Level 10) - Default Role
**Target User:** CLI beginners, basic system interaction
**Core Capabilities:**
- Basic file operations (ls, cp, mv, rm)
- Simple text editing (nano, basic vim)
- Process viewing (ps, top)
- Package installation (tce-load)
- uDOS CLI (udos, uvar, udata, utpl)

**Tools Added:**
- `nano` - Simple text editor
- `htop` - Process viewer
- `curl` - Network downloads
- `git` - Basic version control

**Auto-Detection Criteria:**
- Default for all new users
- No programming languages detected
- No advanced tools in PATH
- First-time uDOS installation

**Upgrade Path:** Complete basic CLI tutorial → TOMB

---

### TOMB (Level 15) - File & Storage Manager  
**Target User:** Users managing files, archives, backups
**Core Capabilities:**
- Advanced file operations (find, grep, awk)
- Archive management (tar, gzip, zip)
- File permissions & ownership
- Basic scripting (simple bash)
- Storage mounting & management

**Tools Added:**
- `find` & `grep` - Advanced file search
- `tar`, `gzip`, `unzip` - Archive tools
- `rsync` - File synchronization
- `tree` - Directory visualization
- `du` & `df` - Disk usage tools

**Auto-Detection Criteria:**
- Manages large file collections
- Uses archive tools regularly
- Basic shell scripting present
- File organization patterns detected

**Upgrade Path:** Write backup scripts → CRYPT

---

### CRYPT (Level 20) - Data & Security Handler
**Target User:** Users handling sensitive data, encryption
**Core Capabilities:**
- File encryption/decryption (gpg, openssl)
- Password management
- Basic security tools
- Data validation & checksums
- Secure file transfer

**Tools Added:**
- `gpg` - PGP encryption
- `openssl` - SSL/TLS tools
- `pass` - Password manager
- `scp`, `sftp` - Secure file transfer
- `md5sum`, `sha256sum` - Checksums

**Auto-Detection Criteria:**
- Security tools in use
- Encrypted files present
- SSH keys configured
- Privacy-conscious behavior

**Upgrade Path:** Implement security workflows → DRONE

---

### DRONE (Level 30) - Basic Automation Worker
**Target User:** Users creating simple automation, basic programming
**Core Capabilities:**
- Shell scripting (bash, sh)
- Cron job management
- Basic programming (python/node basics)
- Simple API calls
- Log monitoring & analysis

**Tools Added:**
- `python3` - Python programming
- `node` - JavaScript runtime
- `jq` - JSON processing
- `cron` - Job scheduling
- `tmux` - Terminal multiplexing

**Auto-Detection Criteria:**
- Custom scripts in ~/bin or ~/.local/bin
- Crontab entries present
- Programming files (.py, .js, .sh)
- API usage patterns

**Upgrade Path:** Deploy multi-script systems → KNIGHT

---

### KNIGHT (Level 40) - DevOps & Deployment Expert
**Target User:** Users deploying applications, managing servers
**Core Capabilities:**
- Container management (docker basics)
- Service deployment
- Process monitoring
- Network configuration
- Performance optimization

**Tools Added:**
- `docker` - Container platform
- `systemctl` - Service management
- `nginx` - Web server
- `supervisor` - Process control
- `netstat`, `ss` - Network tools

**Auto-Detection Criteria:**
- Services/daemons running
- Docker or container usage
- Web server configuration
- Network service management

**Upgrade Path:** Manage distributed systems → IMP

---

### IMP (Level 60) - Network & Security Specialist
**Target User:** Network administrators, security professionals
**Core Capabilities:**
- Advanced networking (VPN, firewall)
- Security scanning & monitoring
- Network troubleshooting
- Advanced encryption
- Penetration testing basics

**Tools Added:**
- `nmap` - Network scanning
- `wireshark-cli` - Packet analysis
- `iptables` - Firewall management
- `openvpn` - VPN client
- `fail2ban` - Intrusion prevention

**Auto-Detection Criteria:**
- Network analysis tools usage
- Firewall rules configured
- VPN connections
- Security scanning activity

**Upgrade Path:** Implement AI/ML systems → SORCERER

---

### SORCERER (Level 80) - Advanced Automation & AI
**Target User:** AI/ML practitioners, advanced automation architects
**Core Capabilities:**
- Machine learning frameworks
- Advanced automation (Ansible, etc.)
- API development & integration
- Advanced scripting languages
- Distributed computing

**Tools Added:**
- `python3` with ML libraries (pip install tensorflow, etc.)
- `ansible` - Configuration management
- `redis` - In-memory database
- `postgresql` - Database server
- AI development tools

**Auto-Detection Criteria:**
- ML/AI code present
- Complex automation scripts
- Database usage
- API service deployment
- Advanced programming patterns

**Upgrade Path:** Design complete systems → WIZARD

---

### WIZARD (Level 100) - Full System Architect
**Target User:** System architects, infrastructure designers
**Core Capabilities:**
- Full system design & implementation
- Infrastructure as code
- Multi-cloud deployment
- Advanced security architecture
- Complete DevOps pipelines

**Tools Added:**
- `terraform` - Infrastructure as code
- `kubernetes` tools - Container orchestration
- `prometheus` - Monitoring stack
- Advanced development environments
- Full cloud CLI tools

**Auto-Detection Criteria:**
- Infrastructure as code present
- Multi-service architectures
- Advanced deployment patterns
- System architecture documentation
- Teaching/mentoring activity

**Upgrade Path:** Mentor others, contribute to uDOS core

---

## Implementation Strategy

### Phase 1: Detection Engine
1. **User Capability Scanner** - Analyze installed tools, file patterns, usage history
2. **Role Assignment Logic** - Automatic role detection with manual override
3. **Progress Tracking** - Monitor user advancement through levels

### Phase 2: Module System  
1. **Role Packages** - Each role as .tcz extension module
2. **Progressive Installation** - Install role-specific tools on upgrade
3. **Configuration Management** - Role-specific settings and shortcuts

### Phase 3: Learning Paths
1. **Upgrade Challenges** - Specific tasks to unlock next role
2. **Documentation** - Role-specific tutorials and guides
3. **Community Features** - Role-based collaboration and mentoring

---

## Technical Implementation

### Role Detection Script
```bash
#!/bin/bash
# udos-detect-role - Analyze user capabilities and assign role

detect_user_role() {
    local score=10  # Default GHOST
    
    # Check for programming languages
    [ -f ~/.vimrc ] || [ -f ~/.emacs ] && score=$((score + 2))
    find ~ -name "*.py" -o -name "*.js" -o -name "*.sh" 2>/dev/null | head -1 && score=$((score + 5))
    
    # Check for automation
    crontab -l 2>/dev/null | grep -q . && score=$((score + 10))
    
    # Check for security tools
    command -v gpg >/dev/null && score=$((score + 5))
    [ -d ~/.ssh ] && [ -f ~/.ssh/config ] && score=$((score + 5))
    
    # Check for DevOps
    command -v docker >/dev/null && score=$((score + 15))
    systemctl --user list-units 2>/dev/null | grep -q . && score=$((score + 10))
    
    # Check for advanced tools
    command -v ansible >/dev/null && score=$((score + 20))
    command -v terraform >/dev/null && score=$((score + 30))
    
    # Assign role based on score
    if [ $score -ge 100 ]; then echo "WIZARD"
    elif [ $score -ge 80 ]; then echo "SORCERER"  
    elif [ $score -ge 60 ]; then echo "IMP"
    elif [ $score -ge 40 ]; then echo "KNIGHT"
    elif [ $score -ge 30 ]; then echo "DRONE"
    elif [ $score -ge 20 ]; then echo "CRYPT"
    elif [ $score -ge 15 ]; then echo "TOMB"
    else echo "GHOST"
    fi
}
```

### Role Module Structure
```
build/
├── udos-role-ghost.tcz      # Level 10 tools
├── udos-role-tomb.tcz       # Level 15 tools  
├── udos-role-crypt.tcz      # Level 20 tools
├── udos-role-drone.tcz      # Level 30 tools
├── udos-role-knight.tcz     # Level 40 tools
├── udos-role-imp.tcz        # Level 60 tools
├── udos-role-sorcerer.tcz   # Level 80 tools
└── udos-role-wizard.tcz     # Level 100 tools
```

---

*This role hierarchy provides a clear progression path for users while keeping the base system lightweight and focused.*
