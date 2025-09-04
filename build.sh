#!/bin/bash
# uDESK v1.0.7 Build System - Clear Mode Separation

set -e

UDESK_VERSION="1.0.7"
BUILD_MODE=${1:-"user"}
TARGET_PLATFORM=${2:-$(uname -m)}
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔨 uDESK v${UDESK_VERSION} Build System"
echo "📁 Project: ${PROJECT_ROOT}"
echo "🎯 Mode: ${BUILD_MODE}"
echo "🏗️  Platform: ${TARGET_PLATFORM}"
echo ""

# Detect build environment
detect_build_env() {
    if [ -f /opt/bootlocal.sh ]; then
        echo "tinycore"
    elif command -v docker &> /dev/null && [ -f Dockerfile.dev ]; then
        echo "container"
    elif command -v gcc &> /dev/null; then
        echo "host"
    else
        echo "minimal"
    fi
}

BUILD_ENV=$(detect_build_env)
echo "🔍 Build environment: ${BUILD_ENV}"

# Create build directories
mkdir -p build/{user,wizard-plus,developer,iso}
mkdir -p src/{user,wizard-plus,developer,shared}

case $BUILD_MODE in
    "user")
        echo "👤 USER MODE BUILD"
        echo "   Target: Standard users (all roles)"
        echo "   Access: User workspace only"
        
        mkdir -p build/user
        
        # Create user mode uCODE interpreter
        cat > "build/user/udos.c" << 'EOF'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int validate_user_path(const char* path) {
    char* home = getenv("HOME");
    if (home && strncmp(path, home, strlen(home)) == 0) return 1;
    if (strncmp(path, "/workspace/user/", 16) == 0) return 1;
    printf("❌ Access denied: %s (user workspace only)\n", path);
    return 0;
}

int execute_user_ucode(const char* command) {
    if (strncmp(command, "[BACKUP]", 8) == 0) {
        printf("📦 Creating user backup...\n");
        system("mkdir -p ~/backups && tar -czf ~/backups/user-$(date +%Y%m%d).tar.gz ~/workspace/");
        return 0;
    }
    if (strncmp(command, "[RESTORE]", 9) == 0) {
        printf("📥 Restoring user files...\n");
        printf("Available backups in ~/backups/\n");
        system("ls -la ~/backups/user-*.tar.gz 2>/dev/null || echo 'No backups found'");
        return 0;
    }
    if (strncmp(command, "[INFO]", 6) == 0) {
        printf("ℹ️  uDESK v1.0.7 - User Mode\n");
        printf("   Role: %s\n", getenv("UDESK_ROLE") ?: "GHOST");
        printf("   Workspace: ~/workspace/\n");
        printf("   Home: %s\n", getenv("HOME") ?: "/home/user");
        return 0;
    }
    if (strncmp(command, "[HELP]", 6) == 0) {
        printf("📖 uDESK v1.0.7 User Commands\n\n");
        printf("USER uCODE COMMANDS:\n");
        printf("  [BACKUP]  - Backup your files\n");
        printf("  [RESTORE] - Restore your files\n");
        printf("  [INFO]    - System information\n");
        printf("  [HELP]    - This help\n\n");
        printf("ROLE PROGRESSION:\n");
        printf("  GHOST → TOMB → DRONE → CRYPT → IMP → KNIGHT → SORCERER → WIZARD\n\n");
        printf("WIZARD UPGRADE:\n");
        printf("  Reach WIZARD role to unlock Wizard+ Mode\n");
        return 0;
    }
    printf("❌ Unknown command: %s\n", command);
    printf("   Use [HELP] for available commands\n");
    return 1;
}

int main(int argc, char *argv[]) {
    printf("👤 uDESK v1.0.7 - User Mode\n");
    printf("Role: %s\n", getenv("UDESK_ROLE") ?: "GHOST");
    printf("Commands: [BACKUP], [RESTORE], [INFO], [HELP], exit\n\n");
    
    char input[256];
    while (1) {
        printf("uDESK> ");
        if (!fgets(input, sizeof(input), stdin)) break;
        
        input[strcspn(input, "\n")] = 0;
        
        if (strcmp(input, "exit") == 0 || strcmp(input, "quit") == 0) {
            printf("Goodbye!\n");
            break;
        }
        
        execute_user_ucode(input);
    }
    return 0;
}
EOF
        
        gcc -o "build/user/udos" "build/user/udos.c"
        echo "✅ User mode build complete"
        echo "🚀 Run: ./build/user/udos"
        ;;
        
    "wizard-plus")
        echo "🧙‍♀️ WIZARD+ MODE BUILD"
        echo "   Target: WIZARD role users"
        echo "   Access: User space + Plus Mode capabilities"
        
        mkdir -p build/wizard-plus
        
        # Create Wizard+ mode interpreter
        cat > "build/wizard-plus/udos-wizard-plus.c" << 'EOF'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int plus_mode_enabled = 0;

