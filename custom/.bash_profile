# suppress the default shell message in newer macOS (zsh)
export BASH_SILENCE_DEPRECATION_WARNING=1

# add git tab completion
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# customize the display of the prompt
source ~/.prompt

export BUN_INSTALL="/Users/boat/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export DENO_INSTALL="/Users/kalisjoshua/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

export PATH=~/.npm-global/bin:$PATH

test -d "$HOME/.tea" && source /dev/stdin <<<"$("$HOME/.tea/tea.xyz/v*/bin/tea" --magic=bash --silent)"

eval "$(/opt/homebrew/bin/brew shellenv)"
