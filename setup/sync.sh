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

# Install gocryptfs
echo "Installing gocryptfs from latest release..."
echo "- downloading source code"
apt_install golang libssl-dev
export GOPATH=~
go get -d github.com/rfjakob/gocryptfs

echo "- compiling..."
~/src/github.com/rfjakob/gocryptfs/build.bash
~/src/github.com/rfjakob/gocryptfs/test.bash -v

