#!/bin/bash

# Update packages and install Python 3.11
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install -y python3.11 python3.11-venv python3.11-dev git

# Set up a virtual environment for Python 3.11
python3.11 -m venv myenv
source myenv/bin/activate

# Upgrade pip and install the libraries
pip install --upgrade pip
pip install git+https://github.com/R0rt1z2/liblk
pip install git+https://github.com/abodev144/lkpatcher

# Create output directory if it doesn't exist
mkdir -p output

# Run liblk to get partition details
echo 'import sys
from liblk.LkImage import LkImage

def main():
    lk_image = LkImage(sys.argv[1])
    partitions = lk_image.get_partition_list()
    for partition in partitions:
        print(str(partition))

if __name__ == "__main__":
    main()' > get_partitions.py

# Replace "lk.bin" with the path to your LK file
python get_partitions.py lk.bin

# Run LK Patcher
# Replace "patches.json" with the path to your JSON patch file and "lk.bin" with the path to your LK file
python3 -m lkpatcher -o output/lk-patched.bin -j patches.json lk.bin

# Print completion message
echo "Script executed successfully!"
