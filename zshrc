# $PATH {{{
# /etc/paths: /usr/local/bin /usr/bin /bin /usr/sbin /sbin
# export PATH="/opt/CHARMM/c38b2/exec/osx/:$PATH"               # <-- CHARMM
# export PATH="/Developer/NVIDIA/CUDA-9.1/bin:$PATH"            # <-- CUDA
# export PATH="/Applications/moe2018/bin:$PATH"                 # <-- Moe2018
# export PATH="$HOME/.iterm2:$PATH"                             # <-- iterm2
# export PATH="$HOME/bin:$PATH"                                 # <-- ~/bin
export PATH="$HOME/usr/bin:$PATH"                             # <-- personal stuff
export PATH="$HOME/.cargo/bin:$PATH"                          # <-- cargo
export PATH="$HOME/.luarocks/bin:$PATH"                       # <-- LuaRocks
# export PATH="$HOME/.gem/ruby/2.3.0/bin:$PATH"                 # <-- ruby gem
export PATH="$PATH:/opt/homebrew/lib/ruby/gems/3.3.0/bin"
export PATH="$HOME/.npm-packages/bin:$PATH"                   # (node installer) npm config set prefix "${HOME}/.npm-packages"
# export PATH="$HOME/.yarn/bin:$PATH"                           # <-- yarn (node)
export PATH="$HOME/go/bin:$PATH"                              # <-- go
export PATH="$HOME/.local/bin:$PATH"                          # <-- local/bin
# source "$HOME/opt/anaconda3/etc/profile.d/conda.sh"  # commented out by conda initialize
export PATH="~/bin:$PATH"                                  # <-- personal stuff
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"            # <-- MacPorts
export PATH="/opt/local/libexec/gnubin:$PATH"                 # <-- Coreutils

export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64"
export CUDA_HOME="/usr/local/cuda"

# add android tools
# FOR OSX ONLY
# TODO: Check if on OSX
#export PATH="$HOME/Library/Android/sdk/platform-tools/:$PATH"
#export PATH="$HOME/Library/Android/sdk/tools/bin/:$PATH"

#export PATH="$PATH:$HOME/src/flutter/bin"

#export PATH="/opt/homebrew/bin:$PATH"


# ZSH init {{{
export ZSH="$HOME/.zsh"
ZSH_CACHE_DIR="$ZSH/cache"
fpath=($ZSH/functions $ZSH/completions $fpath)

source $ZSH/options.zsh
source $ZSH/keybindings.zsh
source $ZSH/completions.zsh
source $ZSH/aliases.zsh
source $ZSH/functions.zsh
source $ZSH/prompt.zsh
# }}}

# Plugins {{{
# TODO: overhaul:
# check zplug for plugin management
# macports can install syntax highlighting and zsh-completions
# check https://starship.rs/guide/#%F0%9F%9A%80-installation
# check esc/conda-zsh-completion
# check git prompt at https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
# or use vcs_info zsh builtin module
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
source "${ZINIT_HOME}/zinit.zsh"

# autoload -Uz _zinit
# (( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust
### End of Zinit's installer chunk

zinit ice as"completion"; zinit snippet 'https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker'
zinit ice mv"zsh_completion.tpl -> _pandoc" as"completion"; zinit snippet 'https://gist.githubusercontent.com/doronbehar/134d83ae75309182d9fad8ecd7a55daa/raw/665108d3d4aa72f978fee1de10401e52e4cc54b6/zsh_completion.tpl'
zinit load hlissner/zsh-autopair
zinit load bric3/oh-my-zsh-git
# zinit load srijanshetty/zsh-pandoc-completion
zinit light esc/conda-zsh-completion
zinit ice blockf; zinit light zsh-users/zsh-completions
zinit light zdharma-continuum/fast-syntax-highlighting
# }}}

# plugin Opts {{{
# omg_prefix=" %{%B%F{white}%}%{%f%k%b%}"
omg_suffix=" %{%B%F{white}%}  %{%f%k%b%}"
is_a_git_repo_symbol=" "
has_modifications_symbol=
has_modifications_color="%F{yellow}"
has_untracked_files_symbol=
ready_to_commit_symbol=
should_push_symbol=
detached_symbol=
print_unactive_flags_space=false
#                  
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:wrap"
# export FZF_CTRL_T_OPTS=""
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
export FZF_DEFAULT_COMMAND="fd --follow --hidden --color=always" #--ignore-file=$HOME/.gitignore"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="$(echo \
"--ansi \
--no-height \
--preview '[[ \$(file --mime {}) =~ directory ]] && tree -C {} || { [[ \$(file --mime {}) =~ image ]] && catimg {}; } || { [[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file; } || bat --color=always --style=numbers,changes,snip {}' \
--preview-window wrap:hidden \
--border --margin=0,2 \
--bind 'ctrl-o:toggle-preview' \
--bind 'tab:down' \
--bind 'btab:up' \
--bind 'ctrl-z:toggle' ")"
# }}}

# User configuration {{{

# prompt
export PS1="$prompt_2short" # Set in $ZSH/prompt.zsh
export RPROMPT='$(oh_my_git_info)'

# ls colors
export CLICOLOR=1
autoload -U colors && colors
# export LSCOLORS="Gxfxcxdxbxegedabagacad"
# export LSCOLORS=ExFxBxDxCxegedabagEgGx
# eval "$(dircolors -b)" # coreutils tool, exports LS_COLORS moved in $ZSH/completions.zsh

# History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=10000
export HISTFILESIZE=-1

