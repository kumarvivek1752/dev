# Add deno completions to search path
if [[ ":$FPATH:" != *":/home/vivek/.zsh/completions:"* ]]; then export FPATH="/home/vivek/.zsh/completions:$FPATH"; fi
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions colored-man-pages command-not-found)
# plugins+=(zsh-vi-mode)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
export PATH="$PATH:/opt/nvim/"
export PATH="$HOME/.local/bin:$PATH"

#source /home/vivek/Downloads/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# tmux sessionizer
# eval "$(zoxide init --cmd cd zsh)"
bindkey -s ^f "tmux-sessionizer\n"
bindkey -s ^s "tmux-session-fzf\n"
#
# Set up key bindings for vi-mode
# bindkey -v "^f" '"execute tmux-sessionizer"\n'
# bindkey -v "^s" '"execute tmux-session-fzf"\n'

#alias vim=nvim

# bindkey -s ^t "tmux-run\n"
#bindkey -s ^v "nvim .\n"

#npm
export PATH=$PATH:$(npm config get prefix)/bin
#export PATH=$PATH:/home/vivek/.nvm/versions/node/v21.6.1/lib/node_modules/.bin


# Add this to your .zshrc file

function workon_venv() {
    if [[ -d .venv ]]; then
        source .venv/bin/activate
    fi
}

# Call the function
workon_venv



# alias trash="trashbhuwan"
# alias c="clear"
export GTK_THEME=Adwaita:dark
export GTK_THEME=ark-arker


# ---------- monitor exam ----------
export DBNAME=lims
export DBUSER=newuser
export DBPASSWORD=password
export DBPORT=3306
export DBHOST=localhost
export MAILPORT=587
export GIN_MODE=debug
export MAILSMTPUSER=cda3a4e2807b2f
export MAILSMTPPASS=2ace98daa6ab45
export MAILSERVER=smtp.mailtrap.io
export USE_JWT=true
export JWT_AUTH_TOKEN_EXPIRY_MINUTES=90
export JWT_REFRESH_TOKEN_EXPIRY_HOURS=168  # 7 days

# ---------- monitor exam ----------
# Initialize zsh completions (added by deno install script)
autoload -Uz compinit
source /home/vivek/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# export ~/.cargo/bin/rustup


export SSH_AUTH_SOCK=/run/user/$(id -u)/keyring/ssh
export GNOME_KEYRING_CONTROL=/run/user/$(id -u)/keyring
export NVIM_APPNAME=nvimdev


