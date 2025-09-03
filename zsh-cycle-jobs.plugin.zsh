#!/usr/bin/env zsh

# ZSH FZF Job Chooser Plugin
# Author: aemonge
# Version: 0.0.3

# Configuration - customizable via environment variable
: ${FZF_JOB_KEYBIND:="^J"}  # Default to Ctrl+J, can be overridden

# Function to choose a job with fzf and foreground it
_fzf_job_chooser() {
    if ! command -v fzf >/dev/null; then
        zle -M "fzf not found. Please install fzf."
        return 1
    fi

    # Check if there are any jobs
    if [[ ${#jobtexts} -eq 0 ]]; then
        zle -M "No jobs found"
        return 1
    fi

    # Build job list using zsh built-in arrays - guaranteed clean!
    local job_lines=()
    for job_num in ${(k)jobtexts}; do
        local state=${jobstates[$job_num]%%:*}
        local cmd=${jobtexts[$job_num]}
        cmd=${cmd:0:100}
        [[ -z "$cmd" ]] && cmd="unknown"
        job_lines+=("[${job_num}] ${state} ${cmd}")
    done

    # Rest of your logic unchanged...
    if [[ ${#job_lines[@]} -eq 1 ]]; then
        local job_id=$(echo "${job_lines[1]}" | awk 'match($0, /\[([0-9]+)\]/, arr) { print arr[1] }')
        BUFFER="fg %${job_id}"
        zle accept-line
        return 0
    fi

    job_lines=(${(Oa)job_lines})
    local selected=$(printf "%s\n" "${job_lines[@]}" | fzf --prompt="Select job: ")

    if [[ -n "$selected" ]]; then
        local job_id=$(echo "$selected" | awk 'match($0, /\[([0-9]+)\]/, arr) { print arr[1] }')
        [[ -n "$job_id" ]] && BUFFER="fg %${job_id}" && zle accept-line
    fi
}

# Create ZLE widget and bind to customizable key
zle -N _fzf_job_chooser
bindkey "$FZF_JOB_KEYBIND" _fzf_job_chooser
