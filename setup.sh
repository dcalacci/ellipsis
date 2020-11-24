#!/usr/bin/env bash
set -e
DIR=$(PWD)

read -rep "Do you want to install apps? (y/n) " -n 1
APPS=$REPLY

read -rep "Do you want to link from ~/docs ? (y/n) " -n 1
DOCS=$REPLY

# CASKSS & APPS -------------------------------
if [[ $APPS =~ ^[Yy]$ ]]; then
    brew cask install ngrok android-studio osxfuse keybase java mactex-no-gui postgres r rstudio sketch slack visual-studio-code vlc xquartz gqrx firefox chromium docker
    brew install skhd yabai ncdu stunnel pyenv wget git-lfs neovim fzf
    git lfs install
fi

# node / nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.0/install.sh | bash

# GIT ---------------------------------
echo "Installing git and git-lfs..."
mkdir -p ~/.config/git

ln -sf $DIR/git/gitconfig ~/.gitconfig
ln -sf $DIR/git/gitignore ~/.config/git/ignore

# BASH  -----------------------------------
echo "Setting bash settings..."
mkdir -p ~/.config/git
ln -sf $DIR/bash/bash_profile ~/.bash_profile
ln -sf $DIR/bash/bashrc ~/.bashrc
ln -sf $DIR/bash/inputrc ~/.inputrc

# TMUX --------------------
ln -sf $DIR/tmux/tmux.conf ~/.tmux.conf

## BINARIES ----------------
ln -sf $DIR/bin ~/.bin

# VIM ----------------------------------
echo "Linking NeoVim config..."
ln -sf $DIR/vim/init.vim ~/.config/nvim/init.vim
ln -sf $DIR/vim/coc-settings.json ~/.config/nvim/coc-settings.json

# overwrite vi executables
#sudo rm /usr/bin/vi
#sudo rm /usr/bin/vim
#sudo ln -s /usr/local/bin/nvim /usr/bin/vi
#sudo ln -s /usr/local/bin/nvim /usr/bin/vim

rm -rf ~/.vim
## TODO: install minpac? pathogen?
# push w/o logging in
#ssh -vT git@github.com


## KITTY --------------
mkdir -p ~/.config/kitty
ln -sf $DIR/kitty/kitty.conf ~/.config/kitty/kitty.conf

## TOOLS -----------------------------
# fzf
echo "Installing fzf..."
echo "Say NO to auto-completion for performance"
#git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
#~/.fzf/install

# ranger
ln -sf $DIR/ranger/rc.conf ~/.config/ranger/rc.conf
ln -sf $DIR/ranger/rifle.conf ~/.config/ranger/rifle.conf
ln -sf $DIR/ranger/scope.sh ~/.config/ranger/scope.sh

# window manager
echo "Creating yabai and skhd dotfiles..."
ln -sf $DIR/wm/yabairc ~/.yabairc
ln -sf $DIR/wm/skhdrc ~/.skhdrc


# PYTHON -----------------------------------
# ipython settings
mkdir -p ~/.ipython/profile_default
ln -sf $DIR/python/ipython_config.py ~/.ipython/profile_default/ipython_config.py

# pyvenv

read -rep "Do you want to reinstall and remove all pyenvs? (y/n) " -n 1
PYENV=$REPLY
if [[ $PYENV =~ ^[Yy]$ ]]; then
    rm -rf ~/.pyenv
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
    # activate pyenv
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    if command -v pyenv 1>/dev/null 2>&1; then
      eval "$(pyenv init -)"
      eval "$(pyenv virtualenv-init -)"
    fi
fi

if [[ $DOCS =~ ^[Yy]$ ]]; then
    mkdir -p ~/.ssh
    ln -sf ~/docs/ssh/config ~/.ssh/config
    ln -sf ~/docs/keys/id_rsa.pub ~/.ssh/id_rsa.pub
    ln -sf ~/docs/keys/id_rsa ~/.ssh/id_rsa
    ln -sf ~/docs/keys/mailbox ~/.ssh/mailbox
    ln -sf ~/docs/keys/mailbox.pub ~/.ssh/mailbox.pub
fi

if [ ! -f /etc/environment ]; then
    # Create an empty env file.
    echo "Creating an empty environment variables file at /etc/environment..."
    sudo touch /etc/environment
fi

brew services start skhd yabai