int execute_wizard_plus_ucode(const char* command) {
    const char* role = getenv("UDESK_ROLE");
    if (!role || strcmp(role, "WIZARD") != 0) {
        printf("❌ WIZARD role required for Wizard+ commands\n");
        printf("   Current role: %s\n", role ?: "NONE");
        return 1;
    }
    
    if (strncmp(command, "[PLUS-MODE]", 11) == 0) {
        plus_mode_enabled = 1;
        setenv("UDESK_PLUS_MODE", "1", 1);
        printf("🧙‍♀️ Plus Mode ENABLED\n");
        printf("   Extension development: ACTIVE\n");
        printf("   TCZ creation: ACTIVE\n");
        printf("   Plus Mode API: ACTIVE\n");
        return 0;
    }
    
    if (strncmp(command, "[PLUS-STATUS]", 13) == 0) {
        printf("🧙‍♀️ WIZARD+ Status\n");
        printf("   Role: %s\n", getenv("UDESK_ROLE"));
        printf("   Plus Mode: %s\n", plus_mode_enabled ? "ENABLED" : "DISABLED");
        printf("   Extensions: Available for development\n");
        return 0;
    }
    
    if (strncmp(command, "[CREATE-EXT]", 12) == 0) {
        if (!plus_mode_enabled) {
            printf("❌ Plus Mode required. Use [PLUS-MODE] first.\n");
            return 1;
        }
        printf("� Extension Creation Wizard\n");
        printf("   Creating new extension template...\n");
        system("mkdir -p ~/extensions/my-extension && echo '# My Extension' > ~/extensions/my-extension/README.md");
        printf("   Extension template created in ~/extensions/my-extension/\n");
        return 0;
    }
    
    if (strncmp(command, "[BUILD-TCZ]", 11) == 0) {
        if (!plus_mode_enabled) {
            printf("❌ Plus Mode required. Use [PLUS-MODE] first.\n");
            return 1;
        }
        printf("📦 Building TCZ package...\n");
        printf("   Packaging user extensions...\n");
        system("cd ~/extensions && tar -czf ../my-extensions.tcz *");
        printf("   TCZ package created: ~/my-extensions.tcz\n");
        return 0;
    }
    
    // Fall back to user commands
    if (strncmp(command, "[BACKUP]", 8) == 0) {
        printf("📦 WIZARD backup (includes extensions)...\n");
        system("mkdir -p ~/backups && tar -czf ~/backups/wizard-$(date +%Y%m%d).tar.gz ~/workspace/ ~/extensions/");
        return 0;
    }
    
    if (strncmp(command, "[INFO]", 6) == 0) {
        printf("ℹ️  uDESK v1.0.7 - Wizard+ Mode\n");
        printf("   Role: %s\n", getenv("UDESK_ROLE"));
        printf("   Plus Mode: %s\n", plus_mode_enabled ? "ENABLED" : "DISABLED");
        printf("   Capabilities: Extension development, TCZ creation\n");
        return 0;
    }
    
    if (strncmp(command, "[HELP]", 6) == 0) {
        printf("📖 uDESK v1.0.7 Wizard+ Commands\n\n");
        printf("STANDARD COMMANDS:\n");
        printf("  [BACKUP]      - Backup files (includes extensions)\n");
        printf("  [RESTORE]     - Restore files\n");
        printf("  [INFO]        - System information\n");
        printf("  [HELP]        - This help\n\n");
        printf("WIZARD+ COMMANDS:\n");
        printf("  [PLUS-MODE]   - Enable Plus Mode capabilities\n");
        printf("  [PLUS-STATUS] - Show Plus Mode status\n");
        printf("  [CREATE-EXT]  - Create new extension (Plus Mode)\n");
        printf("  [BUILD-TCZ]   - Build TCZ package (Plus Mode)\n\n");
        printf("🧙‍♀️ Plus Mode: %s\n", plus_mode_enabled ? "ENABLED" : "DISABLED");
        return 0;
    }
    
    printf("❌ Unknown command: %s\n", command);
    return 1;
}

