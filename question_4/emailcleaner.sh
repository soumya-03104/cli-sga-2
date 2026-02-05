INPUT_FILE="emails.txt"
VALID_FILE="valid.txt"
INVALID_FILE="invalid.txt"

# Clear output files if they exist
echo "" > "$VALID_FILE"
echo "" > "$INVALID_FILE"

# Regular expression for valid email
# Format: letters_and_digits @ letters . com
# ^[a-zA-Z0-9]+@[a-zA-Z]+\.com$
VALID_PATTERN='^[a-zA-Z0-9]+@[a-zA-Z]+\.com$'

# Process each line in the input file
total_emails=0
valid_count=0
invalid_count=0

while IFS= read -r email; do
    ((total_emails++))

    # Check if email matches valid pattern
    # -qE : Extended regex matching
    if echo "$email" | grep -qE "$VALID_PATTERN"; then
        echo "$email" >> "$VALID_FILE"
        ((valid_count++))
    else
        echo "$email" >> "$INVALID_FILE"
        ((invalid_count++))
    fi

done < "$INPUT_FILE"

# Remove duplicates from valid.txt
# sort : Sort lines alphabetically
# uniq : Remove duplicate consecutive lines
# move the non unique valid file to .old file
if [ -s "$VALID_FILE" ]; then
    sort "$VALID_FILE" | uniq > "${VALID_FILE}.tmp"
    mv "${VALID_FILE}" "$VALID_FILE.old"
    mv "${VALID_FILE}.tmp" "$VALID_FILE"
fi

# Count unique valid emails
# wc -l : count lines
unique_valid=$(cat "$VALID_FILE" | wc -l)
duplicates_removed=$((valid_count - unique_valid))


echo "Total emails processed: $total_emails"
echo "Valid emails found:     $valid_count"
echo "Duplicates removed:     $duplicates_removed"
echo "Unique valid emails:    $unique_valid"
echo "Invalid emails found:   $invalid_count"


echo ""
echo "Valid Emails"
if [ -s "$VALID_FILE" ]; then
    cat "$VALID_FILE"
else
    echo "(No valid emails found)"
fi

echo ""
echo "Invalid Emails"
if [ -s "$INVALID_FILE" ]; then
    cat "$INVALID_FILE"
else
    echo "(No invalid emails found)"
fi

exit 0
