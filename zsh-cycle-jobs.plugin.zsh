#!/usr/bin/env zsh

# ZSH Cycle Jobs Plugin
# Author: aemonge
# Version: 0.0.1

# Add functions directory to fpath
fpath="${0:h}/functions${fpath:+:${fpath}}"

# Autoload the main function
autoload -Uz zsh_cycle_jobs_cycle

# Job tracking file
FANCY_ZSH_LAST_JOB_NUMBER="/tmp/zsh_cycle_jobs__last_job_number"

# Get the next jobs as array
get_next_job() {
    local all_jobs=($(jobs | awk -F'[][]' '{print $2}' | tr -d ' '))
    # Check if the array is empty
    if [ ${#all_jobs[@]} -eq 0 ]; then
        return
    fi

    # Get the current index, default to 1 if not provided
    local current_index=$1
    if [ -z "$current_index" ]; then
        current_index=1
    fi

    # Calculate next job number maintaining 1-based indexing
    local array_size=${#all_jobs[@]}
    
    # Apply modulo for circular rotation
    local rotated_index=$((current_index % array_size))
    
    # Add 1 to convert back to 1-based job numbers
    local next_job_index=$((rotated_index + 1))
    
    # Return the job number (converting to 0-based for array access)
    echo -n "${all_jobs[$next_job_index]}"
}

# Bind the Ctrl+Z shortcut to the zsh_cycle_jobs_cycle function
zle -N zsh_cycle_jobs_cycle
bindkey '^Z' zsh_cycle_jobs_cycle
