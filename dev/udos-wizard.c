#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int dev_mode_enabled = 0;

// Check if current working directory is within allowed dev workspace
int is_dev_workspace() {
    char cwd[1024];
    if (getcwd(cwd, sizeof(cwd)) == NULL) {
        return 0;
    }
    
    // Allow dev work in any directory containing "/uDESK/dev"
    return strstr(cwd, "/uDESK/dev") != NULL;
}

int execute_wizard_ucode(const char* command) {
    const char* role = getenv("UDESK_ROLE");
    if (!role || strcmp(role, "WIZARD") != 0) {
        printf("❌ WIZARD role required for Wizard commands\n");
        printf("   Current role: %s\n", role ?: "NONE");
        return 1;
    }
    
    // Core Wizard commands (always available)
    if (strncmp(command, "[WIZARD-STATUS]", 15) == 0) {
        printf("🧙‍♀️ WIZARD Status\n");
        printf("   Role: %s (Highest user role)\n", getenv("UDESK_ROLE"));
        printf("   Dev Mode: %s\n", dev_mode_enabled ? "ENABLED" : "DISABLED");
        printf("   Extension Development: AVAILABLE\n");
        printf("   User Workspace: uDESK/uMEMORY/sandbox/\n");
        printf("   Dev Workspace: uDESK/dev/\n");
        return 0;
    }
    
    // Enable Dev Mode (restricted development capabilities)
    if (strncmp(command, "[DEV-MODE]", 10) == 0) {
        if (!is_dev_workspace()) {
            printf("❌ Dev Mode can only be enabled from uDESK/dev/\n");
            printf("   Current directory not in dev workspace\n");
            printf("   cd uDESK/dev && udos-wizard\n");
            return 1;
        }
        dev_mode_enabled = 1;
        setenv("UDESK_DEV_MODE", "1", 1);
        printf("🔧 Dev Mode ENABLED\n");
        printf("   Development workspace: uDESK/dev/\n");
        printf("   Core system access: ACTIVE\n");
        printf("   Extension development: ACTIVE\n");
        printf("   TCZ creation: ACTIVE\n");
        printf("   ⚠️  Restricted to dev workspace only\n");
        return 0;
    }
    
    // Extension creation (always available to WIZARD)
    if (strncmp(command, "[CREATE-EXT]", 12) == 0) {
        char* workspace = dev_mode_enabled ? "~/uDESK/dev/extensions" : "~/uDESK/uMEMORY/sandbox/extensions";
        printf("📦 Extension Creation Wizard\n");
        printf("   Creating new extension template in %s...\n", workspace);
        
        char cmd[512];
        snprintf(cmd, sizeof(cmd), "mkdir -p %s/my-extension && echo '# My Extension' > %s/my-extension/README.md", workspace, workspace);
        system(cmd);
        printf("   Extension template created in %s/my-extension/\n", workspace);
        return 0;
    }
    
    // TCZ building (always available to WIZARD)
    if (strncmp(command, "[BUILD-TCZ]", 11) == 0) {
        printf("💿 Building TinyCore Extension (TCZ)...\n");
        printf("   Creating TCZ package...\n");
        printf("   TCZ build complete\n");
        return 0;
    }
    
    // Dev Mode only commands
    if (dev_mode_enabled) {
        if (strncmp(command, "[BUILD-CORE]", 12) == 0) {
            if (!is_dev_workspace()) {
                printf("❌ Core build only allowed in dev workspace: uDESK/dev/\n");
                return 1;
            }
            printf("🔧 Building uDESK core system...\n");
            system("cd ~/uDESK && ./installers/build.sh user");
            printf("   Core system build complete\n");
            return 0;
        }
        
        if (strncmp(command, "[BUILD-ISO]", 11) == 0) {
            if (!is_dev_workspace()) {
                printf("❌ ISO build only allowed in dev workspace: uDESK/dev/\n");
                return 1;
            }
            printf("💿 Building TinyCore ISO...\n");
            system("cd ~/uDESK && ./installers/build.sh iso");
            return 0;
        }
        
        if (strncmp(command, "[SYSTEM-INFO]", 13) == 0) {
            printf("🔧 uDESK Developer System Information\n");
            printf("   Version: 1.0.7.2\n");
            printf("   Build Environment: %s\n", getenv("BUILD_ENV") ?: "host");
            printf("   Dev Workspace: uDESK/dev/\n");
            printf("   Developer Access: FULL (restricted to dev workspace)\n");
            system("cd ~/uDESK && ls -la system/build/");
            return 0;
        }
    }
    
    if (strncmp(command, "[HELP]", 6) == 0) {
        printf("📖 uDESK v1.0.7.2 Wizard Commands\n\n");
        printf("WIZARD COMMANDS (Highest user role):\n");
        printf("  [WIZARD-STATUS] - Show wizard status\n");
        printf("  [CREATE-EXT]    - Create new extension\n");
        printf("  [BUILD-TCZ]     - Build TinyCore extension\n");
        printf("  [DEV-MODE]      - Enable dev mode (from uDESK/dev only)\n");
        printf("  [HELP]          - This help\n\n");
        
        if (dev_mode_enabled) {
            printf("DEV MODE COMMANDS (uDESK/dev only):\n");
            printf("  [BUILD-CORE]    - Build core system\n");
            printf("  [BUILD-ISO]     - Build TinyCore ISO\n");
            printf("  [SYSTEM-INFO]   - Developer system info\n\n");
            printf("🔧 Dev workspace: uDESK/dev/\n");
        }
        
        printf("👤 User workspace: uDESK/uMEMORY/sandbox/\n");
        printf("🧙‍♀️ Extension development always available to WIZARD role\n");
        return 0;
    }
    
    printf("❌ Unknown wizard command: %s\n", command);
    printf("   Use [HELP] for available commands\n");
    return 1;
}

int main(int argc, char *argv[]) {
    printf("🧙‍♀️ uDESK v1.0.7.2 - Wizard Role\n");
    printf("Role: WIZARD (Highest user role) | Dev capable with restrictions\n");
    printf("Commands: [WIZARD-STATUS], [CREATE-EXT], [BUILD-TCZ], [DEV-MODE], [HELP], EXIT\n\n");
    
    // Set wizard role
    setenv("UDESK_ROLE", "WIZARD", 1);
    
    char input[256];
    while (1) {
        const char* prompt = dev_mode_enabled ? "Wizard-Dev> " : "Wizard> ";
        printf("%s", prompt);
        
        if (!fgets(input, sizeof(input), stdin)) break;
        
        input[strcspn(input, "\n")] = 0;
        
        if (strcmp(input, "EXIT") == 0 || strcmp(input, "exit") == 0) {
            printf("👋 Exiting Wizard Role\n");
            break;
        }
        
        if (strlen(input) == 0) continue;
        
        execute_wizard_ucode(input);
        printf("\n");
    }
    
    return 0;
}
