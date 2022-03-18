# shellcheck shell=bash
# shellcheck disable=SC2034,SC1091

function path_add () {
    if ! echo "$PATH" | /bin/grep -Eq "(^|:)$1($|:)" ; then
        if [ "$2" = "after" ] ; then
            PATH="$PATH:$1"
        else
            PATH="$1:$PATH"
        fi
    fi
}

if command -v theme.sh > /dev/null; then
    theme=$(theme.sh -l|tail -n1)
    theme.sh "$theme"
    export TERMINAL_THEME=$theme
    # echo "Theme: $theme" 
fi

# Pico
export PICO_SDK_PATH=/home/asfodelus/micro/pico/pico-sdk
export PICO_EXAMPLES_PATH=/home/asfodelus/micro/pico/pico-examples
export PICO_EXTRAS_PATH=/home/asfodelus/micro/pico/pico-extras
export PICO_PLAYGROUND_PATH=/home/asfodelus/micro/pico/pico-playground

# Rust
source "$HOME/.cargo/env"

# Starship
function blastoff() {
	echo -ne "\033]0; $(basename "$PWD") \007"
}

starship_precmd_user_func="blastoff"
eval "$(starship init "${TERMINAL_SHELL}")"

eval "$(zoxide init "${TERMINAL_SHELL}")"

# echo "On ${TERMINAL_SHELL}"

alias ls='lsd'
alias cat='bat'
alias powerman='tio -b 57600 /dev/ttyUSB0'
alias psc='ps xawf -eo pid,user,cgroup,args'
