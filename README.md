#Hello

## Description

Simply access.

    aaa
    
## Install

1. Clone the bash file
2. source it (multiple ways)
    * create a symbolic link to it (example is for debian based distributions) `sudo ln -s /home/xsebi/gcode/tools/bash/screenchange/screenchange.sh /usr/local/bin/screenchange`
    * add it to the .bash_aliases
    * add the whole folder to your source files
3. I would recommend to have some nice shortcuts -> add them to your .bash_aliases

## 
    alias monitor-off='xrandr --output VGA1 --off;xrandr --output HDMI1 --off'
    alias hdmi='screenchange -i HDMI1 -e LVDS1 -m'
    alias vga='screenchange -i VGA1 -e LVDS1 -m'
    alias hdmi2='screenchange -i HDMI1 -e VGA1 -m'
    alias vga2='screenchange -i VGA1 -e HDMI1 -m'

(2 stands for two connected monitors)

The names may vary between different drivers, to lookup your resolution run `xrandr -q` (or `screenchange -m m`)


## Usage

    screenchange [OPTONS] InternalDisplay ExternalDisplay

### Options

    -m|--mode       sets the mode (see below)
    -i|--internal   sets the internal screen (has priority before input)
    -e|--external   sets the external screen (has priority before input)
    -p|--primary    swaps the primary screen (default is the internal)

### Modes

    internal[i]     use internal screen only
    external[e]     use external screen only
    clone[c]        clone the internal screen
    extendl[l]      extends the connected monitor to the left  of the internal one
    extendr[r]      extends the connected monitor to the right of the internal one
    modes[m]        display all possible screen resolutions of all connected screens

By default internal is primary, change this with the primary flag

# Examples 
 
what             with aliases    without aliases + long names
HDMI1* | LVDS1   hdmi l          screenchange --internal HDMI1 --external LVDS1 --mode extendl
HDMI1* | VGA1    hdmi2l          screenchange --internal HDMI1 --external VGA1  --mode extendl
VGA1   | HDMI1*  vga2 l          screenchange --internal VGA1  --external HDMI1 --mode extendl
HDMI             hdmi i          screenchange --internal HDMI1 --external LVDS1 --mode internal

## Have fun & save time
