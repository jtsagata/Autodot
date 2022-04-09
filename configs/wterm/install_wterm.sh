#!/usr/bin/env bash
script_dir=$(realpath "$(dirname "${BASH_SOURCE[0]}")")

function cmd_system() {
    echo "TODO:"
}

function cmd_local() {
    cp jview.desktop  ${HOME}/.config/autostart
    cp desklets.desktop  ${HOME}/.config/autostart
    ln ${script_dir}/bottom.toml  ${HOME}/.config/bottom/bottom.toml
    mkdir -p ${HOME}/.config/wezterm
    ln ${script_dir}/wezterm.lua  ${HOME}/.config/wezterm/wezterm.lua
}

### Run the command
command=${1-help}
shift || true
func=cmd_"${command}"
if [ "$(type -t "$func")" == "function" ]; then
    $func "$@"
else
    printf "Unknown command %s\n" "$command"
    cmd_help
fi
