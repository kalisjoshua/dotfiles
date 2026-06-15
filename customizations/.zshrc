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

quality_checks() {
    # Usage: quality_checks [--debug] [<path>]
    #   no <path> : check everything changed vs the deploy branch
    #   <path>    : check just that path
    #   --debug   : list the files being checked (otherwise quiet on clean runs)
    # Both modes run ALL checks and report every failure at the end (no bail-out
    # on the first failure).
    local debug=0
    local -a positional failed
    local arg
    for arg in "$@"; do
        case "$arg" in
            --debug) debug=1 ;;
            *) positional+=("$arg") ;;
        esac
    done
    set -- "${positional[@]}"

    if [[ -z "$1" ]]; then
        # No path: check everything changed vs the deploy branch —
        # committed, staged, unstaged, AND untracked (new) files.
        local base="origin/deploy/kalisjoshua"
        local -a files present lint_files pkgs apps filters
        local f p a

        # Must be inside a git work tree.
        if ! git rev-parse --is-inside-work-tree &>/dev/null; then
            echo "quality_checks: not in a git repo (cwd: $PWD) — cd into the repo first"
            return 1
        fi
        # Deploy base must be resolvable, else the diff would silently find nothing.
        local base_range="$base...HEAD"
        if ! git rev-parse --verify --quiet "$base" >/dev/null; then
            echo "quality_checks: '$base' not found — comparing against working tree only"
            base_range=""
        fi

        # Collect from three sources: committed-vs-deploy, staged+unstaged,
        # untracked/new. NOTE: keep comments OUT of the $(...) below — with
        # interactive_comments unset (this shell), inline comments inside a
        # command substitution become literal args and silently break the diff.
        files=( ${(f)"$( {
            [[ -n "$base_range" ]] && git diff --name-only "$base_range"
            git diff --name-only HEAD
            git ls-files --others --exclude-standard
        } 2>/dev/null | sort -u )"} )
        # drop deletions — only keep paths that still exist on disk
        for f in $files; do [[ -e $f ]] && present+=$f; done
        files=($present)
        (( ${#files} )) || { echo "no changes vs $base — nothing to check"; return 0 }

        lint_files=( ${(M)files:#*.(ts|tsx|js|jsx|cjs|mjs)} )
        if (( debug )); then
            echo "checking ${#files} changed file(s) (${#lint_files} lintable) vs $base:"
            printf '  %s\n' $files
        fi

        if (( ${#lint_files} )); then
            pnpm jest --passWithNoTests --findRelatedTests "${lint_files[@]}" || failed+=(jest)
            pnpm -w biome lint "${lint_files[@]}"  || failed+=(biome)
            pnpm -w eslint "${lint_files[@]}"      || failed+=(eslint)
        fi

        # typecheck the package(s) owning the changes; fall back to all packages
        pkgs=( ${(f)"$( printf '%s\n' $files | awk -F/ '$1=="apps"||$1=="libs"{print "./"$1"/"$2}' | sort -u )"} )
        if (( ${#pkgs} )); then
            for p in $pkgs; do filters+=(--filter="$p"); done
            pnpm $filters typecheck || failed+=(typecheck)
        else
            pnpm typecheck || failed+=(typecheck)
        fi

        pnpm test:consistency || failed+=(consistency)

        # i18n:translate for any changed apps
        apps=( ${(f)"$( printf '%s\n' $files | awk -F/ '$1=="apps"{print $2}' | sort -u )"} )
        if (( ${#apps} )); then
            filters=()
            for a in $apps; do filters+=(--filter="./apps/$a"); done
            pnpm $filters run --if-present i18n:translate || failed+=(i18n:translate)
        fi
    else
        # Explicit path: check just that path.
        (( debug )) && echo "checking path: $1"
        pnpm jest --passWithNoTests "$1" || failed+=(jest)
        pnpm -w biome lint "$1"          || failed+=(biome)
        pnpm -w eslint "$1"              || failed+=(eslint)

        # Scope typecheck to the app owning the path; fall back to all packages
        local pkg=""
        case "$1" in
            apps/*) pkg=$(awk -F/ '{print "./" $1 "/" $2}' <<< "$1") ;;
        esac
        if [[ -n "$pkg" ]]; then
            pnpm --filter="$pkg" typecheck || failed+=(typecheck)
        else
            pnpm typecheck || failed+=(typecheck)
        fi

        pnpm test:consistency || failed+=(consistency)

        # i18n:translate for any apps changed vs your deploy branch
        local changed_apps
        changed_apps=$(git diff --name-only origin/deploy/kalisjoshua...HEAD -- apps/ 2>/dev/null \
            | awk -F/ '{print $2}' | sort -u)
        if [[ -n "$changed_apps" ]]; then
            local pfilters
            pfilters=$(printf -- '--filter ./apps/%s ' $changed_apps)
            eval "pnpm $pfilters run --if-present i18n:translate" || failed+=(i18n:translate)
        fi
    fi

    if (( ${#failed} )); then
        echo "FAILED: ${failed[*]}"
        return 1
    fi
    echo "all clean"
}
