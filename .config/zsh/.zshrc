# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ${ZDOTDIR}/antigen.zsh


antigen bundle zsh-users/zsh-syntax-highlighting

antigen theme romkatv/powerlevel10k

antigen apply

autoload -U compinit; compinit

# https://thevaluable.dev/zsh-completion-guide-examples/
# ^x h for completion help
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle ':completion:*' menu select                                                  # search for fuzzy-search ; interactive to filter completion menu
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'              # descriptions depending on the type of match
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f' # for completer _approximate
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*' group-name ''                                                # group different match types under their descriptions
zstyle ':completion:*:*:-command-:*:*' group-order alias builtins functions commands    # order of match type descriptions
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}                       # set value to $LS_COLORS, normally used by 'ls --color=auto'

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# https://unix.stackexchange.com/questions/6620/how-to-edit-command-line-in-full-screen-editor-in-zsh
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line


[ -f ${ZDOTDIR}/.fzf.zsh ] && source ${ZDOTDIR}/.fzf.zsh
# Use fd instead of the default find command for listing path candidates.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}
# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}
# --hidden to search dotfiles
export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export BAT_THEME="ansi"

HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=50000
SAVEHIST=10000
HIST_STAMPS="dd.mm.yyyy"

setopt hist_expire_dups_first # delete dups first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore consecutive duplicated commands history
setopt hist_ignore_all_dups   # removes dups of lines still in the history list, keeping newly added one
setopt hist_save_no_dups      # do not save duplicated lines to HISTFILE more than once
setopt hist_find_no_dups      # backward searches with editor commands dont show dups more than once
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion at prompt before running it
setopt extended_history       # record timestamp of command in HISTFILE
setopt append_history         # append the new history to the old in histfile
setopt inc_append_history_time # same but supports extended_history (set below)

setopt no_beep
setopt extended_glob        # enables ^ ~ negations et al chars for filename globbing
setopt correct              # asks to correct a mistyped command

function less () {      # https://zsh.sourceforge.io/Guide/zshguide05.html
    integer i=1
    local args arg
    args=($*)

    for arg in $*; do
        case $arg in
            (*.bz2)     args[$i]="=(bunzip2 -c ${(q)arg})"
                ;;
            (*.(gz|Z))  args[$i]="=(zcat ${(q)arg})"        # assumes zcat is the one installed with gzip
                ;;
            (*)         args=${(q)arg}
                ;;
        esac
        (( i++ ))
    done

    eval command ${PAGER:-less} $args
}

fignore+=(.DS_Store)

alias cat=bat
alias his="history -20"
alias more="less -i"

alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"
alias ls="ls -F"
alias la="ls -a"
alias ll="ls -l"

alias cd..="cd ../.."
alias cd...="cd ../../.."
alias cd....="cd ../../../.."
cdpath=(/Volumes/dev $cdpath)
dev=/Volumes/dev
src=/Users/kevinrathbun/Documents/src
# create named directory from current directory
namedir () { $1=$PWD ;  : ~$1 }

setopt nocaseglob
DIRSTACKSIZE=8
setopt autopushd        # save all dir changes to stack
setopt pushdminus       # swap - and + directions in stack
setopt pushdsilent      # dont list stack on each pushd
setopt pushdignoredups  # no dups in stack
setopt autocd           # change to dir in cdpath with 'cd'
setopt cdablevars       # autocd to named directories without '~'
alias ds="dirs -v"
alias pd=pushd
alias pp=popd
alias cd1="cd -1"
alias cd2="cd -2"
alias cd3="cd -3"
alias cd4="cd -4"

alias sls="screen -ls"
alias sdr="screen -dr"

alias diffy="diff -by --width=200"

alias gdot='/usr/local/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias gg="git grep"
alias ggi="git grep -i"

typeset -U path     # only unique entries in path

if [ "$JAVA_HOME" = "" ]; then
    JAVA_HOME=$(/usr/libexec/java_home 2&> /dev/null)
    export JAVA_HOME
fi

path=($path $HOME/.emacs.d/bin $HOME/bin)

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/kevinrathbun/mambaforge/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/kevinrathbun/mambaforge/etc/profile.d/conda.sh" ]; then
        . "/Users/kevinrathbun/mambaforge/etc/profile.d/conda.sh"
    else
        export PATH="/Users/kevinrathbun/mambaforge/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/Users/kevinrathbun/mambaforge/etc/profile.d/mamba.sh" ]; then
    . "/Users/kevinrathbun/mambaforge/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

[[ ! -f "$ZDOTDIR"/.p10k.zsh ]] || source "$ZDOTDIR"/.p10k.zsh
