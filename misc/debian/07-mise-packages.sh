#!/bin/bash

# mise useful commands:
# `mise ls` (list installed tools/versions)
# `mise ls-remote <plugin-name>` (list available versions to install)

if command -v mise >/dev/null 2>&1; then
  # mise use -g automatically adds the plugin and installs the version globally
  mise use -g nodejs@lts
  mise use -g go@latest
  mise use -g python@latest
  mise use -g java@21
else
  echo "Error mise command not found!"
  exit 1
fi
