#!/bin/bash

#
# DESC: Install Nerd fonts
#   https://github.com/ryanoasis/nerd-fonts/
#   https://github.com/ryanoasis/nerd-fonts/releases/tag/v2.1.0
#

nerd_fonts=(
   	'UbuntuMono'
 	'AnonymousPro'
 	'FiraCode'
 	'FiraMono'
 	'Hack'
 	'Inconsolata'
 	'OpenDyslexic'
 	'Tinos'
 	'Ubuntu'
 	'SourceCodePro'
 	'LiberationMono'
)


reset=`tput sgr0`

 red=`tput sgr0; tput setaf 1`
bRed=`tput bold; tput setaf 1`
rRed=`tput rev;  tput setaf 1`

 green=`tput sgr0; tput setaf 2`
bGreen=`tput bold; tput setaf 2`
rGreen=`tput rev;  tput setaf 2`

#pkg_install curl curl


function install_nerd_font() {
	font=$1
	base_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/"
	font_url="${base_url}${font}.zip"
	font_path="${HOME}/.local/share/fonts/${font}"

	echo "${green}Installing font: ${bold}${font}${reset}"
	if [ ! -d ${font_path} ] ; then
		mkdir -p ${font_path}
		curl -L ${font_url} -o "${font_path}/${font}.zip"
		(yes | unzip "${font_path}/${font}.zip" -d ${font_path}) > /dev/null
		rm "${font_path}/${font}.zip"
		fc-cache
	else
		echo "${yellow}Skipping directory ${font_path} exists.${reset}"
	fi
}

for i in "${nerd_fonts[@]}"; do
    install_nerd_font "$i"
done


echo -e "\n Test: " 
echo -e  "\n${green}Your monospace font is:\n${bold}" \
         $(gsettings get org.gnome.desktop.interface monospace-font-name) \
         "\n${green}Be sure to change the setting of the terminal font ${reset}"

