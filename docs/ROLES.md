# uDESK Roles & Permissions

> Role-based security model with markdown-first configuration

## Overview

uDESK uses a three-tier role system where higher roles inherit all features of lower roles. This ensures security through least privilege while maintaining simplicity.

## Role Hierarchy

```
┌─────────────┐
│    Admin    │ ← Full system control + development
├─────────────┤
│  Standard   │ ← Desktop + apps + limited sudo
├─────────────┤
│    Basic    │ ← Minimal shell + markdown tools
└─────────────┘
```

## Role Comparison Matrix

| Feature | Basic | Standard | Admin |
|---------|:-----:|:--------:|:-----:|
| **System Access** |
| Shell access | ✅ | ✅ | ✅ |
| GUI desktop | ❌ | ✅ | ✅ |
| File manager | ❌ | ✅ | ✅ |
| **Permissions** |
| Sudo access | ❌ | Limited | Full |
| Service control | ❌ | ✅ | ✅ |
| Package install | ❌ | User only | System-wide |
| **Development** |
| Text editing | ✅ | ✅ | ✅ |
| Compilers | ❌ | ❌ | ✅ |
| Python/venv | ❌ | Basic | Full |
| Git | ❌ | ✅ | ✅ |
| **Networking** |
| Basic networking | ✅ | ✅ | ✅ |
| Server tools | ❌ | ❌ | ✅ |
| Firewall config | ❌ | ❌ | ✅ |

## Basic Role

**Philosophy**: Secure, minimal environment for focused work.

### Features
- Markdown editing with `micro`
- Markdown viewing with `glow` 
- Basic file operations
- Read-only system access
- No sudo privileges

### Use Cases
- Kiosk systems
- Secure workstations
- Focused writing environments
- Guest access systems

### Configuration
```markdown
# /etc/udos/role-basic.md

## User Account
- **User**: udos
- **Groups**: udos
- **Shell**: /bin/sh
- **Home**: /home/udos

## Allowed Commands
- micro, glow, cat, less, ls, cd, pwd
- grep, find, head, tail
- Basic file operations (read-only system)

## Restricted Areas
- /etc (read-only)
- /usr (read-only)  
- /opt (read-only except /opt/udos/user)
```

### Security Model
```bash
# No sudo access
$ sudo ls
sudo: command not found

# Limited system access
$ ls /etc/shadow
ls: can't open '/etc/shadow': Permission denied

# Markdown workflow works perfectly
$ micro document.md
$ glow document.md
```

## Standard Role

**Philosophy**: Full desktop experience with markdown at the center.

### Features
- All Basic role features
- GUI desktop environment (FLWM)
- Web browser and applications
- Limited sudo for service management
- User-space package installation

### Use Cases
- Daily desktop use
- Content creation
- Light development
- System administration learning

### Configuration
```markdown
# /etc/udos/role-standard.md

## User Account  
- **User**: udos
- **Groups**: udos, udos-standard
- **Shell**: /bin/bash
- **Home**: /home/udos

## Sudo Permissions
- Service control: /usr/local/etc/init.d/*
- User services: /usr/local/bin/udos-service
- User app installation (TCZ to /home)

## GUI Environment
- **Window Manager**: FLWM
- **Terminal**: aterm
- **File Manager**: pcmanfm
- **Browser**: firefox or similar
```

### Sudo Configuration
```bash
# /etc/sudoers.d/udos-standard
%udos-standard ALL=(root) NOPASSWD: /usr/local/etc/init.d/*
%udos-standard ALL=(root) NOPASSWD: /usr/local/bin/udos-service
%udos-standard ALL=(root) NOPASSWD: /usr/local/bin/tce-load -w -i /home/*
```

### Example Workflow
```bash
# Start desktop
$ startx

# Manage services
$ sudo udos-service start nginx
$ sudo /usr/local/etc/init.d/sshd start

# Install user applications  
$ tce-load -w -i /home/tc/optional/my-app.tcz
```

## Admin Role

**Philosophy**: Complete development environment with full system control.

### Features
- All Standard role features
- Full sudo access (NOPASSWD)
- Complete development toolchain
- Python virtual environments
- System debugging tools
- Network administration

### Use Cases
- System development
- uDESK maintenance
- Advanced system administration
- Security research

### Configuration
```markdown
# /etc/udos/role-admin.md

## User Account
- **User**: udos-admin or tc
- **Groups**: udos-admin, wheel, staff
- **Shell**: /bin/bash
- **Home**: /home/udos-admin

## Full Permissions
- Complete sudo access
- System modification
- Package management
- Service configuration
- Network administration

## Development Environment
- GCC toolchain
- Python 3 + pip + venv
- Git, make, cmake
- Debugging tools
- Network utilities
```

