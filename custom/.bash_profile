# only need be run once
# echo "set completion-ignore-case On" > ~/.inputrc

# add common locations to PATH
export PATH=~/bin:/usr/local/bin:$PATH

# add git tab completion
source /usr/local/git/contrib/completion/git-completion.bash

source ~/.bash_prompt

export JAVA_HOME="$(/usr/libexec/java_home -v 1.7)"
export M2_HOME=/Users/jkalis/Maven/apache-maven-3.3.3
export M2=$M2_HOME/bin