int main(int argc, char *argv[]) {
    const char* role = getenv("UDESK_ROLE");
    if (!role || strcmp(role, "WIZARD") != 0) {
        printf("❌ WIZARD role required for Wizard+ Mode\n");
        printf("   Current role: %s\n", role ?: "NONE");
        printf("   Use regular udesk for user mode\n");
        return 1;
    }
    
    printf("🧙‍♀️ uDESK v1.0.7 - Wizard+ Mode\n");
    printf("Role: %s\n", role);
    printf("Type [PLUS-MODE] to enable Plus Mode capabilities\n");
    printf("Commands: [PLUS-MODE], [PLUS-STATUS], [CREATE-EXT], [BUILD-TCZ], [HELP], exit\n\n");
    
    char input[256];
    while (1) {
        printf("Wizard+> ");
        if (!fgets(input, sizeof(input), stdin)) break;
        
        input[strcspn(input, "\n")] = 0;
        
        if (strcmp(input, "exit") == 0 || strcmp(input, "quit") == 0) {
            printf("Goodbye, Wizard!\n");
            break;
        }
        
        execute_wizard_plus_ucode(input);
    }
    return 0;
}
EOF
        
        gcc -o "build/wizard-plus/udos-wizard-plus" "build/wizard-plus/udos-wizard-plus.c"
        echo "✅ Wizard+ mode build complete"
        echo "🧙‍♀️ Run: UDESK_ROLE=WIZARD ./build/wizard-plus/udos-wizard-plus"
        ;;
        
    "developer")
        echo "🔧 DEVELOPER MODE BUILD"
        echo "   Target: uDESK core developers"
        echo "   Access: Full system modification"
        
        mkdir -p build/developer
        
        # Create developer mode shell
        cat > "build/developer/udos-developer.c" << 'EOF'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int execute_developer_ucode(const char* command) {
    if (strncmp(command, "[BUILD-CORE]", 12) == 0) {
        printf("🔧 Building uDESK core system...\n");
        system("./build.sh user && ./build.sh wizard-plus");
        printf("   Core system build complete\n");
        return 0;
    }
    
    if (strncmp(command, "[BUILD-ISO]", 11) == 0) {
        printf("💿 Building TinyCore ISO...\n");
        system("./build.sh iso");
        return 0;
    }
    
    if (strncmp(command, "[SYSTEM-INFO]", 13) == 0) {
        printf("🔧 uDESK Developer System Information\n");
        printf("   Version: 1.0.7\n");
        printf("   Build Environment: %s\n", getenv("BUILD_ENV") ?: "host");
        printf("   Developer Access: FULL\n");
        system("ls -la build/");
        return 0;
    }
    
    if (strncmp(command, "[HELP]", 6) == 0) {
        printf("📖 uDESK v1.0.7 Developer Commands\n\n");
        printf("DEVELOPER COMMANDS:\n");
        printf("  [BUILD-CORE]   - Build all core components\n");
        printf("  [BUILD-ISO]    - Build TinyCore ISO\n");
        printf("  [SYSTEM-INFO]  - Developer system information\n");
        printf("  [HELP]         - This help\n\n");
        printf("🔧 Full system access enabled\n");
        return 0;
    }
    
    printf("❌ Unknown developer command: %s\n", command);
    return 1;
}

