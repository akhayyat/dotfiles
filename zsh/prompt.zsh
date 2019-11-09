#
# Prompt
#

# Add themes to $fpath
fpath=($ZSHROOT/themes(/FN) $fpath)

# Load and execute the prompt theming system
autoload -Uz promptinit && promptinit

# Activate theme
prompt akhayyat
