#Simplify the access to the screen resolution

## Description

If you're working on a laptop and have to change your screen configurations very often this script is for you. It also to set all common options with remembering the complex structure of xrandr. Therefore it's just a simple bash script, but it saves a lot of time ;-)
    
## Install

1. Clone the bash file
2. source it (multiple ways)
    * create a symbolic link to it (example is for debian based distributions) `sudo ln -s /home/xsebi/gcode/tools/bash/screenchange/screenchange.sh /usr/local/bin/screenchange`
    * add it to the .bash_aliases
    * add the whole folder to your source files
3. I would recommend to have some nice shortcuts -> add them to your .bash_aliases

## 
    alias monitor-off='xrandr --output VGA1 --off;xrandr --output HDMI1 --off'
    alias hdmi='screenchange -1 HDMI1 -2 LVDS1 -m'
    alias vga='screenchange -1 VGA1 -2 LVDS1 -m'
    alias hdmi2='screenchange -1 HDMI1 -2 VGA1 -m'
    alias vga2='screenchange -1 VGA1 -2 HDMI1 -m'

(2 stands for two connected monitors)

The names may vary between different drivers, to lookup your resolution run `xrandr -q` (or `screenchange -m m`)


## Usage

    screenchange [OPTIONS] FirstDisplay SecondDisplay

### Options

    -m|--mode	  sets the mode (see below)
    -1|--first	  sets the internal screen (has priority before input)
    -2|--second     sets the external screen (has priority before input)
    -p|--primary    swaps the primary screen (default is the internal)

### Modes

    first[f]        use first screen only
    second[s]       use second screen only
    clone[c]        clone the internal screen
    extendl[l]      extends the connected monitor to the left  of the internal one
    extendr[r]      extends the connected monitor to the right of the internal one
    modes[m]        display all possible screen resolutions of all connected screens

By default the first display is primary, change this with the primary flag

# Examples 
 
    what             with aliases    without aliases + long names
    HDMI1* | LVDS1   hdmi l          screenchange --first HDMI1 --second LVDS1 --mode extendl
    HDMI1  | VGA1*   vga2 r          screenchange --first VGA1  --second HDMI1 --mode extendr
    VGA1   | HDMI1*  vga2 l          screenchange --first VGA1  --second HDMI1 --mode extendl
    HDMI             hdmi i          screenchange --first HDMI1 --second LVDS1 --mode internal
    HDMI1 = VGA1     hdmi c          screenchange --first HDMI1 --second VGA1  --mode clone

## Have fun & save time
