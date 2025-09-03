# uDOS Role Hierarchy System
## Progressive User Capability Framework

### Overview
uDOS implements an 8-tier role system that progressively unlocks capabilities based on user skill and system requirements. Each role is a bolt-on module that extends the base uCORE system with specific tools and permissions.

### Authentic uDOS Role Architecture
```
Level 100: WIZARD    🧙 - Full system architect
Level  80: SORCERER  🔮 - Advanced automation & AI  
Level  60: KNIGHT    ⚔️  - Security & networking
Level  50: IMP       👹 - Scripting & automation
Level  40: CRYPT     💀 - Data & secrets management
Level  30: DRONE     🤖 - Basic automation
Level  20: TOMB      ⚱️  - Archive & backup operations
Level  10: GHOST     👻 - Read-only demo access (default)
```

*Note: These are the authentic uDOS roles, distinct from generic user management systems.*

---

## Role Definitions

### GHOST (Level 10) 👻 - Read-Only Demo Access
**Target User:** Demo users, system evaluation, read-only access
**Core Capabilities:**
- Read-only file system access
- Basic command execution (ls, cat, ps)
- System information viewing
- uDOS CLI demonstration (udos version, udos role)
- Template and data viewing (no editing)

**Tools Included:**
- Basic POSIX commands (limited)
- System information tools
- File viewing utilities
- uDOS read-only interface

**Auto-Detection Criteria:**
- Default role for new installations
- Demo mode installations
- No write permissions required
- System evaluation contexts

**Upgrade Path:** Request access upgrade → TOMB

---

### TOMB (Level 20) ⚱️ - Archive & Backup Operations  
**Target User:** File managers, backup operators, archive specialists
**Core Capabilities:**
- File and directory management
- Archive creation and extraction
- Backup operations and scheduling  
- File permission management
- Basic storage operations

**Tools Added:**
- Archive tools (tar, gzip, zip, unzip)
- File management utilities (find, grep, tree)
- Backup tools (rsync, cp with options)
- Permission tools (chmod, chown basics)
- Directory navigation enhancements

**Auto-Detection Criteria:**
- Regular archive operations
- Backup script usage
- Large file management patterns
- Storage organization activities

**Upgrade Path:** Implement automated processes → DRONE

---

### DRONE (Level 30) 🤖 - Basic Automation
**Target User:** Process automators, script runners, scheduled task managers
**Core Capabilities:**
- Shell scripting execution
- Cron job management
- Basic process automation
- Simple workflows
- Task scheduling

**Tools Added:**
- Shell interpreters (bash, sh enhanced)
- Cron and scheduling tools
- Basic scripting utilities
- Process management tools
- Simple automation frameworks

**Auto-Detection Criteria:**
- Custom scripts present
- Crontab entries
- Automation workflows
- Scheduled task patterns

**Upgrade Path:** Handle sensitive data and encryption → CRYPT

---

### CRYPT (Level 40) 💀 - Data & Secrets Management
**Target User:** Security operators, data protection specialists, secret managers
**Core Capabilities:**
- File encryption and decryption
- Password and secret management
- Certificate handling
- Secure communications
- Data integrity verification

**Tools Added:**
- Encryption tools (gpg, openssl)
- Password managers
- Certificate utilities
- Secure transfer tools (scp, sftp)
- Checksum and verification tools

**Auto-Detection Criteria:**
- Encryption tool usage
- Security-focused workflows
- Certificate management
- Secure communication patterns

**Upgrade Path:** Develop scripting and network skills → IMP

---

### IMP (Level 50) 👹 - Scripting & Automation
**Target User:** Script developers, automation engineers, system integrators
**Core Capabilities:**
- Advanced scripting (Python, Node.js, etc.)
- API integrations
- Complex automation workflows
- Network programming
- System integration

**Tools Added:**
- Programming languages (Python, Node.js)
- API tools (curl, jq, REST clients)
- Network utilities
- Development tools
- Advanced automation frameworks

**Auto-Detection Criteria:**
- Programming language usage
- API integration scripts
- Complex automation
- Development patterns

**Upgrade Path:** Focus on security and networking → KNIGHT

---

### KNIGHT (Level 60) ⚔️ - Security & Networking
**Target User:** Network administrators, security professionals, infrastructure guardians  
**Core Capabilities:**
- Network configuration and monitoring
- Security scanning and analysis
- Firewall and access control
- VPN and secure networking
- Infrastructure security

**Tools Added:**
- Network analysis tools (nmap, netstat)
- Security scanners
- Firewall management (iptables)
- VPN clients and tools
- Monitoring and logging tools

**Auto-Detection Criteria:**
- Network tool usage
- Security configuration
- Infrastructure management
- Monitoring implementations

**Upgrade Path:** Implement AI and advanced automation → SORCERER

---

