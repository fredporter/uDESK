#!/bin/bash
# Basic role environment setup

export UDOS_ROLE="basic"
export EDITOR="micro"
export PAGER="glow"

# Aliases for markdown workflow
alias md='micro'
alias view='glow'
alias info='udos-info'

# Welcome message
if [ -t 1 ] && [ -z "$UDOS_WELCOME_SHOWN" ]; then
    echo "Welcome to uDESK Basic! Type 'info' for system status."
    export UDOS_WELCOME_SHOWN=1
fi
