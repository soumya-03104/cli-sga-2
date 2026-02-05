MARKS_FILE="marks.txt"
PASSING_MARKS=33

# Output files to store results
FAILED_ONE_FILE="failed_one.txt"
PASSED_ALL_FILE="passed_all.txt"

# Clear output files if they exist
echo "" > "$FAILED_ONE_FILE"
echo "" > "$PASSED_ALL_FILE"

# Initialize counters
failed_one_count=0
passed_all_count=0

# Read the file line by line
# IFS=',' sets the field separator to comma
# read -r reads line without interpreting backslashes
# Variables rollno, name, marks1, marks2, marks3 are assigned from each field
while IFS=',' read -r rollno name marks1 marks2 marks3; do
    # Skip empty lines
    [ -z "$rollno" ] && continue

    # Trim whitespace from fields
    rollno=$(echo "$rollno" | xargs)
    name=$(echo "$name" | xargs)
    marks1=$(echo "$marks1" | xargs)
    marks2=$(echo "$marks2" | xargs)
    marks3=$(echo "$marks3" | xargs)

    # Skip header line if present
    if [ "$rollno" == "RollNo" ]; then
        continue
    fi

    # Count failures for this student
    fail_count=0

    # Check Marks1 (Subject 1)
    if [ "$marks1" -lt "$PASSING_MARKS" ]; then
        ((fail_count++))
    fi

    # Check Marks2 (Subject 2)
    if [ "$marks2" -lt "$PASSING_MARKS" ]; then
        ((fail_count++))
    fi

    # Check Marks3 (Subject 3)
    if [ "$marks3" -lt "$PASSING_MARKS" ]; then
        ((fail_count++))
    fi

    # Categorize students based on failures
    # >> appends to a file
    if [ "$fail_count" -eq 1 ]; then
        ((failed_one_count++))
        echo "$rollno | $name" >> "$FAILED_ONE_FILE"
    elif [ "$fail_count" -eq 0 ]; then
        ((passed_all_count++))
        echo "$rollno | $name" >> "$PASSED_ALL_FILE"
    fi

done < "$MARKS_FILE"

# Display students who failed in exactly ONE subject
echo ""
echo "STUDENTS WHO FAILED IN EXACTLY ONE SUBJECT"
if [ "$failed_one_count" -eq 0 ]; then
    echo "No students failed in exactly one subject."
else
    cat "$FAILED_ONE_FILE"
fi

# Display students who passed in ALL subjects
echo ""
echo "STUDENTS WHO PASSED IN ALL SUBJECTS"
if [ "$passed_all_count" -eq 0 ]; then
    echo "No students passed in all subjects."
else
    cat "$PASSED_ALL_FILE"
fi

# Display summary counts
echo ""
echo "           SUMMARY"
echo "Students failed in exactly ONE subject: $failed_one_count"
echo "Students passed in ALL subjects:        $passed_all_count"

exit 0