### SORCERER (Level 80) 🔮 - Advanced Automation & AI
**Target User:** AI/ML practitioners, advanced automation architects, system magicians
**Core Capabilities:**
- Machine learning and AI tools
- Advanced automation orchestration
- API development and services
- Distributed computing
- Intelligent system design

**Tools Added:**
- AI/ML frameworks and tools
- Advanced automation platforms
- Database and storage systems
- API development tools
- Distributed computing utilities

**Auto-Detection Criteria:**
- ML/AI tool usage
- Complex system orchestration
- API service development
- Advanced automation patterns

**Upgrade Path:** Design complete system architectures → WIZARD

---

### WIZARD (Level 100) 🧙 - Full System Architect
**Target User:** System architects, infrastructure designers, platform creators
**Core Capabilities:**
- Complete system design and implementation
- Infrastructure as code
- Platform architecture
- Multi-cloud and hybrid deployments
- System optimization and scaling

**Tools Added:**
- Infrastructure as code tools
- Container orchestration
- Cloud platform utilities
- Performance monitoring
- Architecture design tools

**Auto-Detection Criteria:**
- Infrastructure code present
- System architecture patterns
- Multi-service deployments
- Platform design activities

**Upgrade Path:** Mentor others, contribute to uDOS development

---

## Technical Implementation

### Role Detection System
The uDOS system automatically detects user capabilities and assigns appropriate roles:

```bash
#!/bin/sh
# udos-detect-role - Analyze user capabilities and assign role

detect_user_role() {
    local score=10  # Default GHOST
    
    # Check for file management patterns
    [ -d ~/.udos ] && score=$((score + 5))
    find ~ -name "*.tar.gz" -o -name "*.zip" 2>/dev/null | head -1 >/dev/null && score=$((score + 10))
    
    # Check for automation
    crontab -l 2>/dev/null | grep -q . && score=$((score + 10))
    find ~ -name "*.sh" 2>/dev/null | head -1 >/dev/null && score=$((score + 5))
    
    # Check for encryption/security
    [ -d ~/.gnupg ] && score=$((score + 10))
    [ -d ~/.ssh ] && [ -f ~/.ssh/config ] && score=$((score + 10))
    
    # Check for programming
    find ~ -name "*.py" -o -name "*.js" 2>/dev/null | head -1 >/dev/null && score=$((score + 15))
    
    # Check for networking/security tools
    command -v nmap >/dev/null 2>&1 && score=$((score + 15))
    command -v iptables >/dev/null 2>&1 && score=$((score + 10))
    
    # Check for advanced automation
    command -v ansible >/dev/null 2>&1 && score=$((score + 20))
    command -v docker >/dev/null 2>&1 && score=$((score + 15))
    
    # Check for architecture tools
    command -v terraform >/dev/null 2>&1 && score=$((score + 30))
    command -v kubectl >/dev/null 2>&1 && score=$((score + 25))
    
    # Assign role based on score
    if [ $score -ge 100 ]; then echo "WIZARD"
    elif [ $score -ge 80 ]; then echo "SORCERER"  
    elif [ $score -ge 60 ]; then echo "KNIGHT"
    elif [ $score -ge 50 ]; then echo "IMP"
    elif [ $score -ge 40 ]; then echo "CRYPT"
    elif [ $score -ge 30 ]; then echo "DRONE"
    elif [ $score -ge 20 ]; then echo "TOMB"
    else echo "GHOST"
    fi
}
```

### Role Package Structure
Each role is distributed as a TinyCore extension package:

```
build/
├── udos-role-ghost.tcz      # Level 10 - Read-only tools
├── udos-role-tomb.tcz       # Level 20 - Archive tools  
├── udos-role-drone.tcz      # Level 30 - Automation tools
├── udos-role-crypt.tcz      # Level 40 - Security tools
├── udos-role-imp.tcz        # Level 50 - Scripting tools
├── udos-role-knight.tcz     # Level 60 - Network/security tools
├── udos-role-sorcerer.tcz   # Level 80 - AI/ML tools
└── udos-role-wizard.tcz     # Level 100 - Architecture tools
```

### Installation Integration
Role detection and package installation is integrated into the main installer:

```bash
# In install.sh
DETECTED_ROLE=$(udos-detect-role)
echo "Detected role: $DETECTED_ROLE"

# Install base system + role package
tce-load -wi udos-core udos-role-$(echo "$DETECTED_ROLE" | tr 'A-Z' 'a-z')
```

## Development Standards

### Clean Separation
- **Production**: Core role detection and package system
- **Development**: All testing and validation in `/dev` directory
- **Documentation**: Role-specific guides and tutorials

### Future Enhancements
- **Learning Paths**: Specific challenges to unlock next role
- **Progress Tracking**: Visual indicators of advancement
- **Community Features**: Role-based collaboration tools
- **Mentoring System**: Higher roles guide lower roles

*This hierarchy provides clear progression while maintaining the authentic uDOS identity and clean system architecture.*

*Updated: 2025-09-03 - Corrected role definitions and clean implementation*
