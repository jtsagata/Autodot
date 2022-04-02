#!/usr/bin/env bash
script_dir="$(cd "$(dirname "${BASH_SOURCE[${__b3bp_tmp_source_idx:-0}]}")" && pwd)"

rm ${HOME}/.bashrc
rm ${HOME}/.zshrc
rm ${HOME}/.gitconfig

ln ${script_dir}/bashrc    ${HOME}/.bashrc
ln ${script_dir}/zshrc     ${HOME}/.zshrc
ln ${script_dir}/gitconfig ${HOME}/.gitconfig

mkdir -p ~/.config 
ln  ${script_dir}/configs/starship.toml ~/.config