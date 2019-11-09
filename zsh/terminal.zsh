#
# Terminal Support
#

# set xterm title to user@host:pwd
function terminal_title() {
    print -Pn "\e]2;%n@%m:%~\a"
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd terminal_title
