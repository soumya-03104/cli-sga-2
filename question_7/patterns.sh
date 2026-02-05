INPUT_FILE="input.txt"
VOWELS_FILE="vowels.txt"
CONSONANTS_FILE="consonants.txt"
MIXED_FILE="mixed.txt"

# Clear output files
echo "" > "$VOWELS_FILE"
echo "" > "$CONSONANTS_FILE"
echo "" > "$MIXED_FILE"

# Explanations
# tr -d 'aeiou' : Delete all vowels from string
# tr -d 'bcdfghjklmnpqrstvwxyz' : Delete all consonants
# tr '[:upper:]' '[:lower:]' : Convert to lowercase
# ${word:0:1} : Get first character of word
# grep -q : Quiet grep for conditional check
# -z : Check if string is empty
# -s : Check if file is not empty

# Define patterns (case insensitive handled by converting to lowercase)
# Vowels: a, e, i, o, u
# Consonants: b, c, d, f, g, h, j, k, l, m, n, p, q, r, s, t, v, w, x, y, z

# Extract words and process each one
# tr -cs converts non-letters to newlines
tr -cs 'A-Za-z' '\n' < "$INPUT_FILE" | grep -v '^$' | while read -r word; do
    # Convert word to lowercase for pattern matching
    word_lower=$(echo "$word" | tr '[:upper:]' '[:lower:]')

    # Check if word contains only vowels
    # Remove all vowels, if nothing left = only vowels
    without_vowels=$(echo "$word_lower" | tr -d 'aeiou')

    # Check if word contains only consonants
    # Remove all consonants, if nothing left = only consonants
    without_consonants=$(echo "$word_lower" | tr -d 'bcdfghjklmnpqrstvwxyz')

    # Categorize the word
    if [ -z "$without_vowels" ]; then
        # Word contains ONLY vowels
        echo "$word" >> "$VOWELS_FILE"
    elif [ -z "$without_consonants" ]; then
        # Word contains ONLY consonants
        echo "$word" >> "$CONSONANTS_FILE"
    else
        # Word contains both vowels and consonants
        # Check if it starts with a consonant
        first_char="${word_lower:0:1}"

        # Check if first character is a consonant
        if echo "$first_char" | grep -q '[bcdfghjklmnpqrstvwxyz]'; then
            echo "$word" >> "$MIXED_FILE"
        fi
        # Words starting with vowels but containing both are not categorized
    fi
done

# Count words in each category
vowel_count=$(wc -l < "$VOWELS_FILE" 2>/dev/null | xargs)
consonant_count=$(wc -l < "$CONSONANTS_FILE" 2>/dev/null | xargs)
mixed_count=$(wc -l < "$MIXED_FILE" 2>/dev/null | xargs)

echo ""
echo "Words with ONLY VOWELS"
echo "Count: $vowel_count"
if [ -s "$VOWELS_FILE" ]; then
    cat "$VOWELS_FILE"
else
    echo "(No words found)"
fi

echo ""
echo "Words with ONLY CONSONANTS"
echo "Count: $consonant_count"
if [ -s "$CONSONANTS_FILE" ]; then
    cat "$CONSONANTS_FILE"
else
    echo "(No words found)"
fi

echo ""
echo "MIXED words starting with consonant"
echo "Count: $mixed_count"
if [ -s "$MIXED_FILE" ]; then
    cat "$MIXED_FILE"
else
    echo "(No words found)"
fi

exit 0
