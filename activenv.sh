# Function to manage virtual environments on `cd`
cd() {
    # Save the original cd command
    builtin cd "$@" || return
    local current_dir="$PWD"
    local venv_path="$current_dir/.venv"
    local old_venv="$VIRTUAL_ENV"

    # If we're in a venv and move to a directory without one, deactivate
    if [[ -n "$VIRTUAL_ENV" && ! -d "$venv_path" ]]; then
        deactivate
        echo "Deactivated venv: $(basename "$old_venv")"
    # If we're not in a venv and move to a directory with one, activate
    elif [[ -z "$VIRTUAL_ENV" && -d "$venv_path" ]]; then
        source "$venv_path/bin/activate"
        echo "Activated venv: $(basename "$venv_path")"
    fi
}

# Run once when the shell starts
auto_venv_startup() {
    local current_dir="$PWD"
    local venv_path="$current_dir/.venv"
    if [[ -d "$venv_path" && -z "$VIRTUAL_ENV" ]]; then
        source "$venv_path/bin/activate"
        echo "Activated venv: $(basename "$venv_path")"
    fi
}

auto_venv_startup