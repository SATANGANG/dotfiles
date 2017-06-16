# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="avit"
#ZSH_THEME="fishy"
#ZSH_THEME="frisk"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

DISABLE_CORRECTION="true"
DISABLE_AUTO_TITLE="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git mercurial symfony symfony2 tmux laravel5 vi-mode history-substring-search zsh-autosuggestions)

# custom plugins:
# https://github.com/zsh-users/zsh-autosuggestions
# configuration in custom directory

source $ZSH/oh-my-zsh.sh

# Customize to your needs...#
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.composer/vendor/bin" ] ; then
    PATH="$HOME/.composer/vendor/bin:$PATH"
fi

alias h='history'
alias :q='exit'
alias mc='mc -S modarin256'

# http://phpbrew.github.io/phpbrew/
[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc

export EDITOR=vim

if [[ ( -f ~/.dircolors ) && ( -x "$(command -v dircolors)" ) ]] ; 
then 
    eval $(dircolors ~/.dircolors)
fi