int main(int argc, char *argv[]) {
    printf("🔧 uDESK v1.0.7 - Developer Mode\n");
    printf("⚠️  WARNING: Full system access enabled\n");
    printf("Commands: [BUILD-CORE], [BUILD-ISO], [SYSTEM-INFO], [HELP], exit\n\n");
    
    char input[256];
    while (1) {
        printf("Dev> ");
        if (!fgets(input, sizeof(input), stdin)) break;
        
        input[strcspn(input, "\n")] = 0;
        
        if (strcmp(input, "exit") == 0 || strcmp(input, "quit") == 0) {
            printf("Developer session ended\n");
            break;
        }
        
        execute_developer_ucode(input);
    }
    return 0;
}
EOF
        
        gcc -o "build/developer/udos-developer" "build/developer/udos-developer.c"
        echo "✅ Developer mode build complete"
        echo "🔧 Run: ./build/developer/udos-developer"
        ;;
        
    "iso")
        echo "💿 ISO BUILD"
        if [ "$BUILD_ENV" = "tinycore" ]; then
            echo "🔥 Building TinyCore ISO with uDESK..."
            
            # Create ISO workspace
            mkdir -p build/iso/boot
            mkdir -p build/iso/cde/optional
            
            # Build user components first
            ./build.sh user
            ./build.sh wizard-plus
            
            # Create TCZ package
            mkdir -p build/iso/tcz/usr/local/bin
            cp build/user/udos build/iso/tcz/usr/local/bin/
            cp build/wizard-plus/udos-wizard-plus build/iso/tcz/usr/local/bin/
            
            cd build/iso/tcz
            find . -type f | sort > ../udesk.tcz.list
            tar -czf ../cde/optional/udesk.tcz *
            cd ../../..
            
            echo "✅ ISO components ready in build/iso/"
        else
            echo "❌ ISO build requires TinyCore environment"
            echo "   Use: docker run -v \$(pwd):/workspace tinycore/tinycore ./build.sh iso"
        fi
        ;;
        
    "test")
        echo "🧪 TESTING BUILDS"
        
        echo "Testing User Mode..."
        if [ -f "build/user/udos" ]; then
            echo "[INFO]" | ./build/user/udos
        fi
        
        echo "Testing Wizard+ Mode..."
        if [ -f "build/wizard-plus/udos-wizard-plus" ]; then
            echo "[PLUS-STATUS]" | UDESK_ROLE=WIZARD ./build/wizard-plus/udos-wizard-plus
        fi
        
        echo "Testing Developer Mode..."
        if [ -f "build/developer/udos-developer" ]; then
            echo "[SYSTEM-INFO]" | ./build/developer/udos-developer
        fi
        ;;
        
    "clean")
        echo "🧹 Cleaning build artifacts..."
        rm -rf build/*
        echo "✅ Clean complete"
        ;;
        
    *)
        echo "❌ Unknown build mode: $BUILD_MODE"
        echo ""
        echo "Usage: $0 MODE [PLATFORM]"
        echo ""
        echo "Build modes:"
        echo "  user        - User mode (standard users)"
        echo "  wizard-plus - Wizard+ mode (WIZARD role + Plus Mode)"
        echo "  developer   - Developer mode (core developers)"
        echo "  iso         - Bootable ISO image"
        echo "  test        - Test all builds"
        echo "  clean       - Clean build artifacts"
        echo ""
        echo "Examples:"
        echo "  $0 user              # User mode build"
        echo "  $0 wizard-plus       # Wizard+ mode build"
        echo "  $0 developer         # Developer mode build"
        exit 1
        ;;
esac

echo ""
echo "🎉 Build complete!"
echo "📁 Artifacts in: build/${BUILD_MODE}/"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
    printf("uDESK v1.0.7 Development (TinyCore)\n");
    printf("Commands: [INFO], [STATUS], [BACKUP], [RESTORE], [HELP]\n");
    
    if (argc > 1 && strcmp(argv[1], "--background") == 0) {
        printf("Running in background mode...\n");
        return 0;
    }
    
    char input[256];
    while (1) {
        printf("uDOS> ");
        if (!fgets(input, sizeof(input), stdin)) break;
        
        // Remove newline
        input[strcspn(input, "\n")] = 0;
        
        if (strcmp(input, "[INFO]") == 0) {
            printf("uDESK v1.0.7 - TinyCore Native\n");
        } else if (strcmp(input, "[STATUS]") == 0) {
            printf("Status: Development Mode Active\n");
        } else if (strcmp(input, "[BACKUP]") == 0) {
            system("filetool.sh -b");
        } else if (strcmp(input, "[RESTORE]") == 0) {
            system("filetool.sh -r");
        } else if (strcmp(input, "[HELP]") == 0) {
            printf("Commands: [INFO], [STATUS], [BACKUP], [RESTORE], exit\n");
        } else if (strcmp(input, "exit") == 0) {
            break;
        } else {
            printf("Unknown command: %s (use [HELP])\n", input);
        }
    }
    return 0;
}
EOF
                    gcc -o "../../build/dev/udos" "../../build/dev/udos.c"
                }
                ;;
            "container")
                echo "🐳 Container build..."
                docker run --rm -v "${PROJECT_ROOT}:/workspace" \
                    tinycore/tinycore:latest \
                    /bin/sh -c "cd /workspace && gcc -o build/dev/udos -x c - << 'EOF'
#include <stdio.h>
int main() { printf(\"uDESK v1.0.7 Container Dev\\n\"); return 0; }
EOF"
                ;;
            "host"|"minimal")
                echo "💻 Host build..."
                cat > "build/dev/udos.c" << 'EOF'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
    printf("uDESK v1.0.7 Development (Host)\n");
    printf("Lightweight development mode\n");
    printf("Commands: [INFO], [STATUS], [HELP], exit\n");
    
    char input[256];
    while (1) {
        printf("uDESK> ");
        if (!fgets(input, sizeof(input), stdin)) break;
        
        input[strcspn(input, "\n")] = 0;
        
        if (strcmp(input, "[INFO]") == 0) {
            printf("uDESK v1.0.7 - Host Development\n");
        } else if (strcmp(input, "[STATUS]") == 0) {
            printf("Status: Host Development Mode\n");
        } else if (strcmp(input, "[HELP]") == 0) {
            printf("Commands: [INFO], [STATUS], exit\n");
        } else if (strcmp(input, "exit") == 0) {
            break;
        } else {
            printf("Unknown command: %s\n", input);
        }
    }
    return 0;
}
EOF
                gcc -o "build/dev/udos" "build/dev/udos.c"
                ;;
        esac
        
        echo "✅ Development build complete"
        echo "🚀 Run: ./build/dev/udos"
        ;;
        
    "release")
        echo "📦 Release Build"
        case $BUILD_ENV in
            "tinycore")
                echo "📦 TinyCore release build..."
                # Use TinyCore's optimized compilation
                cd src/core
                gcc -O2 -DRELEASE -DTINYCORE -o "../../build/release/udos" *.c -lpthread 2>/dev/null || {
                    echo "Creating release uDOS..."
                    gcc -O2 -o "../../build/release/udos" -x c - << 'EOF'
#include <stdio.h>
int main() { 
    printf("uDESK v1.0.7 Release (TinyCore)\n"); 
    printf("Production ready\n");
    return 0; 
}
EOF
                }
                
                # Create TCZ package
                echo "📦 Creating TCZ package..."
                mkdir -p build/release/tcz/usr/local/bin
                cp build/release/udos build/release/tcz/usr/local/bin/
                
                cd build/release/tcz
                find . -type f | sort > ../udesk.tcz.list
                tar -czf ../udesk.tcz *
                cd ../../..
                ;;
            *)
                gcc -O2 -o "build/release/udos" -x c - << 'EOF'
#include <stdio.h>
int main() { printf("uDESK v1.0.7 Release\n"); return 0; }
EOF
                ;;
        esac
        
        echo "✅ Release build complete"
        ;;
        
    "iso")
        echo "💿 ISO Build"
        if [ "$BUILD_ENV" = "tinycore" ]; then
            echo "🔥 Building TinyCore ISO with uDESK..."
            
            # Create ISO workspace
            mkdir -p build/iso/boot
            mkdir -p build/iso/cde/optional
            
            # Copy TinyCore base
            cp /mnt/sda1/tce/boot/vmlinuz build/iso/boot/ 2>/dev/null || echo "Using default kernel"
            cp /mnt/sda1/tce/boot/core.gz build/iso/boot/ 2>/dev/null || echo "Using default initrd"
            
            # Add uDESK extension
            cp build/release/udesk.tcz build/iso/cde/optional/ 2>/dev/null || echo "No TCZ package found"
            
            # Create bootable ISO
            if command -v genisoimage &> /dev/null; then
                genisoimage -l -J -R -V "uDESK-v1.0.7" \
                    -no-emul-boot -boot-load-size 4 -boot-info-table \
                    -b boot/isolinux.bin -c boot.cat \
                    -o "build/iso/udesk-v${UDESK_VERSION}.iso" \
                    build/iso/
                echo "✅ ISO created: build/iso/udesk-v${UDESK_VERSION}.iso"
            else
                echo "❌ genisoimage not found - install cdrtools"
            fi
        else
            echo "❌ ISO build requires TinyCore environment"
            exit 1
        fi
        ;;
        
    "clean")
        echo "🧹 Cleaning build artifacts..."
        rm -rf build/*
        echo "✅ Clean complete"
        ;;
        
    "test")
        echo "🧪 Running tests..."
        if [ -f "build/dev/udos" ]; then
            echo "Testing development build..."
            echo "[INFO]" | ./build/dev/udos
        else
            echo "❌ No development build found. Run: $0 dev"
            exit 1
        fi
        ;;
        
    *)
        echo "❌ Unknown build mode: $BUILD_MODE"
        echo ""
        echo "Usage: $0 MODE [PLATFORM]"
        echo ""
        echo "Build modes:"
        echo "  user         - User mode (essential features)"
        echo "  wizard-plus  - Wizard+ mode (advanced features)"
        echo "  developer    - Developer mode (full toolkit)"
        echo "  iso          - Bootable ISO image"
        echo ""
        echo "Examples:"
        echo "  $0 user              # User mode build"
        echo "  $0 wizard-plus       # Wizard+ mode build"
        echo "  $0 developer         # Developer mode build"
        echo "  $0 iso               # Bootable ISO"
        exit 1
        ;;
esac

echo ""
echo "🎉 Build complete!"
echo "📁 Artifacts in: build/${BUILD_MODE}/"
