#! /bin/bash

# Load auxiliary functions
source setup/functions.sh

# Add a sync user
N_USER='sync'
if id -u $N_USER > /dev/null 2>&1; then
    userdel $N_USER
    rm -fr /home/$N_USER/
fi

# Generate a random temporary password
T_PWD=$(openssl rand -hex 20)

# Add user with generated password
useradd -m -p $(openssl passwd -1 $T_PWD) -s /bin/bash -d /home/$N_USER -U $N_USER

if [ -d "/vagrant" ]; then
    IP=$(get_default_privateip)
else
    IP=$(get_publicip_from_web_service 4)
fi

echo "Configure clients to sync with SyncHub using:"
echo "- IP address: $IP"
echo "- Username  : $N_USER"
echo "- Password  : $T_PWD"

# Install system packages
echo Installing system packages...
apt-get install -qq -o=Dpkg::Use-Pty=0 python3 python3-pip wget curl git sudo coreutils unattended-upgrades cron ntp fail2ban

# Suppress Upgrade Prompts
if [ -f /etc/update-manager/release-upgrades ]; then
    tools/editconf.py /etc/update-manager/release-upgrades Prompt=never
    rm -f /var/lib/ubuntu-release-upgrader/release-upgrade-available
fi

# We need an ssh key to store backups via rsync, if it doesn't exist create one
echo Generating backup key...
if [ ! -f /root/.ssh/id_rsa_${APPNAME} ]; then
    echo 'Creating SSH key for backup…'
    ssh-keygen -t rsa -b 4096 -a 100 -f /root/.ssh/id_rsa_${APPNAME} -N '' -q
fi

# Install `ufw` which provides a simple firewall configuration.
echo Setting up firewall...
apt_install ufw

# Allow incoming connections to SSH.
ufw_allow ssh;
ufw --force enable;

# Configure periodic unattended upgrades
cat > /etc/apt/apt.conf.d/02periodic <<EOF;
APT::Periodic::MaxAge "7";
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::Verbose "1";
EOF
