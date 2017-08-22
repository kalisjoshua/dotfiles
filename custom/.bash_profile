# only need be run once
# echo "set completion-ignore-case On" > ~/.inputrc

# add common locations to PATH
export PATH=./venv/bin:~/bin:/usr/local/bin:$PATH

# add git tab completion
source /usr/local/git/contrib/completion/git-completion.bash

source ~/.bash_prompt

export JAVA_HOME="$(/usr/libexec/java_home -v 1.7)"
export M2_HOME=/Users/jkalis/Maven/apache-maven-3.3.3
export M2=$M2_HOME/bin
export PATH=$M2:$PATH

branch_purge () {
    git fetch --prune
    git branch --merged master | grep -v 'master$' | xargs git branch -d
}

alias ls="ls -1aFGhl"
