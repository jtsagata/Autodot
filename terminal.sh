#!/usr/bin/env bash

# Normalize terminal name
if [[ "${TERMINAL_EMULATOR}" == "JetBrains-JediTerm" ]]; then
    terminal_program="JetBrains"
elif [[ "${TERM_PROGRAM}" == "vscode" ]]; then
     terminal_program="vscode"
elif [[ "${TERM_PROGRAM}" == "WezTerm" ]]; then
     terminal_program="WezTerm"
elif [[ -v INSIDE_NAUTILUS_PYTHON ]]; then
     terminal_program="nautilus"
else
    terminal_program="gnome"
fi

function theme_info(){
    local theme
    theme=$(dconf read /org/gnome/desktop/interface/gtk-theme | tr -d "'")
    echo "Terminal: '${terminal_program}'"
    echo "Shell:    '${terminal_shell}'"
    echo "Theme:    '${term_theme}'"
    echo "Gnome:    '${theme}'"
}

function load_last_theme() {
    theme=$(theme.sh -l|tail -n1)
    ${automation_dir}/extras/theme.sh "$theme"
    export TERMINAL_THEME=$theme
}

function load_theme(){
    local theme=$(dconf read /org/gnome/desktop/interface/gtk-theme)
    if [[ "${theme}" =~ dark ]]; then
        term_theme=$(jq -r ".${terminal_program}.night" < "${automation_dir}/terminal.json")
        alias mc='mc --skin=seasons-winder16M'
    else 
        term_theme=$(jq -r ".${terminal_program}.day" < "${automation_dir}/terminal.json")
        alias mc='mc --skin=seasons-summer16M'
    fi
    # TODO: Add fallback 
    ${automation_dir}/extras/theme.sh "${term_theme}"
}

load_theme
