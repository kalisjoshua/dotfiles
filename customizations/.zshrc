# Case-insensitive completion with partial-word and substring matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

if type brew &>/dev/null; then
  # Add Homebrew's Git completions
  fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
  # Enable completions
  fpath=($(brew --prefix)/share/zsh-completions $fpath)
fi

# Enable Docker CLI completions.
fpath=(/Users/joshuakalis/.docker/completions $fpath)

# Initialize completions (must come after all fpath modifications)
autoload -Uz compinit && compinit -i

# Enable Git info in prompt
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '(%b)'
setopt prompt_subst

# Set prompt with Git branch
PROMPT='
%~ ${vcs_info_msg_0_}
%# '

alias arrange='osascript ~/bin/arrange-windows.applescript'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
