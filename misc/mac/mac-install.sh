#!/bin/bash

##https://sourabhbajaj.com/mac-setup/SystemPreferences/
xcode-select --install

## install brew:

mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew

######
# Edit ~/.profile to include
# add:
# export PATH=$HOME/homebrew/bin:$PATH

#Browsers
brew install --cask firefox
# brew install --cask opera

# Editors
brew install --cask intellij-idea-ce
brew install --cask visual-studio-code
brew install --cask eclipse-jee
brew install --cask android-studio
brew install --cask dbeaver-community

# Utilities
brew install --cask postman
brew install --cask authy
brew install --cask sourcetree
brew install --cask rancher
brew install --cask iterm2
brew install --cask kitty
brew install postgresql
brew install starship
brew install zoxide
brew install git-delta
brew install fd
brew install dust
brew install lazygit

# Prductivity
brew install --cask clipy
brew install --cask alfred
brew install --cask flameshot #screenshots

# Terminal
brew install bat
brew install neovim
brew install awscli
brew install tree
brew install fzf
brew install ack
brew install python
brew install stow
brew install lsd


#nvim NvChad 
#https://nvchad.github.io/quickstart/install
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim

#emacs dependencies
brew tap d12frosted/emacs-plus
brew install emacs-plus --HEAD --with-modern-icon
#brew install --cask emacs
brew install cmake ripgrep coreutils fd
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
~/.emacs.d/bin/doom install
# set emacs in paht '$HOME/.emacs.d/bin'
doom sync
#to sync doom plugins


    # brew install nvm
    ## add in .zprofile following:
    # NVM
    # export NVM_DIR=~/.nvm
    # source $(brew --prefix nvm)/nvm.sh
    ## restar terminal
    # nvm install -lts


# Fonts
brew tap homebrew/cask-fonts && brew install --cask font-inconsolata-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-ubuntu-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-fira-code-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-jetbrains-mono-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-meslo-lg-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-hack-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-iosevka-nerd-font


# config aws
# you must create folder .aws and files .aws/credentials .aws/config in order to conect with localstack and start micros
aws configure
aws configure set region eu-west-1 --profile default
