#!/bin/bash

# Load auxiliary functions
source setup/functions.sh

# Install Unison
if [ ! -f /usr/local/bin/unison ]; then
    echo "Installing Unison from latest STABLE release..."
    echo "- downloading source code"
    B='http://www.seas.upenn.edu/~bcpierce/unison//download/releases/stable/'
    F=$(curl -s $B | grep -o '"unison-.*tar.gz"' | tr -d '"')
    echo "- compiling..."
    apt_install ocaml ocaml-native-compilers ctags
    curl -o $F -s $B$F
    tar xzf $F
    cd src
    make UISTYLE=text &> unison.log
    cp -v unison /usr/local/bin/
fi

# Create encrypted store for current user
SD=/home/$N_USER/store/
if [ ! -d $SD ]; then
    echo "Creating encrypted store for user [$N_USER] in [$SD]..."
    mkdir $SD
    chown $N_USER:$N_USER $SD
fi
