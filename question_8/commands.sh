# List directory before
ls -al testdir
## OUTPUT
# total 40
# drwxr-xr-x@ 7 soumyasarkar  staff  224 Feb  5 23:34 .
# drwxr-xr-x@ 6 soumyasarkar  staff  192 Feb  5 22:58 ..
# -rw-r--r--@ 1 soumyasarkar  staff   13 Feb  5 18:40 data.csv
# -rw-r--r--@ 1 soumyasarkar  staff   17 Feb  5 18:40 document.doc
# -rw-r--r--@ 1 soumyasarkar  staff   15 Feb  5 18:40 file1.txt
# -rw-r--r--@ 1 soumyasarkar  staff   15 Feb  5 18:40 file2.txt
# -rw-r--r--@ 1 soumyasarkar  staff   15 Feb  5 18:40 file3.txt

# Run the background move script:
./bg_move.sh testdir
## OUTPUT
# Created backup directory: testdir/backup
# Moving 'data.csv' in background - PID: 49956
# Moving 'document.doc' in background - PID: 49959
# Moving 'file1.txt' in background - PID: 49964
# Moving 'file2.txt' in background - PID: 49967
# Moving 'file3.txt' in background - PID: 49972
# 
# Total files being moved: 5
# Background process PIDs: 49956 49959 49964 49967 49972
# 
# Waiting for all background processes to complete...
# 
# ALL BACKGROUND PROCESSES COMPLETED

# Verify files were moved to backup:
ls -la testdir/backup/
## OUTPUT
# total 40
# drwxr-xr-x  7 soumyasarkar  staff  224 Feb  5 23:36 .
# drwxr-xr-x@ 3 soumyasarkar  staff   96 Feb  5 23:36 ..
# -rw-r--r--@ 1 soumyasarkar  staff   13 Feb  5 18:40 data.csv
# -rw-r--r--@ 1 soumyasarkar  staff   17 Feb  5 18:40 document.doc
# -rw-r--r--@ 1 soumyasarkar  staff   15 Feb  5 18:40 file1.txt
# -rw-r--r--@ 1 soumyasarkar  staff   15 Feb  5 18:40 file2.txt
# -rw-r--r--@ 1 soumyasarkar  staff   15 Feb  5 18:40 file3.txt
