# Check if log file argument is provided
# $# : number of arguments
# exit 1 -> exit with error
if [ $# -ne 1 ]; then
    echo "Error: Please provide a log file as argument!"
    exit 1
fi

LOGFILE="$1"

# Check if file exists
# -e : file exists
# ! : negation
if [ ! -e "$LOGFILE" ]; then
    echo "Error: File '$LOGFILE' does not exist!"
    exit 1
fi

# Check if file is readable
# -r : file readable
# ! : negation
if [ ! -r "$LOGFILE" ]; then
    echo "Error: File '$LOGFILE' is not readable!"
    exit 1
fi

# Count total number of log entries
# wc -l : count lines
# < : input redirection
TOTAL_ENTRIES=$(wc -l < "$LOGFILE")
echo "Total log entries: $TOTAL_ENTRIES"

# First we use "cat" to read the log file
# | : pipe - sends output of previous command as input to next command
# grep " <TEXT> " : filters lines containing " <TEXT> "
# then we count using wc -l

# Count INFO messages
INFO_COUNT=$(cat "$LOGFILE" | grep " INFO " | wc -l)
echo "INFO messages: $INFO_COUNT"

# Count WARNING messages
WARNING_COUNT=$(cat "$LOGFILE" | grep " WARNING " | wc -l)
echo "WARNING messages: $WARNING_COUNT"

# Count ERROR messages
ERROR_COUNT=$(cat "$LOGFILE" | grep " ERROR " | wc -l)
echo "ERROR messages: $ERROR_COUNT"

echo "------------------------------------------"

# Display the most recent ERROR message
echo "Most Recent ERROR Message:"

# check ERROR_COUNT > 0 - we have the variable above
# we use cat and grep to read and apply filter
# tail -> reads and displays the output from the end
# tail -1 -> displays 1 line from the end -> i,e last line
if [ ERROR_COUNT > 0 ]; then
    cat "$LOGFILE" | grep " ERROR " | tail -1
else
    echo "No ERROR messages found in the log file."
fi

# Generate report file with current date
CURRENT_DATE=$(date +%Y-%m-%d)
REPORT_FILE="logsummary_${CURRENT_DATE}.txt"

# Create the report file
# { ... } - we use this for command grouping
# we group lot of echo - with details we want to write
# > "$REPORT_FILE" - redirects output to the file
{
    echo "Generated on: $(date)"
    echo "Log file analyzed: $LOGFILE"
    echo ""
    echo "Total log entries:  $TOTAL_ENTRIES"
    echo "INFO messages:      $INFO_COUNT"
    echo "WARNING messages:   $WARNING_COUNT"
    echo "ERROR messages:     $ERROR_COUNT"
    echo ""
    echo "MOST RECENT ERROR:"
    echo "------------------------------------------"
    if [ ERROR_COUNT > 0 ]; then
        cat "$LOGFILE" | grep " ERROR " | tail -1
    else
        echo "No ERROR messages found in the log file."
    fi
} > "$REPORT_FILE"

# exit gracefully
exit 0
