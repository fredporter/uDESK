#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <ctype.h>

void show_welcome_art() {
    const char* theme = getenv("UDESK_COLORS");
    const char* role = getenv("UDESK_ROLE");
    
    printf("\n");
    if (theme && strcmp(theme, "retro") == 0) {
        printf("    ┌─────────────────────────────────────┐\n");
        printf("    │         uDESK v1.0.7 USER          │\n");
        printf("    │    Universal Desktop OS             │\n");
        printf("    └─────────────────────────────────────┘\n");
    } else {
        // Polaroid palette colors
        printf("    \033[96m██╗   ██╗██████╗ ███████╗███████╗██╗  ██╗\033[0m\n");
        printf("    \033[95m██║   ██║██╔══██╗██╔════╝██╔════╝██║ ██╔╝\033[0m\n");
        printf("    \033[93m██║   ██║██║  ██║█████╗  ███████╗█████╔╝ \033[0m\n");
        printf("    \033[92m██║   ██║██║  ██║██╔══╝  ╚════██║██╔═██╗ \033[0m\n");
        printf("    \033[94m╚██████╔╝██████╔╝███████╗███████║██║  ██╗\033[0m\n");
        printf("    \033[91m ╚═════╝ ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝\033[0m\n");
        printf("            \033[97mUSER MODE v1.0.7\033[0m\n");
    }
    
    if (role) {
        if (strcmp(role, "GHOST") == 0) {
            printf("    👻 GHOST - System Monitor\n");
        } else if (strcmp(role, "TOMB") == 0) {
            printf("    ⚰️ TOMB - Archive Manager\n");
        } else if (strcmp(role, "DRONE") == 0) {
            printf("    🤖 DRONE - Automation Assistant\n");
        } else if (strcmp(role, "CRYPT") == 0) {
            printf("    🔐 CRYPT - Security Specialist\n");
        } else if (strcmp(role, "IMP") == 0) {
            printf("    😈 IMP - Script Master\n");
        } else if (strcmp(role, "KNIGHT") == 0) {
            printf("    ⚔️ KNIGHT - System Administrator\n");
        } else if (strcmp(role, "SORCERER") == 0) {
            printf("    🔮 SORCERER - Smart Features\n");
        } else if (strcmp(role, "WIZARD") == 0) {
            printf("    🧙‍♂️ WIZARD - Complete Access\n");
        }
    }
    printf("\n");
}

const char* get_prompt() {
    const char* theme = getenv("UDESK_COLORS");
    const char* ps1 = getenv("UDESK_PS1");
    if (ps1) return ps1;
    
    if (theme && strcmp(theme, "retro") == 0) {
        return "[uDESK:USER]$ ";
    } else if (theme && strcmp(theme, "dark") == 0) {
        return "🌙 uDESK> ";
    } else if (theme && strcmp(theme, "light") == 0) {
        return "☀️ uDESK> ";
    }
    return "uDESK> ";
}

int validate_user_path(const char* path) {
    char* home = getenv("HOME");
    if (home && strncmp(path, home, strlen(home)) == 0) return 1;
    if (strncmp(path, "/workspace/user/", 16) == 0) return 1;
    printf("❌ Access denied: %s (user workspace only)\n", path);
    return 0;
}

