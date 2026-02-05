INPUT_FILE="input.txt"


# - sort | uniq : Sort and remove consecutive duplicates
# - wc -l : Count lines
# - wc -c : Count characters
# - awk '{ print length, $0 }' : Print word length and word
# - sort -rn : Sort numerically in reverse (for longest)
# - sort -n : Sort numerically (for shortest)

# Extract all words:
# tr -cs 'A-Za-z' '\n' : Replace non-alphabetic chars with newlines, squeeze repeats
# This converts text to one word per line
# grep -v '^$' : Remove empty lines

# Get all words (one per line, lowercase for consistency in counting)
all_words=$(tr -cs 'A-Za-z' '\n' < "$INPUT_FILE" | grep -v '^$')

# Check if file has any words
if [ -z "$all_words" ]; then
    echo "Error: No words found in the file!"
    exit 1
fi

# Count total unique words
unique_count=$(echo "$all_words" | tr '[:upper:]' '[:lower:]' | sort | uniq | wc -l | xargs)

# Find longest word
# Sort by length (awk prints length first, then word)
# Sort numerically in reverse, take first word
longest_word=$(echo "$all_words" | awk '{ print length, $0 }' | sort -rn | head -1 | cut -d' ' -f2-)
longest_length=${#longest_word}

# Find shortest word
# Sort by length numerically, take first word
shortest_word=$(echo "$all_words" | awk '{ print length, $0 }' | sort -n | head -1 | cut -d' ' -f2-)
shortest_length=${#shortest_word}

# Calculate average word length
# Sum all word lengths, divide by word count
total_words=$(echo "$all_words" | wc -l | xargs)
total_chars=$(echo "$all_words" | tr -d '\n' | wc -c | xargs)

# Calculate average using awk for floating point
average_length=$(echo "$total_chars $total_words" | awk '{ printf "%.2f", $1/$2 }')

echo ""
echo "LONGEST WORD:"
echo "  Word:   $longest_word"
echo "  Length: $longest_length characters"
echo ""
echo "SHORTEST WORD:"
echo "  Word:   $shortest_word"
echo "  Length: $shortest_length characters"
echo ""
echo "AVERAGE WORD LENGTH:"
echo "  $average_length characters"
echo ""
echo "TOTAL UNIQUE WORDS:"
echo "  $unique_count"
echo ""
echo "Total words (including duplicates): $total_words"
echo "Total characters (in words):        $total_chars"
echo ""

exit 0
