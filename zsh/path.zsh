#
# PATH
#

# Correct commands
setopt correct

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
fi

# rust
export PATH=$HOME/.cargo/bin:$PATH

# snap
if [ -d /snap/bin ]; then
    export PATH=$PATH:/snap/bin
fi
