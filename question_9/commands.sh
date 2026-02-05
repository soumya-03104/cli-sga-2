# Compile the C program:
gcc -o zombie_prevention zombie_prevention.c

# Run the compiled program:
./zombie_prevention
## OUTPUT
# Parent PID: 59833
# Creating 5 child processes...
# Child 1 PID: 59834, working...
# Child 2 PID: 59835, working...
# Child 3 PID: 59836, working...
# Child 4 PID: 59837, working...
# All children created. Waiting for them to complete...
# Child 5 PID: 59838, working...
# Child 1 (PID: 59834) exiting
# Child 2 (PID: 59835) exiting
# Child 4 (PID: 59837) exiting
# Cleaned up child PID: 59837
# Cleaned up child PID: 59835
# Cleaned up child PID: 59834
# Child 3 (PID: 59836) exiting
# Cleaned up child PID: 59836
# Child 5 (PID: 59838) exiting
# Cleaned up child PID: 59838
# All children cleaned up. No zombies remain.