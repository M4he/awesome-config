# Personal Red Flat Awesome WM config

This is my personal modification/setup of [worron](https://github.com/worron)'s fantastic [awesome-config](https://github.com/worron/awesome-config) and [Red Flat extension library](https://github.com/worron/redflat) for [Awesome WM](http://awesome.naquadah.org).
A huge shout-out to this guy for creating this collection of arguably the most aesthetically pleasing widgets and themes for AwesomeWM 4!

## Overview

- I maintain this fork as a live backup of my personal configuration which builds directly on worron's upstream repository
- added a theme and configuration scheme both called `mahe`
    - sometimes you may find `*-laptop` stuff, these are specific derivatives for my laptop obviously
- I also maintain a [separate fork](](https://github.com/M4he/redflat)) of the Red Flat library that is used as a submodule here
- I'm trying my best to provide all my enhancement and fixes upstream

## Screenshots

![TODO](#)

## Tips

### Menus jumping a bit when opened for first time

When menus (awesome menu, client menu etc.) are opened for the first time afte Awesome start/restart, they may reallocate themselves a bit to make space for their border. If you are using `compton` you may alleviate this by using a small fade effect in your compton config:

    fading = true;                                                                  
    fade-in-step = 0.1;                                       
    fade-out-step = 0.1;