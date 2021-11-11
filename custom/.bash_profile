# suppress the default shell message in newer macOS (zsh)
export BASH_SILENCE_DEPRECATION_WARNING=1

# add git tab completion
source /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash

# customize the display of the prompt
source ~/.prompt

alias lx="ls -1AFGhl"
. "$HOME/.cargo/env"

# Setting PATH for Python 3.9
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.9/bin:${PATH}"
export PATH
