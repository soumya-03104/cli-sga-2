# Create the script file
vim analyze.sh

# Make the script executable
chmod +x analyze.sh

# Create a test file
echo -e "Line 1\nLine 2\nLine 3" > testfile.txt

# Create a test directory with files
mkdir testdir && touch testdir/{file1.txt,file2.txt,script.sh,data.csv}

# Test with a file argument
./analyze.sh testfile.txt
## OUTPUT
# Number of lines:             5
# Number of words:            40
# Number of characters:      230

# Test with a directory argument
./analyze.sh testdir
## OUTPUT
# Total number of files:        6
# Number of .txt files:         3

# Test with no arguments (error case)
./analyze.sh
## OUTPUT
# Error: Invalid argument count!

# Test with non-existent path (error case)
./analyze.sh /random/path
## OUTPUT
# Error: Path '/random/path' does not exist!

# Test with too many arguments (error case):
./analyze.sh testfile.txt testdir
## OUTPUT
# Error: Invalid argument count!
