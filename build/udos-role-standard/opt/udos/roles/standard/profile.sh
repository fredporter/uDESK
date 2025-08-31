#!/bin/bash
# Standard role environment setup

export UDOS_ROLE="standard"
export EDITOR="micro"
export PAGER="glow"

# Enhanced aliases
alias md='micro'
alias view='glow'
alias info='udos-info'
alias gui='startx'

# Service management
alias services='udos-service list'
alias start-service='udos-service start'
