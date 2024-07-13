#!/bin/bash

# Function to log messages
log_message() {
    echo "$1" >> "$HOME/pdf_merge_log.txt"
}

# Start logging
log_message "Script started at $(date)"

# Check if pdftk is installed
if ! command -v pdftk &> /dev/null
then
    zenity --error --text="pdftk is not installed. Please install it using 'sudo apt install pdftk'"
    log_message "Error: pdftk not installed"
    exit 1
fi

# Get the directory of the first selected file
first_file=$(echo "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" | head -n1)
dir=$(dirname "$first_file")
log_message "Working directory: $dir"

# Create a list of selected files
selected_files=()
while IFS= read -r file; do
    if [[ $file == *.pdf ]]; then
        selected_files+=("$file")
        log_message "Selected file: $file"
    fi
done <<< "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

# Check if any PDF files were selected
if [ ${#selected_files[@]} -eq 0 ]; then
    zenity --error --text="No PDF files were selected."
    log_message "Error: No PDF files selected"
    exit 1
fi

# Use the name of the first selected file as the default output name
default_name=$(basename "$first_file")
output_file=$(zenity --entry --title="Merge PDFs" --text="Enter the name for the merged PDF file:" --entry-text="$default_name")

# Check if user cancelled the operation
if [ $? -ne 0 ]; then
    log_message "User cancelled operation"
    exit 1
fi

# Add .pdf extension if not present
if [[ $output_file != *.pdf ]]; then
    output_file="${output_file}.pdf"
fi

# Full path for output file
output_path="$dir/$output_file"
log_message "Initial output file: $output_path"

# Check if output file matches any input file
for file in "${selected_files[@]}"; do
    if [ "$file" = "$output_path" ]; then
        output_file="${output_file%.pdf}-merged.pdf"
        output_path="$dir/$output_file"
        log_message "Output file matches an input file. Changed to: $output_path"
        break
    fi
done

# Check if output file already exists and prompt for overwrite if it does
if [ -f "$output_path" ]; then
    zenity --question --text="File $output_file already exists. Do you want to overwrite it?" --ok-label="Overwrite" --cancel-label="Cancel"
    if [ $? -ne 0 ]; then
        log_message "User chose not to overwrite existing file"
        exit 1
    fi
    log_message "User chose to overwrite existing file"
fi

# Merge PDFs
log_message "Attempting to merge PDFs..."
if pdftk "${selected_files[@]}" cat output "$output_path" 2>> "$HOME/pdf_merge_log.txt"; then
    log_message "PDFs merged successfully"
    zenity --info --text="PDFs merged successfully.\nOutput file: $output_path"
else
    error_message=$(tail -n 5 "$HOME/pdf_merge_log.txt")
    zenity --error --text="An error occurred while merging PDFs.\nCheck $HOME/pdf_merge_log.txt for details.\n\nLast few lines of log:\n$error_message"
    log_message "Error occurred while merging PDFs"
fi

log_message "Script ended at $(date)"
