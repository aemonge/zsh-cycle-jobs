#!/usr/bin/env zsh

# ZSH FZF Job Chooser Plugin
# Author: aemonge
# Version: 0.0.2

# Configuration - customizable via environment variable
: ${FZF_JOB_KEYBIND:="^J"}  # Default to Ctrl+J, can be overridden

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

    # Parse and format jobs for fzf (robust parsing)
    local job_lines
    job_lines=(${(f)"$(jobs -l | awk '{
        # Extract job number (remove brackets)
        job_num = substr($1, 2, length($1)-2);
        # Extract process ID (2nd field)
        pid = $2;
        # Extract state (3rd field)
        state = $3;
        # Extract command (everything from 4th field onwards)
        cmd = "";
        for (i=4; i<=NF; i++) {
            cmd = cmd $i " ";
        }
        # Clean up trailing space and weird characters
        gsub(/[[:cntrl:]]/, "", cmd);  # Remove control characters
        gsub(/\|/, "", cmd);           # Remove pipe characters that might confuse display
        gsub(/\[.+\]/, "", cmd);      # Remove bracketed parts that might be prompts
        cmd = substr(cmd, 1, 100);    # Limit length to prevent display issues
        gsub(/ $/, "", cmd);          # Remove trailing space
        if (length(cmd) == 0) cmd = "unknown";
        printf "[%s] %s %s\n", job_num, state, cmd;
    }')"})

    # Reverse the array
    job_lines=(${(Oa)job_lines})

    # Use fzf to select a job with Enter key binding AND Ctrl+J binding
    local selected
    selected=$(printf "%s\n" "${job_lines[@]}" | fzf --prompt="Select job: " --bind "enter:accept,ctrl-j:accept")

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

# Create ZLE widget and bind to customizable key
zle -N _fzf_job_chooser
bindkey "$FZF_JOB_KEYBIND" _fzf_job_chooser
