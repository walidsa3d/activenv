cd() {
    # Save the original cd command
    builtin cd "$@" || return
    local current_dir="$PWD"
    
    # List of possible virtual environment directory names
    local venv_dirs=(".venv" ".env" "venv" "env")
    local found_venv=""
    
    # Look for venv in current and parent directories
    local check_dir="$current_dir"
    while [[ "$check_dir" != "/" ]]; do
        for dir in "${venv_dirs[@]}"; do
            if [[ -d "$check_dir/$dir" ]]; then
                found_venv="$check_dir/$dir"
                break 2
            fi
        done
        check_dir="$(dirname "$check_dir")"
    done
    
    local old_venv="$VIRTUAL_ENV"
    
    # If we're in a venv and move outside its project tree, deactivate
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local venv_project_root="$(dirname "$(dirname "$VIRTUAL_ENV")")"
        if [[ "$current_dir" != "$venv_project_root"* ]]; then
            deactivate
            echo "Deactivated venv: $(basename "$old_venv")"
        fi
    # If we're not in a venv and move to a directory with one, activate
    elif [[ -z "$VIRTUAL_ENV" && -n "$found_venv" ]]; then
        source "$found_venv/bin/activate"
        echo "Activated venv: $(basename "$found_venv")"
    fi
}

# Run once when the shell starts
auto_venv_startup() {
    local current_dir="$PWD"
    local venv_dirs=(".venv" ".env" "venv" "env")
    local found_venv=""
    
    # Look for venv in current and parent directories
    local check_dir="$current_dir"
    while [[ "$check_dir" != "/" ]]; do
        for dir in "${venv_dirs[@]}"; do
            if [[ -d "$check_dir/$dir" ]]; then
                found_venv="$check_dir/$dir"
                break 2
            fi
        done
        check_dir="$(dirname "$check_dir")"
    done
    
    if [[ -n "$found_venv" && -z "$VIRTUAL_ENV" ]]; then
        source "$found_venv/bin/activate"
        echo "Activated venv: $(basename "$found_venv")"
    fi
}
auto_venv_startup
