# A simple script to merge selected PDF files in Ubuntu Nautilus file manager

This script will allow you to select multiple PDF files in Nautilus, right-click, and merge them into a single PDF file.

It also allows the user to specify the name of the output file.

## Installation

To use this script with Nautilus, follow these steps:

1. Make sure `pdftk` is installed. If it's not, you can install it using:
   ```
   sudo apt install pdftk
   ```

2. Copy the script in the Nautilus scripts directory:
   ```
   mkdir -p ~/.local/share/nautilus/scripts
   cd ~/.local/share/nautilus/scripts
   wget https://raw.githubusercontent.com/marc-farre/nautlius-script-merge-pdf/main/Merge_PDFs.sh
   ```

3. Make the script executable:
   ```
   chmod +x ~/.local/share/nautilus/scripts/Merge_PDFs
   ```

4. Restart Nautilus for the changes to take effect:
   ```
   nautilus -q
   ```

## Usage

Now you can use this script by doing the following:

1. Select the PDF files you want to merge in Nautilus.
2. Right-click and go to "Scripts" > "Merge_PDFs".
3. Enter a name for the merged PDF file when prompted.
4. The script will merge the PDFs and save the result in the same directory as the selected files.

This script includes error checking for the presence of `pdftk`, ensures that only PDF files are processed, and uses Zenity for user-friendly dialog boxes.

If you get an error message, full log file is available at ~/pdf_merge_log.txt.
