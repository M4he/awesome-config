#!/bin/bash

EXT="NONE"
xrandr | grep "^HDMI1 connected" &> /dev/null && EXT="HDMI1" 
xrandr | grep "^DP1 connected" &> /dev/null && EXT="DP1"
echo "Detected external display $EXT"

case "$1" in
    primary)
        xrandr --output eDP1 --primary --auto --output HDMI1 --off --output DP1 --off;
        ;;
    secondary)
        xrandr --output $EXT --primary --auto --output eDP1 --off;
        ;;
    extend)
        xrandr --output eDP1 --primary --auto --output $EXT --auto --right-of eDP1;
        ;;
    mirror)
        xrandr --output $EXT --primary --auto --output eDP1 --auto --same-as $EXT;
        ;;
    ontop)
        xrandr --output $EXT --primary --auto --output eDP1 --auto --below $EXT;
        ;;
    *)
        echo "WRONG INPUT"
        ;;
esac
