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
    printf("Commands: [PLUS-MODE], [PLUS-STATUS], [CREATE-EXT], [BUILD-TCZ], [HELP], EXIT\n\n");
    
    char input[256];
    while (1) {
        printf("Wizard+> ");
        if (!fgets(input, sizeof(input), stdin)) break;
        
        input[strcspn(input, "\n")] = 0;
        
        if (strcmp(input, "exit") == 0 || strcmp(input, "quit") == 0 || 
            strcmp(input, "EXIT") == 0 || strcmp(input, "QUIT") == 0) {
            printf("Goodbye, Wizard!\n");
            break;
        }
        
        execute_wizard_plus_ucode(input);
    }
    return 0;
}
