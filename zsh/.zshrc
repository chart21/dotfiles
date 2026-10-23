fpath=($ZDOTDIR/external $fpath)

source "$XDG_CONFIG_HOME/zsh/aliases"

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

autoload -Uz compinit; compinit
_comp_options+=(globdots) # With hidden files
source ~/dotfiles/zsh/external/completion.zsh


source ~/dotfiles/zsh/external/zsh_codex/zsh_codex.plugin.zsh
bindkey '^X' create_completion


autoload -Uz prompt_purification_setup; prompt_purification_setup

# Push the current directory visited on to the stack.
setopt AUTO_PUSHD
# Do not store duplicate directories in the stack
setopt PUSHD_IGNORE_DUPS
# Do not print the directory stack after using
setopt PUSHD_SILENT

#allow comment character '#'
setopt interactivecomments

bindkey -v
export KEYTIMEOUT=1

autoload -Uz cursor_mode && cursor_mode

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line


source ~/dotfiles/zsh/external/web-search.zsh
source ~/dotfiles/zsh/external/bd.zsh

if [ $(command -v "fzf") ]; then
    source /usr/share/fzf/completion.zsh
    source /usr/share/fzf/key-bindings.zsh
fi

if [ "$(tty)" = "/dev/tty1" ];
then
    pgrep i3 || exec startx "$XDG_CONFIG_HOME/X11/.xinitrc"
fi

source $DOTFILES/zsh/scripts.sh


# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'



ftmuxp

# Clearing the shell is now done with CTRL+g
bindkey -r '^l'
bindkey -r '^g'
bindkey -s '^g' 'clear\n'

source ~/dotfiles/zsh/external/dirhistory.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh


# alt+<- | alt+->
#bindkey "^[f" forward-word
#bindkey "^[b" backward-word

# ctrl+<- | ctrl+->
#bindkey "^[[1;5D" backward-word
#bindkey "^[[1;5C" forward-word

#Colorls
source $(dirname $(gem which colorls))/tab_complete.sh
path+=(
    $(ruby -e 'puts File.join(Gem.user_dir, "bin")')
)



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/christopher/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/christopher/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/christopher/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/christopher/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# notifyd aliases (c1, c2, ...); ZDOTDIR means ~/.zshrc is never read
[ -f "$HOME/.config/notifyd/aliases.zsh" ] && source "$HOME/.config/notifyd/aliases.zsh"
# c1-c4: always start with remote control and no permission prompts
for __a in c1 c2 c3 c4; do
  unalias $__a 2>/dev/null
  eval "$__a() { /home/christopher/workspace/notify-app/gateway/.venv/bin/agent-run $__a --remote-control --dangerously-skip-permissions \"\$@\"; }"
done
unset __a
