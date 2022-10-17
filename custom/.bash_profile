# suppress the default shell message in newer macOS (zsh)
export BASH_SILENCE_DEPRECATION_WARNING=1

# add git tab completion
source /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash

# customize the display of the prompt
source ~/.prompt

export BUN_INSTALL="/Users/boat/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
