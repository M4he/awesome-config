#!/bin/bash
export DISPLAY=":0.0"
export XAUTHORITY="$HOME/.Xauthority"
function hdmi_connect(){
    echo "connecting HDMI ..." >> /var/log/HDMI.log
    xrandr --output HDMI1 --primary --auto --pos 0x0 --output eDP1 --pos 240x1080
}

function dp_connect(){
    xrandr --output DP1 --auto --right-of eDP1
}

function disconnect(){
    xrandr --output HDMI1 --off --output DP1 --off --output eDP1 --primary --auto
}

EXT="NONE"
xrandr | grep "^HDMI1 connected" &> /dev/null && EXT="HDMI1" 
xrandr | grep "^DP1 connected" &> /dev/null && EXT="DP1"
echo "Detected external display $EXT"

case "$1" in
    primary)
        xrandr --output HDMI1 --off;
        xrandr --output DP1 --off;
        xrandr --output eDP1 --primary --auto;
        ;;
    secondary)
        xrandr --output eDP1 --off;
        xrandr --output $EXT --primary --auto;
        ;;
    extend)
        xrandr --output eDP1 --primary --auto;
        xrandr --output $EXT --auto --right-of eDP1;
        ;;
    mirror)
        xrandr --output $EXT --primary --auto --output eDP1 --auto --same-as $EXT
        ;;
    ontop)
        xrandr --output $EXT --primary --auto;
        xrandr --output eDP1 --auto --below $EXT;
        ;;
    *)
        echo "WRONG INPUT"
        ;;
esac
