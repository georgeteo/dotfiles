# Dotfiles in home directory
DOTFILES="$HOME/Dotfiles"

# Deprecated (8/20/19)
# Prompt stuff
# setopt PROMPT_SUBST
#source ~/.prompt-zsh.sh

# Setup zplug plugin manager
if [ ! -d "$HOME/.zplug" ]; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh
fi
source ~/.zplug/init.zsh

zplug "djui/alias-tips", as:plugin, use:"*.zsh"  # alias tip for remembering alias
zplug "j-arnaiz/common-aliases", as:plugin, use:"*.zsh"  # commong aliases used

zplug "b4b4r07/enhancd", as:plugin, use:"init.sh" # cd anywhere

# Deprecated (8/20/19)
# zplug "zsh-users/zsh-syntax-highlighting", defer:3 # zsh command synctax highlighting
zplug "zdharma/fast-syntax-highlighting"

# explain linux commands
zplug "gmatheu/zsh-explain-shell", as:plugin, use:"explain-shell/zsh-explain-shell.zsh"

# Git prompts
# Deprecated (conditional on wfxr/forgit) (8/20/19)
# zplug "plugins/git",   from:oh-my-zsh  # useful git shortcuts
zplug 'wfxr/forgit'

# Prompt
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Compaudit for linux only
if [ "$(uname)" = "Linux" ]; then
  compaudit | xargs -r chmod g-w
fi
zplug load


# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Tell ls to be colourful
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad
export GREP_OPTIONS='--color=auto'
alias tmux="env TERM=xterm-256color tmux"

# Overwrite gti
alias gti=''
alias gcam='git commit -am'
alias gfgp='git fetch; git pull origin master'
alias gst='git status'
alias gp='git push origin $(git symbolic-ref HEAD --short)'

# Python
export PATH="/usr/local/bin:$PATH"

# Go
export GOPATH="$HOME/gocode"
export PATH="$PATH:$GOPATH/bin"
goclone() {
  mkdir -p $GOPATH/src/code.uber.internal/$1
  git clone gitolite@code.uber.internal:$1 $GOPATH/src/code.uber.internal/$1 --recursive
}

# Edit long command with vim
# autoload -U edit-command-line
# zle -N edit-command-line
# bindkey '^x^e' edit-command-line # ^xe to drop edit into vim
# bindkey -v  # vimmode
# export KEYTIMEOUT=1 # kill lag for esc
# # To fix backspace and ^h after returning from command mode
# bindkey '^?' backward-delete-char
# bindkey '^h' backward-delete-char

# History files
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt hist_ignore_all_dups
setopt hist_ignore_space

# Use vim as default
export EDITOR="nvim"

touch "$HOME/.localzshrc"
source ~/.localzshrc

# Remove zcompdump
# rm ~/.zcompdump* 2> /dev/null
# rm ~/.zplug/zcompdump 2> /dev/null
# brew analytics off 2>&1 >/dev/null
# Fix issue with Alacrity and corp laptop
# if [ "$(uname)" = "Darwin" ]; then
#   ls ~/.profile_* 1> /dev/null 2>&1 && for f in ~/.profile_*; do source $f; done
# fi
# [ -r /Users/gteo/.profile_lda ] && . /Users/gteo/.profile_lda
