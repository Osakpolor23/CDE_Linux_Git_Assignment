#####################################################
#This is the CDE Bootcamp Linux Assignment Submission
#####################################################


# Set environment variables
CSV_URL="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"
RAW_DIR="./raw"
TRANSFORMED_DIR="./transformed"
GOLD_DIR="./gold"
TRANSFORMED_FILE="2023_year_finance.csv"

# Extract: Download the CSV file and save it into the raw folder
echo "Starting extraction process..."
mkdir -p $RAW_DIR
curl -s $CSV_URL -o $RAW_DIR/raw_file.csv

if [ -f "$RAW_DIR/raw_file.csv" ]; then
    echo "File successfully downloaded and saved to $RAW_DIR."
else
    echo "File download failed."
    exit 1
fi

# Transform: Rename the column and select specific columns
echo "Starting transformation process..."
mkdir -p $TRANSFORMED_DIR

awk -F',' 'NR==1 {for (i=1; i<=NF; i++) if ($i=="Variable_code") $i="variable_code";} 
             NR==1 || ($1!="year" && $3!="Value" && $4!="Units" && $5!="variable_code") 
             {print $1","$2","$3","$4}' $RAW_DIR/raw_file.csv > $TRANSFORMED_DIR/$TRANSFORMED_FILE

if [ -f "$TRANSFORMED_DIR/$TRANSFORMED_FILE" ]; then
    echo "Transformation completed and file saved to $TRANSFORMED_DIR."
else
    echo "Transformation failed."
    exit 1
fi

# Load: Move the transformed file to the gold directory
echo "Starting load process..."
mkdir -p $GOLD_DIR
mv $TRANSFORMED_DIR/$TRANSFORMED_FILE $GOLD_DIR/

if [ -f "$GOLD_DIR/$TRANSFORMED_FILE" ]; then
    echo "File successfully loaded into $GOLD_DIR."
else
    echo "Load process failed."
    exit 1
fi

echo "ETL process completed successfully."

# Schedule the script to run every day at 12:00 AM
# crontab -e -- to open the cron tab and then type the line below for 12:00AM daily
# 0 0 * * * ~/Desktop/CDE/CDE_Linux_Git_Assignment/scripts.sh

# Directories
SOURCE_DIR="source_folder"
DEST_DIR="json_and_CSV"

# Create source and destination directories if they don't exist
mkdir -p $SOURCE_DIR
mkdir -p $DEST_DIR

# create csv and json files and save in the source directory
touch $SOURCE_DIR/mycsv.csv $SOURCE_DIR/myjson.json

# Move all CSV and JSON files
mv $SOURCE_DIR/*.csv $SOURCE_DIR/*.json $DEST_DIR/

# Confirm the files have been moved
    # List the files to be checked in an array called files
files=("$DEST_DIR/mycsv.csv" "$DEST_DIR/myjson.json")
    # Loop through each file and check if it exists.

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo " $file successfully loaded to $DEST_DIR."
    else
        echo "Failed to load $file."
        exit 1
    fi
done


