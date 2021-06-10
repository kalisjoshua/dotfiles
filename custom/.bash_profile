# suppress the default shell message in newer macOS (zsh)
export BASH_SILENCE_DEPRECATION_WARNING=1

export NODE_EXTRA_CA_CERTS=~/certificates/ql-combined-certificate.crt

# add git tab completion
source /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash

# customize the display of the prompt
source ~/.prompt

alias lx="ls -1AFGhl"
