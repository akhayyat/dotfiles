#
# Program-specific settings
#

# Correct commands
setopt correct

# ls
eval "$(dircolors)"
alias ls="ls --color=auto --group-directories-first"
alias l=ls
alias lh="ls -lh"
alias ll="ls -l"
alias la="ls -A"

# grep
alias grep='grep --color=auto'

# less
export LESS='-i -M -R -w -z-2'

# Set the less input preprocessor
# pless (pretty less) is less with syntax hilighting
# requies the source-highlight package
if (( $+commands[lesspipe] )); then
    export LESSOPEN='| /usr/bin/env lesspipe %s 2>&-'
    alias pless='LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s" less '
fi

# virtualenvwrapper
export VIRTUAL_ENV_DISABLE_PROMPT=1
fi

# pip
export PATH=~/.local/bin:$PATH

# rvm
if [ -x $HOME/.rvm/scripts/rvm ]; then
    source $HOME/.rvm/scripts/rvm
fi
export PATH=$HOME/.rvm/bin:$PATH

# grails
if [ -x $HOME/local/software/grails/bin/grails ]; then
   export GRAILS_HOME=$HOME/local/software/grails
   export PATH=$PATH:$GRAILS_HOME/bin
if [ -r /usr/share/bash-completion/completions/virtualenvwrapper ]; then
    source /usr/share/bash-completion/completions/virtualenvwrapper
fi

# Emacs
alias e="emacsclient -a '' -t"
alias ew="emacsclient -a '' -c --no-wait"

ediff() {
    if (($+2)); then
        emacs --eval "(ediff-files \"$1\" \"$2\")"
    else
        echo "Usage: ediff <file-1> <file-2>"
    fi
}

# EDITOR
export EDITOR="emacsclient -a '' -t"
export VISUAL="emacsclient -a '' -t"

# Apt
upd() {
    echo "Reloading sources.."
    sudo aptitude update > /dev/null
    n=$(apt-show-versions -u | wc -l)
    echo "$n updates available"
}

# Global aliases
alias -g G="| grep -i"
alias -g L="| less -R"
alias -g C="| wc -l"
alias -g T="| tail"
