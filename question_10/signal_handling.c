
#include <stdio.h>     // standard c library
#include <stdlib.h>    // exit() - for exiting programs with status code
#include <unistd.h>    // fork(), sleep(), getpid() - for process operations
#include <signal.h>    // sigaction(), SIGTERM, SIGINT - for signal handling
#include <sys/types.h> // pid_t - for process ID type
#include <sys/wait.h>  // waitpid() - for waiting for child processes

int signals_received = 0;

// Handler for SIGTERM signal (termination request)
void handle_sigterm(int signum) {
    signals_received++;
    printf("Received SIGTERM signal\n");
}

// Handler for SIGINT signal (interrupt, like Ctrl+C)
void handle_sigint(int signum) {
    signals_received++;
    printf("Received SIGINT signal\n");
}

int main() {
    pid_t parent_pid = getpid();  // Get parent process ID
    pid_t child1_pid, child2_pid;
    
    // signal() for signal handling
    // It tells the kernel to call our handler function when a signal arrives
    // handle termination request
    signal(SIGTERM, handle_sigterm);
    // handles interrupt
    signal(SIGINT, handle_sigint);
    

    printf("Parent PID: %d\n", parent_pid);
    printf("Waiting for signals (SIGTERM in 5s, SIGINT in 10s)...\n");
    
    // fork() creates a copy of the current process
    // Returns 0 in child, child's PID in parent, -1 on error
    // CHILD 1
    child1_pid = fork();  
                           
    if (child1_pid < 0) {
        printf("fork child1 failed");
        exit(1);
    } else if (child1_pid == 0) {
        // Child 1 process code
        sleep(5);  // Wait 5 seconds
        
        // kill() sends a signal to a process
        kill(parent_pid, SIGTERM);
        // Child 1 exits after sending signal
        exit(0);
    }

    // fork() creates a copy of the current process
    // Returns 0 in child, child's PID in parent, -1 on error
    // CHILD 2
    child2_pid = fork();
    if (child2_pid < 0) {
        printf("fork child2 failed");
        exit(1);
    } else if (child2_pid == 0) {
        // Child 2 process code
        sleep(10);  // Wait 10 seconds
        
        // kill() sends a signal to a process
        // SIGINT (2) = interrupt, can be caught (same as Ctrl+C)
        kill(parent_pid, SIGINT);
        exit(0);  // Child 2 exits after sending signal
    }
    
    printf("Parent running...\n");
    
    // Infinite loop - runs until both signals received
    while (1) {
        // Check if both signals have been received
        if (signals_received >= 2) {
            printf("Both signals received - exiting gracefully\n");
            break;  // Exit the loop
        }
        
        sleep(1);  // Wait 1 second before checking again
    }
    
    // waitpid() waits for a child process to finish
    // This prevents zombie processes 
    int status;
    waitpid(child1_pid, &status, 0);
    waitpid(child2_pid, &status, 0);

    return 0;
}
