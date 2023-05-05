# suppress the default shell message in newer macOS (zsh)
export BASH_SILENCE_DEPRECATION_WARNING=1

# add git tab completion
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# customize the display of the prompt
source ~/.prompt

test -d "$HOME/.tea" && source /dev/stdin <<<"$("$HOME/.tea/tea.xyz/v*/bin/tea" --magic=bash --silent)"
