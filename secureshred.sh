#!/bin/bash
# SecureShred v1.0 overwrites the binary memory pointed to by a directory, and the contents therein with zeros. 
# Requires "pv" for progress bar functionality. 
# Written by denshinobi_; Art by Roland Hangg and denshinobi_

# Ensure 'pv' is installed for progress bar functionality
if ! command -v pv >/dev/null 2>&1; then
    printf "'pv' is not installed. Installing now. This may require sudo privileges, and hence, your password.\n\n"
    sudo apt update && sudo apt install -y pv
    if [ $? -ne 0 ]; then
        printf "Failed to install 'pv'. Please install it manually and re-run the script."
        exit 1
    fi
fi

# Check if a directory was passed
if [ -z "$1" ]; then
    printf "Usage: $0 <target_directory_to_shred_securely>"
    exit 1
fi
targetdir="$1"
# Confirm the directory exists
if [ ! -d "$targetdir" ]; then
    printf "Error: '$targetdir' is not a valid directory."
    exit 1
fi
# Warn the user
printf "!!! Are you sure you want to SECURELY DELETE everything in '$targetdir' including the directory itself? \n(Operation will be cancelled if 'yes' is not explicitly typed.):\n"
read -p ">>> " confirm
printf "\n"
if [ "$confirm" != "yes" ]; then
    printf "OPERATION CANCELLED.\n"
    exit 1
fi
cat <<'EOF' 
             ________________________________________________
            /                                                \
           |    _________________________________________     |
           |   |                                         |    |
           |   |                                         |    |
           |   |  0101001101010010100110101010100010010  |    |
           |   |  0010101011010101010101011011010010111  |    |
           |   |  1111011101101111111111101010001010100  |    |
           |   |                                         |    |
           |   |   | | | | | | | | | | | | | | | | | |   |    |
           |   |   V V V V V V V V V V V V V V V V V V   |    |
           |   |                                         |    |
           |   |  0000000000000000000000000000000000000  |    |
           |   |  0000000000000000000000000000000000000  |    |
           |   |  0000000000000000000000000000000000000  |    |
           |   |  0000000000000000000000000000000000000  |    |
           |   |_________________________________________|    |
           |                        電                        |
            \________________________________________________/
                   \___________________________________/
                ___________________________________________
             _-'    .-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.  --- `-_
          _-'.-.-. .---.-.-.-.-.-.-.-.-.-.-.-.-.-.-.--.  .-.-.`-_
       _-'.-.-.-. .---.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-`__`. .-.-.-.`-_
    _-'.-.-.-.-. .-----.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-----. .-.-.-.-.`-_
 _-'.-.-.-.-.-. .---.-. .-------------------------. .-.---. .---.-.-.-.`-_
:-------------------------------------------------------------------------:
`---._.-------------------------------------------------------------._.---'

EOF
printf "Shredding files inside '$targetdir'..."

# Get all files
mapfile -t FILES < <(find "$targetdir" -type f)
TOTAL=${#FILES[@]}
# Exit if no files found
if [ "$TOTAL" -eq 0 ]; then
    printf "No files found to shred."
    exit 0
fi

# Shred with progress
COUNT=0
for FILE in "${FILES[@]}"; do
    shred -u "$FILE"
    ((COUNT++))

    # Progress bar
    PROGRESS=$((COUNT * 100 / TOTAL))
    BAR=$(printf "%-${PROGRESS}s" "#" | tr ' ' '#')
    printf "\rProgress: [%-100s] %d%%" "$BAR" "$PROGRESS"
done
printf "\n\nFile shredding complete.\n"

# Remove empty directories (bottom-up)
find "$targetdir" -depth -type d -exec rmdir {} + 2>/dev/null

# Remove the top-level target directory itself
if rmdir "$targetdir" 2>/dev/null; then
    printf "'$targetdir' securely deleted."
elif [ ! -d "$targetdir" ]; then
    printf "The directory '$targetdir' has been securely deleted.\n"
else
    printf "!!! Could not remove '$targetdir'!!!. It may not be empty...\n"
fi
#  電忍者
