#ifndef UDOS_CORE_H
#define UDOS_CORE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <time.h>

// Core uDOS commands available to all roles
// These provide essential functionality regardless of user role

void show_udos_banner(const char* mode, const char* version) {
    printf("\n");
    printf("    ██╗   ██╗██████╗ ███████╗███████╗██╗  ██╗\n");
    printf("    ██║   ██║██╔══██╗██╔════╝██╔════╝██║ ██╔╝\n");
    printf("    ██║   ██║██║  ██║█████╗  ███████╗█████╔╝ \n");
    printf("    ██║   ██║██║  ██║██╔══╝  ╚════██║██╔═██╗ \n");
    printf("    ╚██████╔╝██████╔╝███████╗███████║██║  ██╗\n");
    printf("     ╚═════╝ ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝\n");
    printf("            %s v%s\n\n", mode, version);
}

void handle_core_info() {
    printf("📋 uDESK System Information\n");
    printf("   Version: 1.0.7.2\n");
    printf("   Mode: Universal Desktop OS\n");
    
    char* role = getenv("UDESK_ROLE");
    printf("   Role: %s\n", role ? role : "GHOST");
    
    char* theme = getenv("UDESK_THEME");
    printf("   Theme: %s\n", theme ? theme : "POLAROID");
    
    char cwd[1024];
    if (getcwd(cwd, sizeof(cwd)) != NULL) {
        printf("   Directory: %s\n", cwd);
    }
    
    time_t now = time(0);
    printf("   Time: %s", ctime(&now));
}

void handle_core_config() {
    printf("📋 Configuration:\n");
    
    char* home = getenv("HOME");
    if (home) {
        char config_path[1024];
        snprintf(config_path, sizeof(config_path), "%s/.udesk/config", home);
        
        FILE* file = fopen(config_path, "r");
        if (file) {
            printf("   Config file: %s\n", config_path);
            char line[256];
            while (fgets(line, sizeof(line), file)) {
                printf("   %s", line);
            }
            fclose(file);
        } else {
            printf("   No config file found\n");
            printf("   Default config will be created on first use\n");
        }
    }
}

void handle_core_backup() {
    printf("💾 Backup System\n");
    printf("   Creating backup of user workspace...\n");
    
    char* home = getenv("HOME");
    if (home) {
        char backup_dir[1024];
        snprintf(backup_dir, sizeof(backup_dir), "%s/uDESK/uMEMORY/.local/backups", home);
        
        // Create backup directory if it doesn't exist
        char mkdir_cmd[1024];
        snprintf(mkdir_cmd, sizeof(mkdir_cmd), "mkdir -p %s", backup_dir);
        system(mkdir_cmd);
        
        // Create timestamped backup
        time_t now = time(0);
        struct tm* tm_info = localtime(&now);
        char timestamp[64];
        strftime(timestamp, sizeof(timestamp), "%Y%m%d-%H%M%S", tm_info);
        
        char backup_cmd[2048];
        snprintf(backup_cmd, sizeof(backup_cmd), 
                "cd %s/uDESK && tar -czf uMEMORY/.local/backups/backup-%s.tar.gz uMEMORY/sandbox/ 2>/dev/null", 
                home, timestamp);
        
        if (system(backup_cmd) == 0) {
            printf("   ✅ Backup created: backup-%s.tar.gz\n", timestamp);
            printf("   📂 Location: ~/uDESK/uMEMORY/.local/backups/\n");
        } else {
            printf("   ⚠️  Backup failed - check permissions\n");
        }
    }
}

void handle_core_restore() {
    printf("🔄 Restore System\n");
    
    char* home = getenv("HOME");
    if (home) {
        char backup_dir[1024];
        snprintf(backup_dir, sizeof(backup_dir), "%s/uDESK/uMEMORY/.local/backups", home);
        
        printf("   Available backups in %s:\n", backup_dir);
        
        char list_cmd[1024];
        snprintf(list_cmd, sizeof(list_cmd), "ls -la %s/*.tar.gz 2>/dev/null | head -10", backup_dir);
        
        if (system(list_cmd) != 0) {
            printf("   No backups found\n");
            printf("   Use BACKUP command to create your first backup\n");
        } else {
            printf("\n   To restore: tar -xzf backup-TIMESTAMP.tar.gz\n");
        }
    }
}

void handle_core_help() {
    printf("📖 uDESK Core Commands\n\n");
    printf("CORE uCODE COMMANDS (Available to all roles):\n");
    printf("  BACKUP   - Backup your files and config\n");
    printf("  RESTORE  - Show available backups\n");
    printf("  INFO     - System information\n");
    printf("  CONFIG   - Show configuration\n");
    printf("  HELP     - This help\n\n");
    printf("SHELL COMMANDS:\n");
    printf("  EXIT, QUIT - Leave uDESK\n");
    printf("  ROLE       - Show role information\n");
    printf("  THEME      - Show theme settings\n\n");
}

// Process core commands that are available to all roles
int process_core_command(const char* input) {
    // Remove newlines and normalize input
    char command[256];
    strncpy(command, input, sizeof(command) - 1);
    command[sizeof(command) - 1] = '\0';
    
    // Remove trailing newline
    char* newline = strchr(command, '\n');
    if (newline) *newline = '\0';
    
    // Convert to uppercase for consistent matching
    for (int i = 0; command[i]; i++) {
        if (command[i] >= 'a' && command[i] <= 'z') {
            command[i] = command[i] - 'a' + 'A';
        }
    }
    
    // Core commands available to all roles
    if (strcmp(command, "INFO") == 0 || strcmp(command, "[INFO]") == 0) {
        handle_core_info();
        return 1;
    }
    
    if (strcmp(command, "CONFIG") == 0 || strcmp(command, "[CONFIG]") == 0) {
        handle_core_config();
        return 1;
    }
    
    if (strcmp(command, "BACKUP") == 0 || strcmp(command, "[BACKUP]") == 0) {
        handle_core_backup();
        return 1;
    }
    
    if (strcmp(command, "RESTORE") == 0 || strcmp(command, "[RESTORE]") == 0) {
        handle_core_restore();
        return 1;
    }
    
    if (strcmp(command, "HELP") == 0 || strcmp(command, "[HELP]") == 0) {
        handle_core_help();
        return 1;
    }
    
    if (strcmp(command, "EXIT") == 0 || strcmp(command, "QUIT") == 0) {
        printf("👋 Goodbye!\n");
        exit(0);
    }
    
    // Command not handled by core system
    return 0;
}

#endif // UDOS_CORE_H
