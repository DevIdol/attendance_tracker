#!/bin/sh

# This script processes Dart-Defines and includes flavor-specific xcconfig files
OUTPUT_FILE="${SRCROOT}/Flutter/DartDefines.xcconfig"

# Function to decode URL-safe base64 encoded strings
function decode_url() { echo "${*}" | base64 --decode; }

# Clear the output file before writing
: > $OUTPUT_FILE

# Split the DART_DEFINES string by commas into an array
IFS=',' read -r -a define_items <<<"$DART_DEFINES"

# Iterate through each Dart-Define item
for index in "${!define_items[@]}"
do
    # Decode the URL-safe base64 encoded string
    item=$(decode_url "${define_items[$index]}")
    
    # Check if this define contains 'FLAVOR'
    if [ $(echo $item | grep 'FLAVOR') ] ; then
        # Extract the value after the '=' sign
        value=${item#*=}
        
        # Write an include directive for the flavor-specific xcconfig file
        echo "#include \"$value.xcconfig\"" >> $OUTPUT_FILE
    fi
done