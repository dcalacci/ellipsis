#!/usr/bin/env bash
set -e

DIR=$(pwd)

read -rep "Are you on mac OS? (y/n) " -n 1
MAC=$REPLY


if [[ $MAC =~ ^[Yy]$ ]]; then
    read -rep "Are you on an M1 Mac? (y/n) " -n 1
    M1=$REPLY
fi

read -rep "Do you want to install apps? (y/n) " -n 1
APPS=$REPLY

read -rep "Do you want to link from ~/docs ? (y/n) " -n 1
DOCS=$REPLY

if [[ $M1 =~ ^[Yy]$ ]]; then
    echo "Installing rosetta and x86 Homebrew..."
    # /usr/sbin/softwareupdate --install-rosetta --agree-to-license
    arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

    sudo mkdir -p /opt/homebrew
    sudo chown -R $(whoami):staff /opt/homebrew
    cd /opt
    curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
    export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
    alias ibrew='arch -x86_64 /usr/local/bin/brew'
fi

# CASKS & APPS -------------------------------
if [[ $APPS =~ ^[Yy]$ && $MAC =~ ^[Yy]$ ]]; then

    brew install --cask ngrok android-studio osxfuse keybase mactex-no-gui postgres r rstudio sketch slack visual-studio-code vlc xquartz gqrx firefox chromium docker kitty zotero slack zoom discord obsidian arduino android-studio android-sdk figma
    brew install ncdu stunnel pyenv wget git-lfs neovim fzf
    brew install koekeishiya/formulae/skhd
    brew install koekeishiya/formulae/yabai
fi

if [[ $APPS =~ ^[Yy]$ && $MAC =~ ^[Nn]$ ]]; then
    sudo apt install git-lfs
fi

git lfs install

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

echo "Installing NVM and latest nodejs..."
# node / nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.0/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# install latest node
nvm install stable

npm install -g yarn expo-cli

# ZSH
echo "Installing oh-my-zsh and oh-my-git..."
ln -sf $DIR/zsh ~/.zsh
ln -sf $DIR/zshrc ~/.zshrc
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sh -c "$(curl -fsSL https://git.io/zinit-install)"
git clone https://github.com/arialdomartini/oh-my-git.git ~/.oh-my-git && echo source ~/.oh-my-git/prompt.sh >> ~/.profile

# TMUX --------------------
ln -sf $DIR/tmux/tmux.conf ~/.tmux.conf

## BINARIES ----------------
ln -sf $DIR/bin ~/.bin

# VIM ----------------------------------
echo "Linking NeoVim config..."
mkdir -p ~/.config/nvim
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
# echo "Say NO to auto-completion for performance"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/src/fzf
~/src/fzf/install
#git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
#~/.fzf/install

# ranger
mkdir -p ~/.config/ranger
ln -sf $DIR/ranger/rc.conf ~/.config/ranger/rc.conf
ln -sf $DIR/ranger/rifle.conf ~/.config/ranger/rifle.conf
ln -sf $DIR/ranger/scope.sh ~/.config/ranger/scope.sh


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
    cp ~/docs/ssh/config ~/.ssh/config
    cp ~/docs/keys/id_rsa.pub ~/.ssh/id_rsa.pub
    cp ~/docs/keys/id_rsa ~/.ssh/id_rsa
    cp ~/docs/keys/mailbox ~/.ssh/mailbox
    cp ~/docs/keys/mailbox.pub ~/.ssh/mailbox.pub

    chmod 600 ~/.ssh/id_rsa
    chmod 600 ~/.ssh/id_rsa.pub
    chmod 700 ~/.ssh
fi

if [ ! -f /etc/environment ]; then
    # Create an empty env file.
    echo "Creating an empty environment variables file at /etc/environment..."
    sudo touch /etc/environment
fi

if [[ $MAC =~ ^[Yy]$ ]]; then

    echo "Installing python on Mac with linked openssl..."
    # install python with linked openssl
    echo "Installing python 3.9.1"
    # CFLAGS="-I$(brew --prefix openssl)/include" \
    # LDFLAGS="-L$(brew --prefix openssl)/lib" \
    pyenv install -v 3.9.1

    # window manager for mac osx
    echo "Creating yabai and skhd dotfiles..."
    ln -sf $DIR/wm/yabairc ~/.yabairc
    ln -sf $DIR/wm/skhdrc ~/.skhdrc

    # change shell to bash
    chsh -s /bin/bash

    brew services start skhd 
    brew services start yabai
fi
