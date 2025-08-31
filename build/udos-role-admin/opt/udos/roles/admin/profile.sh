#!/bin/bash
# Admin role environment setup

export UDOS_ROLE="admin"
export EDITOR="micro"
export PAGER="glow"

# Development aliases
alias md='micro'
alias view='glow'
alias info='udos-info'
alias gui='startx'
alias build='make'
alias venv='python3 -m venv'

# Development paths
export PATH="/opt/udos/bin:$PATH"
export PYTHONPATH="/opt/udos/lib/python:$PYTHONPATH"

# Welcome for developers
if [ -t 1 ] && [ -z "$UDOS_DEV_WELCOME_SHOWN" ]; then
    echo "uDESK Admin Mode - Full development environment active"
    echo "All system configs are in markdown format for easy editing"
    export UDOS_DEV_WELCOME_SHOWN=1
fi
