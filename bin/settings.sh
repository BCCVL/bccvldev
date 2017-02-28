#!/bin/bash

if [ -e '.env' ] ; then
    source '.env'
fi

if [ -z $BCCVL_HOSTNAME ] ; then

    # get first ipv4 main address for default route
    case "$OSTYPE" in
        darwin*)
            # OSX
            MAIN_IF=$(netstat -rn -f inet | egrep  '(0\.0\.0\.0|default)' | awk '{ printf $6 }')
            export MAIN_IP=$(ipconfig getifaddr ${MAIN_IF})
            ;;
        linux*)
            #  LINUX
            export MAIN_IP=$(ip route get 1 | awk '{print $NF;exit}')
             ;;
        #msys*)
        #     # "WINDOWS"
        #     ;;
        *)
            echo "unknown: $OSTYPE"
            exit 1
            ;;
    esac

    BCCVL_HOSTNAME=${MAIN_IP}
fi
# export main ip address as hostname for services
export BCCVL_HOSTNAME
