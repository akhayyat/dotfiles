#
# Agents
#

# ssh and gpg agents
if [ -x /usr/bin/keychain ]; then
    eval $(keychain --eval --quick --quiet)
fi;
