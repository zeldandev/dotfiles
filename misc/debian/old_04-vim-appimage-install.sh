#!/bin/bash

# In debian 12 we can find version 0.7.2 in official apt repositories
# I preffer more up to date version so I will take last appimage version

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage

APPIMAGE_DIR="$HOME/.local/appimage"

#Copy appimage to local folder (this folder should be in path variable)
mkdir -p "$APPIMAGE_DIR"

mv nvim.appimage "$APPIMAGE_DIR/nvim"

if command -v tree & >  /dev/null
then
  tree -L 3 "$APPIMAGE_DIR"
else
  ls -la "$APPIMAGE_DIR"
fi

#Install dependencies for lsp plugin

npm i -g pyright
