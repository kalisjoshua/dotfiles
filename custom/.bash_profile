# suppress the default shell message in newer macOS (zsh)
export BASH_SILENCE_DEPRECATION_WARNING=1

# add git tab completion
source /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash

source ~/.prompt

branch_purge () {
    git fetch --prune
    git branch --merged master | grep -v 'master$' | xargs git branch -d
}

alias lx="ls -1AFGhl"
