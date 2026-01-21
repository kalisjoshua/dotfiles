# Case-insensitive completion with partial-word and substring matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Enable completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  autoload -Uz compinit && compinit -i
fi

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
