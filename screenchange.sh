#!/bin/bash
######################################################################
# Funktionen

PrintUsage(){
cat << EOI
Usage:
 $0 [OPTONS] InternalDisplay ExternalDisplay

Options
  -m|--mode	sets the mode (see below)
  -i|--internal	sets the internal screen (has priority before input)
  -e|--external sets the external screen (has priority before input)
  -p|--primary  swaps the primary screen (default is the internal)

Modes:
  internal[i]     use internal screen only
  external[e]     use external screen only
  clone[c]        clone the internal screen
  extendl[l]      extends the connected monitor to the left  of the internal one
  extendr[r]      extends the connected monitor to the right of the internal one
  modes[m]        display all possible screen resolutions of all connected screens

By default internal is primary, change this with the primary flag

EOI
exit 1
}


################################
# Text color variables
#################################
txtund=$(tput sgr 0 1)           # Underline
txtbld=$(tput bold)              # Bold
bldred=${txtbld}$(tput setaf 1)  #  red
bldblu=${txtbld}$(tput setaf 4)  #  blue
bldwht=${txtbld}$(tput setaf 7)  #  white
txtrst=$(tput sgr0)              # Reset

# Feedback indicators
function notice {
	echo -e ${bldwht}"$1"${txtrst}
}
function pass {
	echo -e ${bldblu}"$1"${txtrst}
}
function error {
	echo -e ${bldred}"$1"${txtrst} >&2
}


#####################################################################
# Read Parameters

# NOTE: This requires GNU getopt.  On Mac OS X, you get BSD getopt by default,
# which doesn't work; see below.
# Put a ':' after options that take a value
PARAM_FIX=`getopt -o vdpi:e:m: --long verbose,debug,primary,internal:,external:,mode: \
             -n "$0" -- "$@"`
if [ $? != 0 ] ; then error "Terminating..."  ; PrintUsage ; fi

# Note the quotes around `$TEMP': they are essential!
eval set -- "$PARAM_FIX"


# use 'shift' for pure flags and 'shift 2' for parameters

VERBOSE=false
DEBUG=false
INTERN=
EXTERN=
MODE=
PRIMARY=1

while true; do
  case "$1" in
    -v | --verbose ) VERBOSE=true; shift ;;
    -d | --debug ) DEBUG=true; shift ;;
    -p | --primary) PRIMARY=2; shift ;;
    -i | --internal ) INTERN="$2"; shift 2 ;;
    -e | --external ) EXTERN="$2"; shift 2 ;;
    -m | --mode ) MODE="$2"; shift 2 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

##################################
# Required program(s)
##################################

req_progs=(xrandr  )
for p in ${req_progs[@]}; do
  hash "$p" 2>&- || \
  { 
	error "Required program \"$p\" not installed."; exit 1; }
done

######################################
# Check Parameters

#shift $(($OPTIND-1))


if [ -z "$INTERN" ]; then
	if [ -n $1 ]; then
		INTERN="$1"
		shift
	else
        	error "ERROR: No internal monitor supplied"
		PrintUsage
	fi
fi
if [ -z "$EXTERN" ]; then
	if [ -n $1 ]; then
		EXTERN="$1"
	else
        	error "ERROR: No external monitor supplied"
		PrintUsage
	fi
fi


if [ -z "$MODE" ]; then
        error "ERROR: No mode specifiedd"
	PrintUsage
fi


if [ $PRIMARY -eq 2 ]; then
	TT="$INTERN"
	INTERN="$EXTERN"
	EXTERN="$TT"
	case $MODE in
		extendr|r)
			MODE="l"
		;;
		extendl|l)
			MODE="r"
		;;
	esac
fi

######################################################################
# Main
case $MODE in
  modes|m)
    xrandr -q
    ;;
  internal|i)
    $(xrandr --output "$INTERN" --auto --output "$EXTERN" --off)
    printf "$(pass $INTERN)"
    printf  "\t-> on \n"
    printf "$(pass $EXTERN)"
    printf  "\t-> off \n"
    ;;
  external|e)
    xrandr --output "$INTERN" --off --output "$EXTERN" --auto
    printf "$(pass $INTERN)"
    printf  "\t-> off \n"
    printf "$(pass $EXTERN)"
    printf  "\t-> on \n"
    ;;
  clone|c)
    CLONERES=`xrandr --query | awk '/^ *[0-9]*x[0-9]*/{ print $1 }' | sort | uniq -d | head -1`
    xrandr --output "$INTERN" --mode "$CLONERES" --output "$EXTERN" --same-as "$INTERN" --mode "$CLONERES"
    echo  "Cloning: "$(pass $INTERN) "=" $(pass $EXTERN)    
    ;;
  extendl|l)
    xrandr --output "$EXTERN" --auto  --output "$INTERN" --primary --auto --left-of "$EXTERN"
    echo ""$(pass $INTERN)* "|" $(pass $EXTERN)
    ;;
  extendr|r)
    xrandr --output "$EXTERN" --auto --output "$INTERN" --primary --auto --right-of "$EXTERN"
    echo ""$(pass $EXTERN) "|" $(pass $INTERN)*
    ;;
  *)
    error "No valid mode"
    PrintUsage
    ;;
esac

