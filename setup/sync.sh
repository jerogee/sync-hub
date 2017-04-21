#!/bin/bash

# Load auxiliary functions
source setup/functions.sh

# Install Unison
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
