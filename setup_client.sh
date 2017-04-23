#!/bin/bash

# Load auxiliary functions
source setup/functions.sh

echo "Installing components:"
if [ "$(uname)" == "Darwin" ]; then
    # Install homebrew if necessary
    if ! which -s brew ; then
        # Install Homebrew
        echo "- Installing Homebrew..."
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        # Insatll GO and co (for gocryptfs) and Unison
        brew update &>/dev/null
        for pkg in openssl go git unison; do
            if ! brew list -1 | grep -q "^${pkg}\$"; then
                if ! which -s $pkg ; then
                    echo "- Installing $pkg..."
                    brew install $pkg &>/dev/null
                fi
            fi
        done

        # Set GOPATH if necessary
        if [ ! -n "$GOPATH" ]; then
            export GOPATH=$HOME/.go/
            mkdir $GOPATH
        fi

        # Get the source code
        echo "- Fetching gocryptfs source code... "
        REPO="github.com/rfjakob/gocryptfs"
        F_INC="-I/usr/local/opt/openssl/include"
        F_LIB="-L/usr/local/opt/openssl/lib"
        CGO_CFLAGS="$F_INC" CGO_LDFLAGS="$F_LIB" go get $REPO

        # Compile the source code
        echo -n "- Compiling gocryptfs... "
        cd $GOPATH/src/$REPO
        ./build.bash
    fi
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    ## Install Unison
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

    ## Install gocryptfs, for now from binary (see https://github.com/rfjakob/gocryptfs/issues/104)
    echo "Installing gocryptfs from latest release..."
    cd ~
    gocryptfs_fromsrc=false
    if [ "$gocryptfs_fromsrc" = true ]; then
        echo "- downloading source code"
        apt_install golang libssl-dev
        export GOPATH=~
        go get -d github.com/rfjakob/gocryptfs
        cd ~/src/github.com/hanwen/go-fuse/
        echo "- compiling..."
        ~/src/github.com/rfjakob/gocryptfs/build.bash
    else
        curl -L -s https://github.com/rfjakob/gocryptfs/releases/download/v1.2.1/gocryptfs_v1.2.1_debian8_amd64.tar.gz > gocryptfs_v1.2.1_debian8_amd64.tar.gz
        tar xzf gocryptfs_v1.2.1_debian8_amd64.tar.gz
        cp -v ~/gocryptfs /usr/local/bin/
    fi
else
    echo "OS is neither Linux nor OSX. Not sure what to do, so QUIT."
fi

echo
echo "Okay. Now this client to connect to the hub. Use the"
echo "credentials generated during hub configuration..."
echo

echo -n "- Please enter the Hub's IP address: "
read HUB_IP

# Generate a key
ssh-keygen -t rsa -b 4096 -a 100 -f $HOME/.ssh/id_rsa_${APPNAME} -N '' -q

# Add key to authorized hosts of hub
echo -n "- Please enter "
cat $HOME/.ssh/id_rsa_${APPNAME}.pub | ssh -o StrictHostKeyChecking=no sync@$HUB_IP "mkdir ~/.ssh; cat >> ~/.ssh/authorized_keys"

echo "Great, we are done for now!"
