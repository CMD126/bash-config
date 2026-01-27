#!/usr/bin/env bash
# Bash Aliases Installer - CMD126/bash-config
# One-click setup script

set -euo pipefail

echo "Installing aliases..."

# =======================
# Remove old block (if exists)
# =======================
if grep -qF "# Bash Aliases" ~/.bashrc 2>/dev/null; then
    echo "Removing old aliases block..."
    sed -i '/# Bash Aliases/,/====*==*==*==*==*==*==*==*==*==*==*==*/d' ~/.bashrc
fi

# =======================
# Append aliases
# =======================
cat >> ~/.bashrc << 'END_ALIASES'

# ========================================================
# Bash Aliases 
# lexlucas | https://github.com/CMD126/bash-config
# ========================================================

# Sysadmin: Updates & Maintenance
alias update='sudo apt update && sudo apt full-upgrade -y'
alias ifix='sudo apt install -f'
alias fix='sudo apt --fix-broken install'
alias clean='sudo apt autoclean && sudo apt autoremove -y && sudo apt clean'
alias maint='update && clean'

# Security & Networking
alias ports='ss -tuln | grep LISTEN'
alias portsfull='sudo ss -tulnp'
alias conns='ss -tunap | grep ESTAB'
alias ufwstat='sudo ufw status verbose'
alias myip='curl -s ifconfig.me'

# Pentest / Scanning
alias scan='sudo nmap -sS localhost -T4'
alias nmap-quick='sudo nmap -F -T4'

# Utilities
alias cls='clear'
alias ll='ls -lah --color=auto'
alias h='htop'
alias nf='neofetch'
alias shot='flameshot gui'

END_ALIASES

# =======================
# Functions file
# =======================
mkdir -p ~/.bash 2>/dev/null

cat > ~/.bash/functions << 'END_FUNC'
# ========================================================
# Custom functions
# ========================================================

enum4() {
    local target="${1:-localhost}"
    local output="${2:-enum_$(date +%Y%m%d_%H%M).txt}"
    echo "Scanning $target → $output"
    sudo nmap -sC -sV -p- -oN "$output" "$target"
}
END_FUNC

# Source functions if not already present
if ! grep -qF "source ~/.bash/functions" ~/.bashrc 2>/dev/null; then
    echo "" >> ~/.bashrc
    echo "# Custom functions" >> ~/.bashrc
    echo "[[ -f ~/.bash/functions ]] && source ~/.bash/functions" >> ~/.bashrc
fi

# Reload
source ~/.bashrc 2>/dev/null || true

echo "Done."
echo "Test:   maint   ports   nf   enum4 192.168.1.1"
echo "Repo:   https://github.com/CMD126/bash-config"