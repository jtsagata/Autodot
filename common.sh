# shellcheck shell=bash
# shellcheck disable=SC2034,SC1091
#SCRIPT_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
SCRIPT_DIR="${HOME}/.asfodelus"

function path_add () {
    if ! echo "$PATH" | /bin/grep -Eq "(^|:)$1($|:)" ; then
        if [ "$2" = "after" ] ; then
            PATH="$PATH:$1"
        else
            PATH="$1:$PATH"
        fi
    fi
}

source "${SCRIPT_DIR}/terminal.sh"

path_add "${HOME}/.asfodelus/scripts"



# Pico
export PICO_SDK_PATH=~/micro/pico/pico-sdk
export PICO_EXAMPLES_PATH=~/micro/pico/pico-examples
export PICO_EXTRAS_PATH=~/micro/pico/pico-extras
export PICO_PLAYGROUND_PATH=~/micro/pico/pico-playground
export FREERTOS_KERNEL_PATH=~/micro/FreeRTOS
export FREERTOS_KERNEL_SMP_PATH=~/micro/FreeRTOS-smp

# Rust
source "$HOME/.cargo/env"

# Starship
function blastoff() {
    load_theme
	echo -ne "\033]0; $(basename "$PWD") \007"
}

starship_precmd_user_func="blastoff"

# A nice prompt
eval "$(starship init "${TERMINAL_SHELL}")"

# z command not cd
eval "$(zoxide init "${TERMINAL_SHELL}")"

# Support .env, .envrc
eval "$(direnv hook "${TERMINAL_SHELL}")"

alias ls='lsd'
alias powerman='tio -b 57600 /dev/ttyUSB0'
alias psc='ps xawf -eo pid,user,cgroup,args'

function make_script() {
    local script=${1-new_tool}
    printf "#!/usr/bin/env bash\n\n" >> "$script"
    chmod +x "$script"
}

function pico_load() {
    openocd -f interface/picoprobe.cfg -f target/rp2040.cfg -c "program $1 verify reset exit"
}
