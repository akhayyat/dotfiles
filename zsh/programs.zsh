#
# Program-specific settings
#

# virtualenvwrapper
export VIRTUAL_ENV_DISABLE_PROMPT=1
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

# ls
eval "$(dircolors)"
# use lsd if installed
if [ -x "$(which lsd)" ]; then
    alias ls="lsd --group-dirs first"
    alias lt="ls --tree"
else
    alias ls="ls --color=auto --group-directories-first"
fi
alias l=ls
alias lh="ls -lh"
alias ll="ls -l"
alias la="ls -A"
alias lla="ls -lA"

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

# broot: directory tree navigator
if [ -r ~/.config/broot/launcher/bash/br ]; then
    source ~/.config/broot/launcher/bash/br
fi
