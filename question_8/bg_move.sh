# Check if directory argument is provided
# $# : number of arguments
if [ $# -ne 1 ]; then
    echo "Error: Please provide a directory path!"
    echo "Usage: $0 <directory_path>"
    exit 1
fi

SOURCE_DIR="$1"

# Check if directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Directory '$SOURCE_DIR' does not exist!"
    exit 1
fi

# Create backup directory inside the source directory
BACKUP_DIR="$SOURCE_DIR/backup"

# Create backup directory if it doesn't exist
# -p : checks the path and creates it if it doesn't exist
mkdir -p "$BACKUP_DIR"
echo "Created backup directory: $BACKUP_DIR"


# Array to store PIDs of background processes
declare -a pids

# Counter for files moved
file_count=0

# Loop through files in the source directory
for file in "$SOURCE_DIR"/*; do
    # Skip if it's a directory (including backup)
    # -d : check if it's a directory
    [ -d "$file" ] && continue

    # Skip if it's not a regular file
    # -f : check if it's a regular file
    [ ! -f "$file" ] && continue

    # Get just the filename
    # basename : gives us just the filename
    filename=$(basename "$file")

    # Move file in background
    # Using subshell with mv command
    (
        mv "$file" "$BACKUP_DIR/"
        # Small delay to simulate work and allow PID capture
        sleep 0.1
    ) &

    # Capture the PID of the background process
    bg_pid=$!

    echo "Moving '$filename' in background - PID: $bg_pid"

    # Store PID in array
    pids+=($bg_pid)

    ((file_count++))
done

if [ $file_count -eq 0 ]; then
    echo "No files found to move in '$SOURCE_DIR'"
    exit 0
fi

echo ""
echo "Total files being moved: $file_count"
echo "Background process PIDs: ${pids[*]}"

echo ""
echo "Waiting for all background processes to complete..."

# Wait for all background processes to finish
wait

echo ""
echo "   ALL BACKGROUND PROCESSES COMPLETED"

exit 0
