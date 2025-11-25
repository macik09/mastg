#!/bin/bash

PACKAGE="org.owasp.mastestapp"
DB_NAME="PrivateUnencryptedData"
DB_PATH="/data/data/$PACKAGE/databases/$DB_NAME"
SDCARD_PULL_PATH="/sdcard/$DB_NAME.db"
OUTPUT_DB_FILE="${DB_NAME}.db"
OUTPUT_TXT_FILE="output.txt"

# Step 1: Database Extraction
adb shell "run-as $PACKAGE cp databases/$DB_NAME $SDCARD_PULL_PATH" 2>/dev/null

# Attempt to copy via root access using here document
adb shell <<EOF
su
cp $DB_PATH $SDCARD_PULL_PATH
exit
EOF

# Pull the file to the host machine
adb pull "$SDCARD_PULL_PATH" .

echo "--- Users Table Content ---" > $OUTPUT_TXT_FILE
sqlite3 "$OUTPUT_DB_FILE" "SELECT * FROM Users;" >> $OUTPUT_TXT_FILE

adb shell "rm $SDCARD_PULL_PATH" 2>/dev/null
rm $OUTPUT_DB_FILE 2>/dev/null
