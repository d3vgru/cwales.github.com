#!/bin/sh

# originally from https://gist.github.com/spro/5416485
 
# Read _why's SPOOL in real time.
# Requires `lp` and a printer.
 
BASEURL=http://whytheluckystiff.net
if [ ! -d SPOOL ]; then
    mkdir SPOOL
fi
 
while true; do
    curl -o index $BASEURL
    for LINE in $(<index); do
        if [[ $LINE == SPOOL/* ]]; then
            if [ ! -f $LINE ]; then
                echo $LINE
                curl -o $LINE "$BASEURL/$LINE"
                lp -o raw $LINE
            fi
        fi
    done
    sleep 60
done