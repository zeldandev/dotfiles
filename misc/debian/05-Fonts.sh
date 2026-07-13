#!/bin/bash

#Check if script is run as Root
if [[ $EUID -ne 0 ]]; then
    echo "you must be a root user to run this script. -> use sudo" 2>&1
    exit 1
fi

echo "[-] Downloading fonts ...."

declare -a fonts=(
    FiraCode
    FiraMono
    Hack
    JetBrainsMono
    Meslo
    RobotoMono
    SourceCodePro
    SpaceMono
    Ubuntu
    UbuntuMono
    Iosevka
)
version='2.2.1'

#On Debian:
# /usr/local/share/fonts/ to install fonts system-wide
# ${HOME}/.local/share/fonts or ~/.fonts to install fonts just for the current user
fonts_dir="/usr/local/share/fonts/"

if [[ ! -d "$fonts_dir" ]]; then
    mkdir -p "$fonts_dir"
fi

for font in "${fonts[@]}"; do
    zip_file="${font}.zip"
    download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/${zip_file}"
    echo "Downloading $download_url ..."
    wget "$download_url"
    unzip -n "$zip_file" -d "$fonts_dir"
    rm "$zip_file"
done

#remove windows version for all fonts
cd "$fonts_dir"
rm *Windows*
cd ~

# siji for icons:
echo "+ Cloning siji from git..."
git clone https://github.com/stark/siji && cd siji && ./install.sh

# install fontAwesom for icons:
echo "Installing FontAwesome from apt..."
apt install -y fonts-font-awesome

#reset fonts cache
fc-cache -vf
