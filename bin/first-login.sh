#!/usr/bin/env bash

if [[ -e $HOME/.first-login ]]; then
    USER_FIRST_LOGIN=/vagrant/users/$HOST_USER/first-login.sh

    echo
    echo "=================================================="
    echo "First login. Attempting to run first login script"
    echo "Setting up first-login interactive provisioning."
    echo "=================================================="
    echo

    if [[ -x $USER_FIRST_LOGIN ]]
    then
        echo "Configuring git"
        git config --global user.email "jfreeman@hawk.iit.edu"
        git config --global user.name "jake-freeman"
        mkdir ~/src
    fi

    rm $HOME/.first-login

    ###################################################################################################
    #
    # Set up Oh My Zsh with Babun theme.
    #
    ###################################################################################################
    echo "Setting up Oh My Zsh with Babun theme."
    OH_MY_ZSH_URL="https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh"
    BABUN_THEME_URL="https://raw.githubusercontent.com/babun/babun/master/babun-core/plugins/oh-my-zsh/src/babun.zsh-theme"

    if ! [[ -d $HOME/.oh-my-zsh ]]; then
        echo "Installing Oh My Zsh..."
        if curl -L $OH_MY_ZSH_URL | sh; then
            echo "Oh My Zsh is now your default command shell."
        else
            echo "Making Oh My Zsh the default command shell."
            # this line needs to be fixed
            sudo chsh -s $(which zsh)
        fi

        if ! curl -L $BABUN_THEME_URL > $HOME/.oh-my-zsh/custom/babun.zsh-theme; then
            cat <<'BABUN' >> $HOME/.oh-my-zsh/custom/babun.zsh-theme
local return_code="%(?..%{$fg[red]%}%? %{$reset_color%})"
PROMPT='%{$fg[blue]%}{ %c } \
%{$fg[green]%}$(  git rev-parse --abbrev-ref HEAD 2> /dev/null || echo ""  )%{$reset_color%} \
%{$fg[red]%}%(!.#.»)%{$reset_color%} '
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'
RPS1='%{$fg[blue]%}%~%{$reset_color%} ${return_code} '
ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}:: %{$fg[yellow]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$fg[yellow]%}"
BABUN
        fi

        sed -e 's/\(ZSH_THEME=\).*/\1"babun"/' $HOME/.zshrc > $HOME/.zshrc.tmp && mv $HOME/.zshrc.tmp $HOME/.zshrc
    fi
fi
