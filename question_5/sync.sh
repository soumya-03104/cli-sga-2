DIR_A="dirA"
DIR_B="dirB"

# Get list of files in each directory
# sort to ensure consistent order
files_A=$(ls "$DIR_A" | sort)
files_B=$(ls "$DIR_B" | sort)

# Convert to arrays
# IFS is the internal field separator
# \n - reading from a newline-separated value
# -d '' - read until the first null byte
# -ra - read into an array
IFS=$'\n' read -d '' -ra arr_A <<< "$files_A"
IFS=$'\n' read -d '' -ra arr_B <<< "$files_B"

# Initialize counters
only_in_A=0
only_in_B=0
common_same=0
common_diff=0

found_only_A=false
for file in "${arr_A[@]}"; do
    # -e : file exists
    # ! : negation
    if [ ! -e "$DIR_B/$file" ]; then
        ((only_in_A++))
        found_only_A=true
    fi
done
if [ "$found_only_A" = false ]; then
    echo "  (No unique files in $DIR_A)"
fi

found_only_B=false
for file in "${arr_B[@]}"; do
    # -e : file exists
    # ! : negation
    if [ ! -e "$DIR_A/$file" ]; then
        ((only_in_B++))
        found_only_B=true
    fi
done
if [ "$found_only_B" = false ]; then
    echo "  (No unique files in $DIR_B)"
fi

echo ""
echo "COMMON FILES - CONTENT COMPARISON"

found_common=false
for file in "${arr_A[@]}"; do
    echo ""
    echo " checking $file"
    if [ -e "$DIR_B/$file" ]; then
        found_common=true
        # Compare file contents using cmp
        if cmp -s "$DIR_A/$file" "$DIR_B/$file"; then
            echo "[IDENTICAL] $file"
            ((common_same++))
        else
            echo "[DIFFERENT] $file"
            ((common_diff++))

            # Show diff summary
            echo ""
            echo "Changes detected:"
            diff "$DIR_A/$file" "$DIR_B/$file"
        fi
    fi
done

if [ "$found_common" = false ]; then
    echo "No common files between directories"
fi

exit 0
