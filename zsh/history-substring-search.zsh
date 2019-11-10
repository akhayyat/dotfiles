#
# History Substring Search
#

source $ZSHROOT/history-substring-search/zsh-history-substring-search.zsh

bindkey "${key[Up]}"   history-substring-search-up
bindkey "${key[Down]}" history-substring-search-down
