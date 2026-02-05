# Check if exactly one argument is provided
# ""
if [ $# -ne 1 ]; then
    echo "Error: Invalid argument count!"
    exit 1
fi

# Store the argument
path="$1"

# Check if the path exists
if [ ! -e "$path" ]; then
    echo "Error: Path '$path' does not exist!"
    exit 1
fi

# Check if the argument is a file
# -f : regular file
if [ -f "$path" ]; then

    # Get line, word, and character counts using wc
    # -l : line count
    # -w : word count
    # -c : character count
    # < : input redirection
    lines=$(wc -l < "$path")
    words=$(wc -w < "$path")
    chars=$(wc -c < "$path")

    echo "Number of lines:      $lines"
    echo "Number of words:      $words"
    echo "Number of characters: $chars"

# Check if the argument is a directory
# -d : directory
elif [ -d "$path" ]; then

    # Count total number of files (not directories) in the directory
    # -maxdepth 1 : only look in the immediate directory
    # -type f : only count regular files
    total_files=$(find "$path" -maxdepth 1 -type f | wc -l)

    # Count number of .txt files in the directory
    # -name "*.txt" : filter for .txt files - by pattern
    txt_files=$(find "$path" -maxdepth 1 -type f -name "*.txt" | wc -l)

    echo "Total number of files: $total_files"
    echo "Number of .txt files:  $txt_files"

else
    echo "Error: '$path' is neither a regular file nor a directory!"
    exit 1
fi

exit 0
