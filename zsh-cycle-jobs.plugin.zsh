#!/usr/bin/env zsh

# ZSH Cycle Jobs Plugin
# Author: aemonge
# Version: 0.0.1

# Add functions directory to fpath
fpath=( "${0:h}/functions" $fpath )

# Autoload the main function
autoload -Uz zsh_cycle_jobs_cycle

# Job tracking file
FANCY_ZSH_LAST_JOB_NUMBER="/tmp/zsh_cycle_jobs__last_job_number"

# Get the next jobs as array
get_next_job() {
    local all_jobs=($(jobs | awk -F'[][]' '{print $2}' | tr -d ' '))
    if [ ${#all_jobs[@]} -eq 0 ]; then
        return
    fi

    local current_index=$1
    if [ -z "$current_index" ]; then
        current_index=1
    fi

    local array_size=${#all_jobs[@]}
    local rotated_index=$((current_index % array_size))
    local next_job_index=$((rotated_index + 1))
    echo -n "${all_jobs[$next_job_index]}"
}

# Bind the Ctrl+Z shortcut to the zsh_cycle_jobs_cycle function
zle -N zsh_cycle_jobs_cycle
bindkey '^Z' zsh_cycle_jobs_cycle
