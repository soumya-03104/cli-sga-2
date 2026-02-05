# Compile the C program:
gcc -o signal_handling signal_handling.c

# Run the compiled program:
./signal_handling
## OUTPUT
# Parent PID: 54195
# Waiting for signals (SIGTERM in 5s, SIGINT in 10s)...
# Parent running...
# Received SIGTERM signal
# Received SIGINT signal
# Both signals received - exiting gracefully