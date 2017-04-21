#! /bin/bash

# Load auxiliary functions
source setup/functions.sh

# Are we running as root?
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Please re-run like this:"
    echo
    echo "sudo $0"
    echo
    exit
fi

# Are we running on Ubuntu
if [ "$(lsb_release -d | sed 's/.*:\s*//' | sed 's/ .*//')" != "Ubuntu" ]; then
    echo "This application only supports being installed on Ubuntu. You are running:"
    echo
    lsb_release -d | sed 's/.*:\s*//'
    exit
fi

# Check that we have enough memory.
TOTAL_PHYSICAL_MEM=$(head -n 1 /proc/meminfo | awk '{print $2}')
if [ $TOTAL_PHYSICAL_MEM -lt 500000 ]; then
    if [ ! -d /vagrant ]; then
        TOTAL_PHYSICAL_MEM=$(expr \( \( $TOTAL_PHYSICAL_MEM \* 1024 \) / 1000 \) / 1000)
        echo "This server needs more memory (RAM) to function properly."
        echo "Please provision a machine with at least 512 MB."
        echo "This machine has $TOTAL_PHYSICAL_MEM MB memory."
        exit
    fi
fi
