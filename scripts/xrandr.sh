#!/bin/bash

case "$1" in
    primary)
        xrandr --output HDMI2 --primary --auto --output HDMI1 --off;
        ;;
    secondary)
        xrandr --output HDMI1 --primary --mode 1920x1080 --rate 60 --output HDMI2 --off;
        ;;
    extend)
        xrandr --output HDMI2 --primary --auto --output HDMI1 --mode 1920x1080 --rate 60 --right-of HDMI2;
        ;;
    mirror)
        xrandr --output HDMI2 --primary --auto --output HDMI1 --mode 1920x1080 --rate 60 --same-as HDMI2
        ;;
    ontop)
        xrandr --output HDMI1 --primary --mode 1920x1080 --rate 60 --output HDMI2 --auto --below HDMI1;
        ;;
    *)
        echo "WRONG INPUT"
        ;;
esac
