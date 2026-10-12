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


# Homebrew {{{
# Must come before anything that looks for brew-installed binaries.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
# }}}

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
if [[ ! -f "${ZINIT_HOME}/zinit.zsh" ]]; then
  print -P "%F{yellow}zinit is missing. Run: ~/attic/ellipsis/setup.sh --shell%f"
else
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
fi
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
export EDITOR=vim
export PAGER=less
export VISUAL=vim
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
# Originally generated by 'conda init'; de-hardcoded so it works on any
# machine and stays quiet when miniforge isn't installed.
CONDA_PREFIX_DIR="$HOME/miniforge3"
if [ -x "$CONDA_PREFIX_DIR/bin/conda" ]; then
    __conda_setup="$("$CONDA_PREFIX_DIR/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    elif [ -f "$CONDA_PREFIX_DIR/etc/profile.d/conda.sh" ]; then
        . "$CONDA_PREFIX_DIR/etc/profile.d/conda.sh"
    else
        export PATH="$CONDA_PREFIX_DIR/bin:$PATH"
    fi
    unset __conda_setup

    [ -f "$CONDA_PREFIX_DIR/etc/profile.d/mamba.sh" ] && . "$CONDA_PREFIX_DIR/etc/profile.d/mamba.sh"
fi
unset CONDA_PREFIX_DIR
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
(( $+functions[zinit] )) && zinit cdreplay -q
# }}}

# other sources  {{{
# fzf keybindings + completion. The old `~/.fzf.zsh` install-script approach
# is gone; fzf 0.48+ ships its own shell integration. Older fzf doesn't know
# --zsh, so fall back to the brew-shipped scripts rather than erroring.
# Only in a real terminal: the integration installs zle widgets, and zle isn't
# available under `zsh -ic` without a tty, which makes it print warnings.
if (( $+commands[fzf] )) && [[ -t 0 ]]; then
  if fzf --zsh >/dev/null 2>&1; then
    source <(fzf --zsh)
  elif (( $+commands[brew] )); then
    _fzf_share="$(brew --prefix)/opt/fzf/shell"
    [[ -f "$_fzf_share/key-bindings.zsh" ]] && source "$_fzf_share/key-bindings.zsh"
    [[ -f "$_fzf_share/completion.zsh" ]] && source "$_fzf_share/completion.zsh"
    unset _fzf_share
  fi
fi
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
#eval "$(kitty +complete setup zsh)"
# }}}

# MANPATH Guard
unset MANPATH

# Machine-local tails {{{
# Everything below here used to be appended by installers over the years, with
# hardcoded /Users/dcalacci paths and unguarded `source` lines that made a
# fresh machine throw errors on every new shell. Rewritten to be conditional.

# brew keg-only libraries. BREW_PREFIX comes from the shellenv at the top.
if (( $+commands[brew] )); then
  BREW_PREFIX="$(brew --prefix)"
  for keg in openssl@3 sqlite ruby openjdk@17 libpq; do
    [[ -d "$BREW_PREFIX/opt/$keg/bin" ]] && path=("$BREW_PREFIX/opt/$keg/bin" $path)
  done
  [[ -d "$BREW_PREFIX/sbin" ]] && path=("$BREW_PREFIX/sbin" $path)

  # Build flags for anything that compiles against openssl/sqlite (R packages,
  # python wheels). Appended, not overwritten -- the old version clobbered.
  for keg in openssl@3 sqlite; do
    [[ -d "$BREW_PREFIX/opt/$keg/lib" ]] && {
      export LDFLAGS="${LDFLAGS:+$LDFLAGS }-L$BREW_PREFIX/opt/$keg/lib"
      export CPPFLAGS="${CPPFLAGS:+$CPPFLAGS }-I$BREW_PREFIX/opt/$keg/include"
      export PKG_CONFIG_PATH="${PKG_CONFIG_PATH:+$PKG_CONFIG_PATH:}$BREW_PREFIX/opt/$keg/lib/pkgconfig"
    }
  done
  unset keg
fi

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
[[ -d "$PNPM_HOME" ]] && path=("$PNPM_HOME" $path)

# asdf. 0.16 dropped asdf.sh for a Go binary, so handle both layouts.
if (( $+commands[brew] )) && [[ -f "$BREW_PREFIX/opt/asdf/libexec/asdf.sh" ]]; then
  . "$BREW_PREFIX/opt/asdf/libexec/asdf.sh"
elif (( $+commands[asdf] )); then
  [[ -d "${ASDF_DATA_DIR:-$HOME/.asdf}/shims" ]] && path=("${ASDF_DATA_DIR:-$HOME/.asdf}/shims" $path)
fi

# Google Cloud SDK
[[ -f "$HOME/bin/google-cloud-sdk/path.zsh.inc" ]] && . "$HOME/bin/google-cloud-sdk/path.zsh.inc"
[[ -f "$HOME/bin/google-cloud-sdk/completion.zsh.inc" ]] && . "$HOME/bin/google-cloud-sdk/completion.zsh.inc"

# envman
[[ -s "$HOME/.config/envman/load.sh" ]] && source "$HOME/.config/envman/load.sh"

# OpenClaw
[[ -f "$HOME/.openclaw/completions/openclaw.zsh" ]] && source "$HOME/.openclaw/completions/openclaw.zsh"

# Anything machine-specific that shouldn't be committed goes here.
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
# }}}

typeset -U path
export PATH

# vim:set et sw=2 ts=2 fdm=marker:
