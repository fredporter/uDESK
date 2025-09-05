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
    printf("Commands: [BUILD-CORE], [BUILD-ISO], [SYSTEM-INFO], [HELP], EXIT\n\n");
    
    char input[256];
    while (1) {
        printf("Dev> ");
        if (!fgets(input, sizeof(input), stdin)) break;
        
        input[strcspn(input, "\n")] = 0;
        
        if (strcmp(input, "exit") == 0 || strcmp(input, "quit") == 0 || 
            strcmp(input, "EXIT") == 0 || strcmp(input, "QUIT") == 0) {
            printf("Developer session ended\n");
            break;
        }
        
        execute_developer_ucode(input);
    }
    return 0;
}