### Sudo Configuration
```bash
# /etc/sudoers.d/udos-admin
%udos-admin ALL=(ALL) NOPASSWD:ALL
```

### Development Features
```bash
# Python virtual environments
$ udos-venv create myproject
$ source /opt/udos/venv/myproject/bin/activate
$ pip install markdown beautifulsoup4

# System development
$ git clone https://github.com/user/project
$ cd project && make
$ sudo make install

# System administration
$ sudo iptables -L
$ sudo tcpdump -i eth0
$ sudo systemctl status nginx
```

## Role Management

### Checking Current Role
```bash
# Method 1: Use built-in command
$ udos-detect-role
standard

# Method 2: Check role file
$ cat /etc/udos/role
standard

# Method 3: System info
$ udos-info | grep Role
- **Role**: standard
```

### Changing Roles

#### Temporary Role Change (Until Reboot)
```bash
# Switch to admin role
$ echo "admin" > /etc/udos/role
$ exec bash  # Reload shell

# Verify change
$ udos-detect-role
admin
```

#### Permanent Role Change
```bash
# Change role and persist
$ echo "admin" > /etc/udos/role
$ filetool.sh -b  # Backup to persistence
$ sudo reboot
```

#### Boot-Time Role Override
```bash
# Add to kernel command line
udos.role=basic

# This overrides the saved role file
```

### Role Validation
```bash
# Check role permissions
$ udos-service list
Available services for role: standard
nginx.md
sshd.md
web-server.md

# Test sudo access
$ sudo -l
User udos may run the following commands:
    (root) NOPASSWD: /usr/local/etc/init.d/*
    (root) NOPASSWD: /usr/local/bin/udos-service
```

## Security Considerations

### Principle of Least Privilege

Each role provides exactly the access needed:

- **Basic**: Read-only system, write to user space only
- **Standard**: Service management, user installations  
- **Admin**: Full system control for development/maintenance

### Role Escalation

```bash
# Standard users cannot escalate to admin
$ sudo su -
Sorry, user udos is not allowed to run 'su -' as root

# Must change role and reboot
$ echo "admin" > /etc/udos/role
$ sudo reboot
```

### Audit Trail

```bash
# Check role history
$ grep "Role:" /var/log/udos.log
2024-08-31 12:00:01 Role: basic -> standard
2024-08-31 14:30:15 Role: standard -> admin

# Monitor sudo usage (Admin role)
$ journalctl | grep sudo
```

### Role-Based File Permissions

```bash
# Basic role home directory
drwxr-xr-x  3 udos      udos      4096 /home/udos

# Standard role additional access
drwxrwxr-x  2 udos      udos-standard  4096 /opt/udos/user-apps

# Admin role system access  
drwxrwxr-x  3 udos-admin wheel     4096 /opt/udos/admin-tools
```

## Troubleshooting Roles

### Permission Denied Issues

```bash
# Check current role
$ udos-detect-role

# Check required role for operation
$ ls -la /path/to/restricted/file

# Switch to appropriate role
$ echo "admin" > /etc/udos/role && exec bash
```

### Role Not Switching

```bash
# Verify role file exists and is writable
$ ls -la /etc/udos/role
$ touch /etc/udos/role  # Test write access

# Check for role override in kernel command line
$ cat /proc/cmdline | grep udos.role

# Force role reload
$ exec bash
```

### Missing Role Features

```bash
# Check if role packages are installed
$ tce-status -i | grep udos-role

# Reinstall role package
$ tce-load -i udos-role-standard.tcz

# Verify role configuration
$ ls -la /opt/udos/roles/standard/
```

## Best Practices

### Role Selection Guidelines

- **Start with Basic**: Learn the system safely
- **Use Standard**: For daily desktop work
- **Use Admin**: Only when needed for development/maintenance

### Security Recommendations

1. **Don't run Admin constantly**: Switch to Admin only when needed
2. **Use role-specific accounts**: Different users for different roles
3. **Audit role changes**: Monitor role switching in logs
4. **Test in Basic**: Verify scripts work in restricted environment

### Development Workflow

```bash
# Develop in Admin role
$ echo "admin" > /etc/udos/role && exec bash
$ # Do development work

# Test in Standard role
$ echo "standard" > /etc/udos/role && exec bash  
$ # Test application

# Verify in Basic role
$ echo "basic" > /etc/udos/role && exec bash
$ # Ensure it works in restricted environment
```

---

*Role-based security in uDESK ensures you have exactly the privileges you need, when you need them, while maintaining the markdown-first philosophy throughout.*
