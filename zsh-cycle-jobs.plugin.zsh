#!/usr/bin/env zsh

# ZSH FZF Job Chooser Plugin
# Author: aemonge
# Version: 0.0.2

# Function to choose a job with fzf and foreground it
_fzf_job_chooser() {
    # Check if fzf is installed
    if ! command -v fzf >/dev/null; then
        zle -M "fzf not found. Please install fzf."
        return 1
    fi

    local jobs_list
    jobs_list=$(jobs -l)

    if [[ -z "$jobs_list" ]]; then
        zle -M "No jobs found"
        return 1
    fi

    # Parse and format jobs for fzf
    local job_lines
    job_lines=(${(f)"$(jobs -l | awk '{
        job_num = substr($1, 2, length($1)-2);
        state = $3;
        cmd = "";
        for (i=4; i<=NF; i++) cmd = cmd $i " ";
        printf "[%s] %s %s\n", job_num, state, cmd;
    }')"})

    # Use fzf to select a job
    local selected
    selected=$(printf "%s\n" "${job_lines[@]}" | fzf --prompt="Select job: ")

    if [[ -z "$selected" ]]; then
        return 1
    fi

    # Extract job number from selection
    local job_id
    job_id=$(echo "$selected" | awk 'match($0, /\[([0-9]+)\]/, arr) { print arr[1] }')

    if [[ -z "$job_id" ]]; then
        return 1
    fi

    # Bring selected job to foreground
    BUFFER="fg %${job_id}"
    zle accept-line
}

# Create ZLE widget and bind to Ctrl+J
zle -N _fzf_job_chooser
bindkey '^Z' _fzf_job_chooser
