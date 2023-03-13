# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob nomatch notify
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/svordy/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Title
precmd () { print -Pn "\e]0;$TITLE\a" }
title() { export TITLE="$*" }
# Right Prompt
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{240}(%b)%r%f'
zstyle ':vcs_info:*' enable git
# Prompt
PROMPT='%(?.%F{green}√.%F{red}X)%f %F{yellow}%5~%f %# '
# Path
path+=~/bin
path+=~/work/tools
export PATH
# Default editor
export EDITOR='nvim'
export VISUAL='nvim'
# history search
bindkey "$key[Up]" history-beginning-search-backward
bindkey "$key[Down]" history-beginning-search-forward

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
