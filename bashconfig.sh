#!/usr/bin/env bash
set -euo pipefail

echo "Installing aliases..."
# Remove old aliases if they exist
if grep -qF "# Bash Aliases" ~/.bashrc 2>/dev/null; then
    echo "Remove old aliases..."
    # Remove from "# ========================================================" to end of enum4 function
    sed -i '/# ========================================================/,/^}$/d' ~/.bashrc
fi

# add new aliases to .bashrc
cat >> ~/.bashrc << 'END_ALIASES'

# ========================================================
# Bash Aliases 
# lexlucas | https://github.com/CMD126/bash-config
# ========================================================

# system
alias update='sudo apt update && sudo apt full-upgrade -y'
alias ifix='sudo apt install -f'
alias fix='sudo apt --fix-broken install'
alias clean='sudo apt autoclean && sudo apt autoremove -y && sudo apt clean'
alias maint='update && clean'

# Network Monitoring
alias ports='ss -tuln | grep LISTEN'
alias portsfull='sudo ss -tulnp'
alias conns='ss -tunap | grep ESTAB'
alias ufwstat='sudo ufw status verbose'
alias myip='curl -s ifconfig.me'

# Pentest
alias scan='sudo nmap -sS localhost -T4'
alias nmap-quick='sudo nmap -F -T4'

# Utils and Productivity
alias cls='clear'
alias ll='ls -lah --color=auto'
alias h='htop'
alias nf='neofetch'
alias shot='flameshot gui'

# Enumeration function
enum4() {
    local target="${1:-localhost}"
    local output="${2:-scan.txt}"
    echo "Scan $target → $output"
    sudo nmap -sC -sV -p- -oN "$output" "$target"
}

END_ALIASES

source ~/.bashrc 2>/dev/null || true

echo "Aliases installed successfully!"
echo "Test: maint ports nf enum4 127.0.0.1"
