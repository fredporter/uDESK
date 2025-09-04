#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
    printf("uDOS v1.0.7 Development (Host)\n");
    printf("Lightweight development mode\n");
    printf("Commands: [INFO], [STATUS], [HELP], exit\n");
    
    char input[256];
    while (1) {
        printf("uDOS> ");
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
