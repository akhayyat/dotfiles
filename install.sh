#! /bin/sh

# define color codes
WHITE="\\033[1;37m"
BLUE="\\033[1;34m"
GREEN="\\033[0;32m"
RED="\\033[0;31m"
PURPLE="\\033[0;35m"
YELLOW="\\033[0;33m"
RST="\\033[m"

# create $2 as a symlink to $1 and verify that it actually is
link_and_check() {
    echo -n "${WHITE}${2#$HOME/}:${RST} "
    if [ -L $2 -a "$(readlink -f $2)" = "$1" ]
    then
        echo "${YELLOW}already installed!${RST}"
    else
        if [ ! -d $(dirname $2) ]
        then
            mkdir -p $(dirname $2)
        fi
        if [ -d $2 ]
        then
            echo "${PURPLE}NOT installed${RST} - directory exists"
            return 1
        else
            ln -sf $1 $2
            if [ -L $2 -a "$(readlink -f $2)" = "$1" ]
            then
                echo "${GREEN}installed successfully!${RST}"
            else
                echo "${PURPLE}NOT installed${RST} - something went wrong!"
                return 1
            fi
        fi
    fi
}

cd $(dirname $0)

# make sure ~/.dotfiles exists
# some dotfiles rely on that path
if [ "$PWD" != "$HOME/.dotfiles" ]
then
    link_and_check $PWD $HOME/.dotfiles
    if [ $? -ne 0 ]
    then
        echo "~/.dotfiles is required to be valid. Cannot continue"
        exit 1
    fi
fi

# dot files in the home directory
homefiles="screenrc emacs hgrc muttrc stalonetrayrc Xresources gtkrc-2.0"
for i in $homefiles
do
    link_and_check $PWD/$i $HOME/.$i
done

# desktop themes: openbox, gnome, gtk, icons, etc.
themes="ak"
for i in $themes
do
    link_and_check $PWD/themes/$i $HOME/.themes/$i
done

# special cases
link_and_check $PWD/zsh/zshrc             $HOME/.zshrc
link_and_check $PWD/openbox               $HOME/.config/openbox
link_and_check $PWD/gtk-3.0_settings.ini  $HOME/.config/gtk-3.0/settings.ini
link_and_check $PWD/gpg.conf              $HOME/.gnupg/gpg.conf

thunderbird_default_profile=$(ls -d $HOME/.thunderbird/*.default)
if [ -d $thunderbird_default_profile ]
then
    mkdir -p $thunderbird_default_profile/chrome
    link_and_check $PWD/thunderbird-userChrome.css $thunderbird_default_profile/chrome/userChrome.css
fi

firefox_default_profile=$(ls -d $HOME/.mozilla/firefox/*.default)
if [ -d $firefox_default_profile ]
then
    mkdir -p $firefox_default_profile/chrome
    link_and_check $PWD/firefox-userChrome.css $firefox_default_profile/chrome/userChrome.css
fi

# clone or update external repositories
update_hg_repo() {
    repo=$1
    dir=$2
    if [ "$3" ]; then rev="-r $3"; else rev=""; fi

    if [ ! -d "$dir"/.hg ]
    then
        hg clone $rev $repo $dir
    else
        hg -R $dir pull $rev
        hg -R $dir update $rev
    fi
}

update_git_repo() {
    repo=$1
    dir=$2
    if [ "$3" ]; then branch="-b $3"; ref=$3; else branch=""; ref=""; fi

    if [ ! -d "$dir"/.git ]
    then
        git clone $branch $repo $dir
    else
        git -C $dir pull --ff-only $repo $ref
    fi
}

update_hg_repo  https://bitbucket.org/sjl/hg-prompt                           hg/hg-prompt                   dc481ce24b60
update_git_repo https://github.com/zsh-users/zsh-history-substring-search.git zsh/history-substring-search
update_git_repo https://github.com/zsh-users/zsh-syntax-highlighting.git      zsh/syntax-highlighting
update_git_repo https://github.com/zsh-users/zsh-completions.git              zsh/completion/zsh-completions


cd $OLDPWD
