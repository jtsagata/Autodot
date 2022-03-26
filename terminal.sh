#!/usr/bin/env bash
#SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SCRIPT_DIR="${HOME}/.asfodelus"

# Normalize terminal name
if [[ "${TERMINAL_EMULATOR}" == "JetBrains-JediTerm" ]]; then
    export TERMINAL_PROG="JetBrains"
elif [[ "${TERM_PROGRAM}" == "vscode" ]]; then
    export TERMINAL_PROG="vscode"
elif [[ -v INSIDE_NAUTILUS_PYTHON ]]; then
    export TERMINAL_PROG="nautilus"
else
    export TERMINAL_PROG="gnome"
fi

function debug_term(){
    local theme
    theme=$(dconf read /org/gnome/desktop/interface/gtk-theme | tr -d "'")
    echo "Terminal: '${TERMINAL_PROG}' using '${TERMINAL_SHELL}', with theme '${TERMINAL_THEME}/${theme}'"
}

function load_last_theme() {
    theme=$(theme.sh -l|tail -n1)
    theme.sh "$theme"
    export TERMINAL_THEME=$theme
}

function load_theme(){
    local term_theme
    local theme=$(dconf read /org/gnome/desktop/interface/gtk-theme)
    if [[ "${theme}" =~ dark ]]; then
        term_theme=$(jq -r ".${TERMINAL_PROG}.night" < "${SCRIPT_DIR}/terminal.json")
    else 
        term_theme=$(jq -r ".${TERMINAL_PROG}.day" < "${SCRIPT_DIR}/terminal.json")
    fi
    # TODO: Add fallback 
    theme.sh "${term_theme}"
    export TERMINAL_THEME="${term_theme}"
}

#load_last_theme
load_theme
#debug_term