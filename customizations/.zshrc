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

# Khan's ~/.zprofile.khan (sourced earlier, in .zprofile) does
# `source git-completion.bash`, which clobbers the proper zsh `_git` completion
# with git's legacy *bash* completion via the flaky bashcompinit bridge, breaking
# `git <TAB>`. Restore the real zsh wrapper (Homebrew git's _git) here.
unfunction _git 2>/dev/null
autoload -Uz _git
compdef _git git

# Enable Git info in prompt
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '(%b)'
setopt prompt_subst

# Set prompt with Git branch
PROMPT='
%F{cyan}%~%f %F{green}${vcs_info_msg_0_}%f
%# '

alias arrange='osascript ~/bin/arrange-windows.applescript'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "/Users/joshuakalis/.deno/env"

function quality_checks() {
  [[ -z "$1" ]] && { echo "usage: quality_checks <path>"; return 1; }
  pnpm jest --passWithNoTests "$1" && pnpm -w biome lint "$1" && pnpm -w eslint "$1" && pnpm --filter=devadmin typecheck && echo "all clean"
}
