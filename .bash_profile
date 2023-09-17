# see /etc/profile for system-wide settings
# brew softlinks are in /usr/local/bin which is already in system-wide path
# see /etc/paths and /etc/paths.d used by /usr/libexec/path_helper

# $ brew info coreutils
# If you really need to use these commands with their normal names, you
# can add a "gnubin" directory to your PATH from your bashrc like:
# PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
# export PATH="/usr/local/opt/coreutils/libexec/gnubin:~/.emacs.d/bin:/usr/local/mysql/bin:$PATH"

# OPAM configuration for OCaml
# . /Users/kevinrathbun/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

# The next line updates PATH for the Google Cloud SDK.
# if [ -f '/Volumes/dev/google-cloud-sdk/path.bash.inc' ]; then . '/Volumes/dev/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
# if [ -f '/Volumes/dev/google-cloud-sdk/completion.bash.inc' ]; then . '/Volumes/dev/google-cloud-sdk/completion.bash.inc'; fi

# https://apple.stackexchange.com/questions/12993/why-doesnt-bashrc-run-automatically
# By default, Terminal starts the shell via /usr/bin/login,
# which makes the shell a login shell. On every platform (not just Mac OS X)
# bash does not use .bashrc for login shells (only /etc/profile and the first of
# .bash_profile, .bash_login, .profile that exists and is readable).
# This is why "put source ~/.bashrc in your .bash_profile" is standard advice

# https://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_STATE_HOME=${XDG_STATE_HOME:="$HOME/.local/state"}

[[ ! -f "$XDG_CONFIG_HOME"/bash/bashrc ]] || source "$XDG_CONFIG_HOME"/bash/bashrc

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