# programs env opts
# export SCHRODINGER="/opt/schrodinger/suites2021-4"
# export SCHRODINGER_ALLOW_UNSAFE_MULTIPROCESSING=1 #FUCK OFF
# export PYMOL4MAESTRO="/opt/anaconda3/envs/pymol/bin/"
# export ILOG_CPLEX_PATH="/Applications/IBM/ILOG/CPLEX_Studio128"
# export JULIA_PKGDIR="/Users/laurenzi/.julia"
export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket
# export SCHRODINGER_SCRIPTS="$HOME/usr/src/schrodinger_utils/scripts"
# export XLSCRIPTS="$HOME/usr/src/xlence_scripts"
# export BIOTOOLS="$HOME/usr/src/BioTools"
# export PTPYTHON_CONFIG_HOME="$HOME/.config/ptpython"

# language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR=nvim
export PAGER=less
export VISUAL=nvim
export LESS=-R
# export MANPAGER=most

# Compilation flags
# export CPPFLAGS="-I/opt/local/include"
# export LDFLAGS="-L/opt/local/lib"
# export DYLD_LIBRARY_PATH="/usr/local/cuda/lib:$DYLD_LIBRARY_PATH"
# export QT_API="pyqt5"
# export CXX="/opt/local/bin/clang++"
# export CC="/opt/local/bin/clang"

#XCODE CTL SOURCES
# /Applications/Xcode.app/Contents/Developer
# /Library/Developer/CommandLineTools
# e.g.: xcode-select --switch /Library/Developer/CommandLineTools


# ssh
export SSH_KEY_PATH="$HOME/.ssh/rsa_id"

# XDG
export XDG_CONFIG_HOME="$HOME/.config/"

# nvm
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# # init conda based on arch
# source ~/attic/custrc/.condarc
# if [[ $(uname -m) == 'x86_64' ]]; then
#     init_conda_intel
#     echo "conda x86_64 is activated"
#     # uncomment following line if using homebrew
#     # eval "$(/usr/local/bin/brew shellenv)"
# else
#     init_conda
#     echo "conda m1 is activated"
#     # uncomment following line if using homebrew
#     # eval "$(/opt/homebrew/bin/brew shellenv)"
# fi

# [[ -z $TMUX ]] || conda deactivate; conda activate base       #   + TMUX fix


# }}}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/dcalacci/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/dcalacci/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/dcalacci/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/dcalacci/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
# __conda_setup="$('/Users/dcalacci/minconda3_x86/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/Users/dcalacci/minconda3_x86/etc/profile.d/conda.sh" ]; then
#         . "/Users/dcalacci/minconda3_x86/etc/profile.d/conda.sh"
#     else
#         export PATH="/Users/dcalacci/minconda3_x86/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<
# [[ -z $TMUX ]] || conda deactivate; conda activate base       #   + TMUX fix

# Johnny Decimal
# autoload -Uz compinit
# compinit
# export JOHNNYDECIMAL_BASE="/Users/dcalacci/google-drive"
# source ~/src/zsh-johnnydecimal/johnnydecimal.zsh

# }}}

# Functions {{{

function google {
    open "https://www.google.com/search?q=$*"
}

function lessc {
  pygmentize -O style=gruvbox -f terminal16m -g $1 | less
}

function tedit {
  tmux splitw 'zsh -lic "nvim "'$@'; read'
}

function cythonsetup {
  local exts=("$@")
  cat << EOF > setup.py
from setuptools import setup
from Cython.Build import cythonize

extensions = "${exts[@]}".split()
setup(
    ext_modules = cythonize(extensions, language_level = "3")
)
EOF
  bash -c 'read -p "Build? [y/n] " input
  if [[ $input = "y" ]]; then 
    python setup.py build_ext --inplace
  fi'
}

function pman {
  tmux display-popup -KR "man $@"
}
# }}}

# Aliases {{{
# see $ZSH/aliases.zsh

alias fz="cd \$(z | awk '{print \$2}' | fzf)"
alias tflip='echo "(╯°□°)╯︵ ┻━┻"'
alias clock='tty-clock -c -f %d-%m-%Y'
alias vim=nvim
alias ptpy='ptipython'
alias fuck='killall -9'

# }}}

# compinit / compdef {{{
autoload -Uz compinit
compinit -i
zinit cdreplay -q
# }}}

# other sources  {{{
# source /opt/local/etc/profile.d/z.sh
source ~/.fzf.zsh
eval "$(kitty +complete setup zsh)"
eval "$(pip completion --zsh)"
# }}}

# Remove duplicates from PATH (Unique)
typeset -U path

# MANPATH Guard
unset MANPATH

# zprof

# vim:set et sw=2 ts=2 fdm=marker:


# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk


# pnpm
#export PNPM_HOME="/Users/dcalacci/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end


## I think only for mac?
export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"

export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include"
export PATH="/opt/homebrew/opt/openssl@1.1/bin:$PATH"


export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"
export PKG_CONFIG_PATH="/opt/homebrew/opt/sqlite/lib/pkgconfig"
export LDFLAGS="-L/opt/homebrew/opt/sqlite/lib"
export CPPFLAGS="-I/opt/homebrew/opt/sqlite/include"
export PATH="/opt/homebrew/sbin:$PATH"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

. /opt/homebrew/opt/asdf/libexec/asdf.sh

. /opt/homebrew/opt/asdf/libexec/asdf.sh
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/dcalacci/bin/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/dcalacci/bin/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/dcalacci/bin/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/dcalacci/bin/google-cloud-sdk/completion.zsh.inc'; fi
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"


# Load Angular CLI autocompletion.
source <(ng completion script)