int execute_user_ucode(const char* command) {
    // Convert input to uppercase for processing  
    char upper_cmd[256];
    char original_cmd[256];
    strncpy(original_cmd, command, 255);
    original_cmd[255] = '\0';
    
    // Handle both [COMMAND] shortcode and direct command formats
    const char* clean_cmd = command;
    if (command[0] == '[' && command[strlen(command)-1] == ']') {
        // Remove brackets for shortcode format
        strncpy(upper_cmd, command + 1, strlen(command) - 2);
        upper_cmd[strlen(command) - 2] = '\0';
        clean_cmd = upper_cmd;
    } else {
        strncpy(upper_cmd, command, 255);
        upper_cmd[255] = '\0';
        clean_cmd = upper_cmd;
    }
    
    // Convert to uppercase for consistent processing
    for (int i = 0; clean_cmd[i] && i < 255; i++) {
        upper_cmd[i] = toupper(clean_cmd[i]);
    }
    upper_cmd[strlen(clean_cmd)] = '\0';
    
    if (strncmp(upper_cmd, "BACKUP", 6) == 0) {
        printf("📦 Creating user backup...\n");
        system("mkdir -p ~/.udesk/backups && tar -czf ~/.udesk/backups/user-$(date +%Y%m%d-%H%M).tar.gz ~/workspace/ ~/.udesk/ 2>/dev/null");
        printf("✅ Backup saved to ~/.udesk/backups/\n");
        return 0;
    }
    if (strncmp(upper_cmd, "RESTORE", 7) == 0) {
        printf("📥 Available backups:\n");
        system("ls -la ~/.udesk/backups/user-*.tar.gz 2>/dev/null | head -5 || echo '   No backups found'");
        printf("💡 To restore: tar -xzf ~/.udesk/backups/user-YYYYMMDD-HHMM.tar.gz -C ~/\n");
        return 0;
    }
    if (strncmp(upper_cmd, "INFO", 4) == 0) {
        printf("ℹ️  uDESK v1.0.7 - User Mode\n");
        printf("   Role: %s\n", getenv("UDESK_ROLE") ?: "GHOST");
        
        const char* theme = getenv("UDESK_COLORS") ?: "default";
        if (strcmp(theme, "default") == 0) {
            printf("   Theme: POLAROID (default)\n");
        } else {
            printf("   Theme: %s\n", theme);
        }
        
        printf("   Workspace: uMEMORY/\n");
        printf("   Config: .udesk/\n");
        printf("   Home: uDESK/\n");
        printf("   Platform: %s\n", getenv("UDESK_MODE") ?: "user");
        return 0;
    }
    if (strncmp(upper_cmd, "HELP", 4) == 0) {
        printf("📖 uDESK v1.0.7 User Commands\n\n");
        printf("USER uCODE COMMANDS:\n");
        printf("  BACKUP   - Backup your files and config\n");
        printf("  RESTORE  - Show available backups\n");
        printf("  INFO     - System information\n");
        printf("  HELP     - This help\n\n");
        printf("ROLE PROGRESSION:\n");
        printf("  👻 GHOST → ⚰️ TOMB → 🤖 DRONE → 🔐 CRYPT → 😈 IMP → ⚔️ KNIGHT → 🔮 SORCERER → 🧙‍♂️ WIZARD\n\n");
        printf("SHELL COMMANDS:\n");
        printf("  EXIT, QUIT - Leave uDESK\n");
        printf("  CONFIG     - Show configuration\n");
        printf("  ROLE       - Show role information\n");
        printf("  THEME      - Show theme settings\n");
        return 0;
    }
    if (strncmp(upper_cmd, "CONFIG", 6) == 0) {
        printf("📋 Configuration:\n");
        system("cat ~/.udesk/config 2>/dev/null || echo '   No config file found'");
        return 0;
    }
    if (strncmp(upper_cmd, "ROLE", 4) == 0) {
        const char* role = getenv("UDESK_ROLE") ?: "GHOST";
        printf("👤 Current role: %s\n", role);
        if (strcmp(role, "GHOST") == 0) {
            printf("   👻 GHOST - Basic system monitoring\n");
            printf("   Next: ⚰️ TOMB (Archive management)\n");
        } else if (strcmp(role, "WIZARD") == 0) {
            printf("   🧙‍♂️ WIZARD - Complete system access\n");
            printf("   💡 Try: ./build.sh wizard-plus\n");
        }
        return 0;
    }
    if (strncmp(upper_cmd, "THEME", 5) == 0) {
        const char* theme = getenv("UDESK_COLORS") ?: "default";
        if (strcmp(theme, "default") == 0) {
            printf("🎨 Theme: POLAROID (default)\n");
        } else {
            printf("🎨 Theme: %s\n", theme);
        }
        printf("   Prompt: %s\n", get_prompt());
        printf("   Available: POLAROID (default), retro, dark, light\n");
        return 0;
    }
    
    printf("❌ Unknown command: %s\n", original_cmd);
    printf("   Use HELP for available commands\n");
    return 1;
}

int main(int argc, char *argv[]) {
    const char* role = getenv("UDESK_ROLE") ?: "GHOST";
    const char* theme = getenv("UDESK_COLORS") ?: "default";
    
    show_welcome_art();
    
    // Display theme in POLAROID format if default
    if (strcmp(theme, "default") == 0) {
        printf("Role: %s | Theme: POLAROID (default)\n", role);
    } else {
        printf("Role: %s | Theme: %s\n", role, theme);
    }
    
    printf("Commands: BACKUP, RESTORE, INFO, HELP, CONFIG, EXIT\n");
    printf("Format: Direct commands or [SHORTCODE] syntax\n\n");
    
    char input[256];
    while (1) {
        printf("%s", get_prompt());
        if (!fgets(input, sizeof(input), stdin)) break;
        
        input[strcspn(input, "\n")] = 0;
        
        if (strcmp(input, "exit") == 0 || strcmp(input, "quit") == 0 || 
            strcmp(input, "EXIT") == 0 || strcmp(input, "QUIT") == 0) {
            printf("👋 Goodbye! Thanks for using uDESK v1.0.7\n");
            break;
        }
        
        execute_user_ucode(input);
    }
    return 0;
}
