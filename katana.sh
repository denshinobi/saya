#!/bin/bash
# katana.sh v1.2 — customized terminal session: stylized & colorized prompt, title taken in as argument, custom aliases, and safe cleanup on exit.
# Written by denshinobi_, art by denshinobi_ adapted from Alvin Sayanna & Krogg
# THIS SCRIPT MUST BE SOURCED, NOT EXECUTED!!! [run `source ./katana.sh <arg>`]

# Validate input: require one argument (ENGAGE string)
if [ "$#" -lt 1 ]; then
    printf "\033[0;31mERROR: needs argument...\033[0m\nUsage: source $0 <ENGAGEMENT Title>\n    Katana takes in the name of your\n    engagement or campaign as its argument.\n    Script must be sourced, not executed.\n    Please run again...\n\n"
    return 1 2>/dev/null || exit 1
fi

# Force argument(s) into string literal `$ENGAGE`
ENGAGE=""
for arg in "$@"; do
    ENGAGE+="$arg "
done
ENGAGE="${ENGAGE%" "}"

# Set color control for PS1
blackground="\[\033]11;#000000\007\]"
charcoal="\033[48;5;234m"
#
#                                                 /\                                     ____,....---~;
#                               /VVVVVVVVVVVVVVVVVA \-----------------=====^^^^^^^```````     ___,..~'
#                               `^^^^^^^^^^^^^^^^^^ /=========================---------^^^````
#                                        |((((0   \/                        |((((0
#                                        ||                                 ||
#
#
#
# Build PS1 Prompt
export PS1="${blackground}"                                                            # Set background color to blackish color
PS1+="${charcoal}\[\033[1;38;5;49m\]\n\nKatana\[\033[0m\]"                             # Katana in bold greenish-turquoise (#05FFAD ≈ 49) over color slice
PS1+="\n\[\033[1;36m\]${ENGAGE}\[\033[0m\]"                                            # Name of engageent, bold cyan
PS1+="\n\[\033[38;5;214m\]\d at \t\[\033[0m\]"                                         # Date, time, orange (214)
PS1+="\n\[\033[1;38;5;15m\]\u\[\033[0m\]"                                              # Username, bold white
PS1+="\[\033[38;5;15m\]@\h\[\033[0m\]\n\[\033[38;5;15m\]Command Number \#\[\033[0m\]"  # @, Hostname, command number, white
PS1+="\n\[\033[38;5;129m\]\w:\[\033[0m\] "                                             # Path and final colon, purple

# Handle environmental colors
export TERM=xterm-256color
export COLORTERM=truecolor
export CLICOLOR=1
export CLICOLOR_FORCE=1
alias grep='grep --color=auto'
export GREP_COLORS='mt=01;38;5;202'
export LS_COLORS='di=01;38;5;49:ln=01;38;5;39:so=01;38;5;130:pi=01;38;5;130:ex=01;38;5;197:bd=01;38;5;94:cd=01;38;5;94:su=01;38;5;208:sg=01;38;5;178:tw=01;38;5;136:ow=01;38;5;136:st=01;38;5;244:mi=01;38;5;160:or=01;38;5;196:ca=01;38;5;220:mh=01;38;5;246:'
# | Code | Type                          | Color Description         |                                __
# |------|-------------------------------|---------------------------|                               /=/
# | di   | Directory                     | 49 (turquoise-green)      |                              /=7
# | ln   | Symlink                       | 39 (cyan)                 |                             /=7
# | so   | Socket                        | 130 (burnt orange)        |                         ___/=Z_
# | pi   | Named pipe (FIFO)             | 130 (burnt orange)        |                        (_L_L_L_)
# | ex   | Executable                    | 197 (pink-red)            |                          / /
# | bd   | Block device                  | 94 (muted blue-grey)      |                         / /
# | cd   | Character device              | 94 (muted blue-grey)      |                        / /
# | su   | setuid executable             | 208 (bright orange)       |                       / /
# | sg   | setgid executable             | 178 (tan/yellow-orange)   |                      / /
# | tw   | Sticky + world-writable dir   | 136 (muted orange-brown)  |                     / /
# | ow   | World-writable dir            | 136 (muted orange-brown)  |                    / /
# | st   | Sticky-only dir               | 244 (soft grey)           |                   / /
# | mi   | Missing file (broken link)    | 160 (bright red)          |                  / /
# | or   | Orphan symlink (broken)       | 196 (intense red)         |                 / /
# | ca   | File with capability bits     | 220 (golden yellow)       |                /,'
# | mh   | Multi-hardlink file           | 246 (neutral grey)        |                `
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;38;5;39m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[38;5;246m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[04;38;5;81m'

# Custom Aliases
alias sheath="source ~/saya/sheath.sh"
alias alps="ls -alps"
alias input="read"

# 電忍者
