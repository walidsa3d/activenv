cd() {
    # Save the original cd command
    builtin cd "$@" || return
    local current_dir="$PWD"
    
    # List of possible virtual environment directory names
    local venv_dirs=(".venv" ".env" "venv" "env")
    local found_venv=""
    
    # Check for the existence of any of these directories
    for dir in "${venv_dirs[@]}"; do
        if [[ -d "$current_dir/$dir" ]]; then
            found_venv="$current_dir/$dir"
            break
        fi
    done
    
    local old_venv="$VIRTUAL_ENV"
    
    # If we're in a venv and move to a directory without one, deactivate
    if [[ -n "$VIRTUAL_ENV" && -z "$found_venv" ]]; then
        deactivate
        echo "Deactivated venv: $(basename "$old_venv")"
    
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
    
    # Check for the existence of any of these directories
    for dir in "${venv_dirs[@]}"; do
        if [[ -d "$current_dir/$dir" ]]; then
            found_venv="$current_dir/$dir"
            break
        fi
    done
    
    if [[ -n "$found_venv" && -z "$VIRTUAL_ENV" ]]; then
        source "$found_venv/bin/activate"
        echo "Activated venv: $(basename "$found_venv")"
    fi
}

auto_venv_startup