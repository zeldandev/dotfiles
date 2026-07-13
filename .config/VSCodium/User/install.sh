#!/bin/bash

mac_vscode_folder=${HOME}'/Library/Application Support/Code/User'

if [ -d "$mac_vscode_folder" ]; then
  ln -s "$(pwd)"/* "$mac_vscode_folder"
  echo "Symlik to mac VSCode folder: $mac_vscode_folder"
fi


# Install extensions
if type codium &> /dev/null; then
  echo "Installing codium extensions.."
  cat ~/dotfiles/.config/VSCodium/User/extensions.txt |  xargs -L 1 codium --install-extension
elif type code &> /dev/null; then
  echo "Installing code extensions.."
  cat ~/dotfiles/.config/VSCodium/User/extensions.txt | xargs -L 1 code --install-extension
else
  echo "Command `code` not found!!"
  exit 1
fi
