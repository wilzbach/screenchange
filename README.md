Simplify the access to your screen settings
============================================

## Description

If you're working on a laptop and have to change your screen configurations very often this script is exactly for you.
It provides you with an intuitive wrapper around xrandr.

# Examples

## With one screen

	what            | aliases  
	----------------|--------
    HDMI1* | LVDS1  | hdmi l[eft]  
    HDMI1  | LVDS1* | hdmi l --primary
    LVDS1  | HDMI1* | hdmi r[ight]
    LVDS1* | HDMI1  | hdmi l -p
    HDMI1 = LVDS1   | hdmi c[lone]
    HDMI1           | hdmi f[irst]
    LVDS1           | hdmi s[econd]

`LVDS1`: internal monitor
`*`: primary monitor
`-p`: swaps the primary monitor (`*`)
`alias hdmi='screenchange --first HDMI1 --second LVDS1 --mode'`

### With two screens

    HDMI1* | VGA1   | hdmi2 l[eft]    | vga2 r -p
    HDMI1  | VGA1*  | hdmi2 l -p      | vga2 r[right]
    VGA1   | HDMI1* | hdmi2 r         | vga2 l -p
    VGA1*  | HDMI1  | hdmi2 r -p      | vga2 l
    HDMI1 = VGA1    | hdmi2 c[lone]   | vga2 c[clone]
    HDMI1           | hdmi2 f[irst]   | vga2 s[econd]
    VGA1            | hdmi2 s[econd]  | vga2 f[irst]

## Usage

    screenchange [OPTIONS] FirstDisplay SecondDisplay

### Options

    -m|--mode	  sets the mode (see below)
    -1|--first	  sets the first screen (has priority before input)
    -2|--second     sets the second screen (has priority before input)
    -p|--primary    swaps the primary screen (default is the internal)

### Modes

    first[f]        use first screen only
    second[s]       use second screen only
    clone[c]        clone the internal screen
    extendl[l]      extends the connected monitor to the left  of the internal one
    extendr[r]      extends the connected monitor to the right of the internal one
    modes[m]        display all possible screen resolutions of all connected screens

By default the first display is primary, change this with the primary flag

    
## Install

a) Use the [Arch package](https://aur.archlinux.org/packages/screenchange-git/)

b) Manually

1. Clone the bash file
2. source it (multiple ways)


  a) add it to your `.bash_aliases` (or `.zshrc`)

````
alias screenchange="/path/to/this/repo/screenchange/screenchange"
```   

  b) create a symbolic link to it

```
sudo ln -s /path/to/this/repo/screenchange/screenchange /usr/local/bin/screenchange
```

Nice aliases
-------------

I recommend to have some nice shortcuts. Put them into your run configuration (e.g `.bash_aliases` or `.zshrc`).

```
alias hdmi='screenchange -1 HDMI1 -2 LVDS1 -m'
alias vga='screenchange -1 VGA1 -2 LVDS1 -m'
alias hdmi2='screenchange -1 HDMI1 -2 VGA1 -m'
alias vga2='screenchange -1 VGA1 -2 HDMI1 -m'
alias reset='xrandr --auto'
alias monitor-off='xrandr --output VGA1 --off;xrandr --output HDMI1 --off'
```

(2 stands for two external monitors)

The names for the monitors may vary between different drivers, to lookup yours run `xrandr -q` (or `screenchange -m m`)

## Have fun & save time
