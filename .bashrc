[[ $- != *i* ]] && return

# PS1="\u@\h:\w\$ "
# PS1="\$"

# function set_venv_prompt() {

# History
shopt -s histappend
export HISTSIZE=200000
export HISTFILESIZE=200000
export HISTCONTROL=ignoredups:ignorespace:erasedups
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"

# BASH VI mode
bind 'set editing-mode vi'
bind 'set show-mode-in-prompt on'
bind 'set keyseq-timeout 0.01'
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind 'set vi-ins-mode-string \1\e[6 q\2'
bind 'set vi-cmd-mode-string \1\e[2 q\2'
bind 'set keymap vi-insert'
bind 'RETURN: "\e\n"'

paste_from_clipboard() {
  local shift=$1
  local head=${READLINE_LINE:0:READLINE_POINT+shift}
  local tail=${READLINE_LINE:READLINE_POINT+shift}
  local paste=$(wl-paste -n)
  local paste_len=${#paste}

  READLINE_LINE=${head}${paste}${tail}
  let READLINE_POINT+=$paste_len+$shift-1
}

yank_line_to_clipboard() {
  echo $READLINE_LINE | wl-copy
}

kill_line_to_clipboard() {
  yank_line_to_clipboard
  READLINE_LINE=""
}

bind -m vi-command -x '"P": paste_from_clipboard 0'
bind -m vi-command -x '"p": paste_from_clipboard 1'
bind -m vi-command -x '"yy": yank_line_to_clipboard'
bind -m vi-command -x '"xx": kill_line_to_clipboard'
bind -m vi-command '"k": history-search-backward'
bind -m vi-command '"j": history-search-forward'

# Bash completion
source /usr/share/bash-completion/bash_completion
bind 'TAB:menu-complete'
bind 'set show-all-if-ambiguous on'
bind "set completion-ignore-case on"

# Some exports
export EDITOR="nvim"
export TERMIAL="kitty"
# export BAT_THEME="gruvbox-dark"
# export BROWSER="firefox"

export FZF_DEFAULT_COMMAND="rg --files --no-preview"

export FZF_DEFAULT_OPTS="
  --bind 'ctrl-y:preview-up,ctrl-e:preview-down'
  --bind 'ctrl-b:preview-page-up,ctrl-f:preview-page-down'
  --bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'
  --bind 'shift-up:preview-top,shift-down:preview-bottom'
  --bind 'alt-up:half-page-up,alt-down:half-page-down'
"
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target,env,__pycache__,.next,dist
  # --preview 'tree -C {}'"

export FZF_CTRL_E_OPTS="
  --walker-skip .git,node_modules,target,env,__pycache__,.next,dist
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

export FZF_CTRL_R_OPTS="
  --preview 'echo {}'
  --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | wl-copy)+abort'"

eval "$(fzf --bash)"
eval "$(oh-my-posh --init --shell bash --config ~/robbyrussell.omp.json)"

tmux_sessionizer() {
  ~/.local/bin/tmux-sessionizer
}
bind -x '"\C-f": tmux_sessionizer'

tmux_sessions() {
  ~/.local/bin/tmux-session-fzf
}
bind -x '"\C-s": tmux_sessions'
# Disable terminal flow control (free up Ctrl+S)
stty -ixon
bind '"\C-l": clear-screen'
# export TERM=xterm-256color
#npm
export PATH=$PATH:$(npm config get prefix)/bin
#export PATH=$PATH:/home/vivek/.nvm/versions/node/v21.6.1/lib/node_modules/.bin

# Add this to your .zshrc file

function workon_venv() {
  if [[ -d .venv ]]; then
    source .venv/bin/activate # commented out by conda initialize
  fi
}
workon_venv

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

# Created by `pipx` on 2025-05-31 18:02:10
export PATH="$PATH:/home/vivek/.dotfiles/bin/.local/bin"

alias ll="ls -lah"

export WASMTIME_HOME="$HOME/.wasmtime"

export PATH="$WASMTIME_HOME/bin:$PATH"

# ---------- vi mode bindings ----------
bind -m vi-command '"ciw":"lbcw"'
bind -m vi-command '"diw":"lbdw"'
bind -m vi-command '"yiw":"lbyw"'
bind -m vi-command '"ciW":"lBcW"'
bind -m vi-command '"diW":"lBdW"'
bind -m vi-command '"yiW":"lByW"'

export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=lcd -Dswing.aatext=true -Dsun.java2d.uiScale=1.25'

# opencode
export PATH=/home/vivek/.opencode/bin:$PATH
. "$HOME/.cargo/env"
export PATH="$PATH:$HOME/go/bin"

# pnpm
export PNPM_HOME="/home/vivek/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

alias nm="neomutt"

. "$HOME/.local/bin/env"

export PATH=$PATH:/home/vivek/.spicetify
alias load-dev="set -a; source /home/vivek/work/shashank/zaren-platform-backend/.env.dev; set +a"
alias zaren-dev="$HOME/.local/bin/zaren-dev"

# Added by Antigravity CLI installer
export PATH="/home/vivek/.local/bin:$PATH"

source ~/.env
