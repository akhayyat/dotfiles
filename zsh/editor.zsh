#
# Command Line Editor
#

# Allow command line editing in an external editor.
autoload -Uz edit-command-line
zle -N edit-command-line

#
# Functions
#

# Inserts 'sudo ' at the beginning of the line.
function prepend-sudo {
    if [[ "$BUFFER" != su(do|)\ * ]]; then
        BUFFER="sudo $BUFFER"
        (( CURSOR += 5 ))
    fi
}
zle -N prepend-sudo

# Displays an indicator when completing.
function expand-or-complete-with-dots {
  print -Pn "%F{red}......%f"
  zle expand-or-complete
  zle redisplay
}
zle -N expand-or-complete-with-dots

# This was written entirely by Mikael Magnusson (Mikachu)
# Basically type '...' to get '../..' with successive .'s adding /..
function rationalise-dot {
    local MATCH # keep the regex match from leaking to the environment
    if [[ $LBUFFER =~ '(^|/| |      |'$'\n''|\||;|&)\.\.$' ]]; then
        LBUFFER+=/
        zle self-insert
        zle self-insert
    else
        zle self-insert
    fi
}
zle -N rationalise-dot

# Cycle through local history only
up-line-or-local-history() {
    zle set-local-history 1
    zle up-line-or-history
    zle set-local-history 0
}
zle -N up-line-or-local-history
down-line-or-local-history() {
    zle set-local-history 1
    zle down-line-or-history
    zle set-local-history 0
}
zle -N down-line-or-local-history

#
#  Key bindings
#

# Use Emacs editing mode, and recongize modifiers
bindkey -e

# C-right and C-left: jump words (human-friendly keys are not recognized!)
bindkey "^[[1;5C" emacs-forward-word
bindkey "^[[1;5D" emacs-backward-word

# Alt-S: insert 'sudo ' at the beginning of the line
bindkey "\es" prepend-sudo

# C-x C-e: edit the command line in an editor
bindkey "\C-x\C-e" edit-command-line

# Displays an indicator when completing
bindkey "\C-I" expand-or-complete-with-dots

# ... -> ../..
# Then, every subsequent . inserts /..
bindkey . rationalise-dot
# without this, typing a . aborts incremental history search
bindkey -M isearch . self-insert

# Ctrl-p/n cycles through local history only
bindkey '^p' up-line-or-local-history
bindkey '^n' down-line-or-local-history

# Bind Shift + Tab to go to the previous menu item.
bindkey "^[[Z" reverse-menu-complete
