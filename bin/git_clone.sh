#!/bin/sh

ensure_src() {
    if [ -e src ] ; then
        if [ ! -d src ] ; then
            echo "folder src exists but is not a directory"
            exit 1
        fi
    else
        mkdir -p src
    fi
}

clone() {
    local DIR=$1
    local PULL_URL="https://github.com/BCCVL/${DIR}.git"
    local PUSH_URL="git@github.com:BCCVL/${DIR}.git"

    ensure_src
    pushd src

    echo "Cloning $DIR"
    if [ -d "$DIR" ] ; then
        local url
        url=$(git -C $DIR remote get-url origin 2> /dev/null)
        if [ $? -ne 0 ] ; then
            echo "Dir $DIR exists but is not a git repository"
            exit 1
        fi
        if [ -z $url ] ; then
            echo "Dir $DIR exists, but pull url not set"
            exit 1
        fi
        if [ "$PULL_URL" !=  "$url" ]; then
            echo "Clone $DIR exists, but pull url doesn't match $PULL_URL"
            return
        fi
    else

        git clone ${PULL_URL}

    fi

    local url=$(git -C $DIR remote get-url --push origin 2> /dev/null)
    if [ $? -ne 0 ] ; then
        # ignore errors here?
        return
    fi
    if [ "$PULL_URL" == "$url" ] ; then
        # pull url same as push url ... set up push url as well
        git -C $DIR remote set-url --push origin $PUSH_URL
    fi
    if [ "$PUSH_URL" != "$url" ] ; then
        echo "Clone $DIR exists, but push url doesn't match $PUSH_URL"
    fi

    popd
}

clone bccvl_buildout
clone BCCVL_Visualiser
clone org.bccvl.compute
clone org.bccvl.movelib
clone org.bccvl.site
clone org.bccvl.tasks
clone org.bccvl.testsetup
clone org.bccvl.theme
