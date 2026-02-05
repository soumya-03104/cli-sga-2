# Run the script with the sample log file:
./loganalyzer.sh sample.log
## OUTPUT
# Total log entries:       12
# INFO messages:        5
# WARNING messages:        3
# ERROR messages:        4
# ------------------------------------------
# Most Recent ERROR Message:
# 2025-01-12 10:25:15 ERROR Connection refused

# Test error handling - no arguments:
./loganalyzer.sh
## OUTPUT
# 

# Test error handling - non-existent file:
./loganalyzer.sh random.log
## OUTPUT
# 
