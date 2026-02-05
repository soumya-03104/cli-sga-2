
#include <stdio.h>     // standard c library
#include <stdlib.h>    // exit() - for exiting programs
#include <unistd.h>    // fork(), getpid(), getppid() - for process operations
#include <sys/types.h> // pid_t - for process ID type
#include <sys/wait.h>  // wait() - for waiting for child processes

int main() {
    int num_children = 5;  // Number of child processes to create
    pid_t child_pid;
    int status;
    int i;

    printf("Parent PID: %d\n", getpid());
    printf("Creating %d child processes...\n", num_children);
    
    for (i = 0; i < num_children; i++) {
        // fork() creates a new child process
        // Returns 0 to child, child's PID to parent, -1 on error
        child_pid = fork();  
        if (child_pid < 0) {
            printf("fork failed");
            exit(1);
        } else if (child_pid == 0) {
            // Child process code
            printf("Child %d PID: %d, working...\n", i + 1, getpid());
            
            // Let the child process take some time
            sleep(5);
            
            printf("Child %d (PID: %d) exiting\n", i + 1, getpid());
            // Child exits with status code
            exit(i + 1);
        }
        // Parent continues loop to create next child
    }

    printf("All children created. Waiting for them to complete...\n");
    
    for (i = 0; i < num_children; i++) {
        // wait() waits for ANY child process to terminate
        // Returns PID of terminated child, or -1 on error
        pid_t terminated_pid = wait(&status);
        
        if (terminated_pid > 0) {
            // Successfully cleaned up a child (removed zombie)
            printf("Cleaned up child PID: %d\n", terminated_pid);
        } else {
            printf("wait failed");
        }
    }

    printf("All children cleaned up. No zombies remain.\n");

    return 0;
}
