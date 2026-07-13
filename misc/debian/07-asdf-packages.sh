#!/bin/bash

# asdf useful commands:
# `asdf list` (list installed plugins)
# `asdf list-all <plugin-name>` (list available verision to install)

if command -v asdf >/dev/null 2>&1; then
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  asdf install nodejs latest
  asdf set -u nodejs latest

  asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
  asdf install golang latest
  asdf set -u golang latest

  asdf plugin add python https://github.com/asdf-community/asdf-python.git
  asdf install python 3.13.1
  asdf set -u python 3.13.1

  asdf plugin add java https://github.com/halcyon/asdf-java.git
  asdf install java latest:adoptopenjdk-21
  asdf set -u java latest:adoptopenjdk-21
else
  echo "Error asdf comand not found!"
  exit 1
fi
