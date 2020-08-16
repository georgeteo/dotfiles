#!/bin/bash

# prompt
prompt() {
    PROMPT=""
    NEWLINE=$'\n'

    # if ssh somewhere, add "$USER at $HOST"
    if [[ -n ${SSH_CLIENT} ]]; then
        PROMPT="$PROMPT%B%F{yellow}$USER %b%F{none}at %B%F{green}$(hostname) %b%F{none}in "
    fi

    # If inside git dir, use git root as directory root
    if [ $(git rev-parse --is-inside-git-dir 2> /dev/null) ]; then
        GIT_ABSOLUTE_ROOT=$(git rev-parse --show-toplevel)
        GIT_ROOT=$(basename $GIT_ABSOLUTE_ROOT)
        GIT_BRANCH=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)
        GIT_DIR_SUFFIX=$(git rev-parse --show-prefix)

        # If inside git dir, use git root as directory root
        PROMPT="$PROMPT%B%F{cyan}$GIT_ROOT/$GIT_DIR_SUFFIX"

        # Color the git branch name according to whether there is stuff to
        # git add, git commit, git push.
        if ! git diff --quiet 2> /dev/null; then
            # color unstaged changes red
            PROMPT="$PROMPT %F{red}"
        elif ! git diff --cached --quiet 2> /dev/null; then
            # color uncommitted changes yellow
            PROMPT="$PROMPT %F{yellow}"
        else
            # default green
            PROMPT="$PROMPT %F{green}"
        fi
        PROMPT="$PROMPT$GIT_BRANCH "

        # count number of commits ahead of remote
        NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
        if [ "$NUM_AHEAD" -gt 0 ]; then
            PROMPT="$PROMPT%F{red}⇡$NUM_AHEAD"
        fi

        # count number of commits behind remote
        NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
        if [ "$NUM_BEHIND" -gt 0 ]; then
            PROMPT="$PROMPT%F{cyan}⇣$NUM_BEHIND"
        fi

        # not sure what this does yet.
        GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
        if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
            PROMPT="$PROMPT$F{magenta}⚡︎"
        fi

        # add ● if there are untracked changes.
        if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
            PROMPT="$PROMPT %F{red}●"
        fi
    else
        # not in git dir, so use home directory as root.
        PROMPT="$PROMPT%B%F{cyan}$(dirs)"
    fi
    PROMPT="$PROMPT${NEWLINE}"

    # TODO: change > color based on success/failure exit code.
    PROMPT="$PROMPT%B%F{green}❯ %b%F{none}"
    echo $PROMPT
}

# set PROMPT
# use `$(prompt)` to delay execution.
PROMPT='$(prompt)'
