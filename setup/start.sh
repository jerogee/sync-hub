#! /bin/bash

APPNAME='SyncHub'

# In case of Vagrant move to right dir
if [ -d /vagrant ]; then
    cd /vagrant
fi

# Load auxiliary functions
source setup/functions.sh

# Check system setup
source setup/preflight.sh

# Do system setup
source setup/system.sh

# Configure Sync functionality
source setup/sync.sh
