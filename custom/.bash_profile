# only need be run once
# echo "set completion-ignore-case On" > ~/.inputrc

export BASH_SILENCE_DEPRECATION_WARNING=1

USER_BASE_PYTHON=$(python -m site --user-base)

# add common locations to PATH
export PATH=./venv/bin:~/bin:/usr/local/bin:$USER_BASE_PYTHON/bin:$PATH

# add git tab completion
source /usr/local/git/contrib/completion/git-completion.bash

source ~/.prompt

#export JAVA_HOME="$(/usr/libexec/java_home -v 1.7)"
#export M2_HOME=/Users/jkalis/Maven/apache-maven-3.3.3
#export M2=$M2_HOME/bin
#export PATH=$M2:$PATH:./.bin

branch_purge () {
    git fetch --prune
    git branch --merged master | grep -v 'master$' | xargs git branch -d
}

alias lx="ls -1AFGhl"
