#!/bin/bash

# Define the installation path
INSTALL_PATH="$HOME/.activenv"

# Create the directory if it doesn't exist
mkdir -p "$INSTALL_PATH"

# Copy the auto_venv script to the install path
cp activenv.sh "$INSTALL_PATH/activenv.sh"

# Add sourcing of the script to the shell configuration
if [[ -n "$ZSH_VERSION" ]]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [[ -n "$BASH_VERSION" ]]; then
    SHELL_CONFIG="$HOME/.bashrc"
else
    echo "Unsupported shell. Please manually source $INSTALL_PATH/auto_venv.sh in your shell configuration."
    exit 1
fi

if ! grep -q "source $INSTALL_PATH/activenv.sh" "$SHELL_CONFIG"; then
    echo "source $INSTALL_PATH/activenv.sh" >> "$SHELL_CONFIG"
    echo "Installed activenv. Restart your shell or run 'source $SHELL_CONFIG' to activate."
else
    echo "activenv is already installed in $SHELL_CONFIG."
fi

