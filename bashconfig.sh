#!/bin/bash
# Bash Aliases Installer - CMD126/bash-config
# One-click setup script to install aliases for Bash shell environment

echo "Installing aliases..."

# Avoid duplicates (backup if exists)
if grep -q "# Bash Aliases" ~/.bashrc; then
    echo "Aliases already exist. Removing old block..."
    sed -i '/# Bash Aliases/,/========================================================/d' ~/.bashrc
fi

# Append clean aliases block
cat >> ~/.bashrc << 'BLOCK_EOF'

# ========================================================
# Bash Aliases 
# lexlucas | https://github.com/CMD126/bash-config
# ========================================================

# Sysadmin: Updates & Maintenance 
alias update='sudo apt update && sudo apt upgrade -y'
alias ifix='sudo apt install -f'
alias fix='sudo apt --fix-broken install'
alias clean='sudo apt autoclean && sudo apt autoremove -y && sudo apt clean'
alias maint='update && clean'

# Security & Networking
alias ports='ss -tuln | grep LISTEN'
alias portsfull='sudo ss -tulnp'
alias conns='ss -tunap | grep ESTAB'
alias ufwstat='sudo ufw status verbose'
alias myip='curl ifconfig.me'

# Pentest Tools
alias scan='sudo nmap -sS localhost -T4'
alias enum4='sudo nmap -sC -sV -p- -oN enum.txt'
alias nmap-quick='sudo nmap -F -T4'

# Utilities
alias cls='clear'
alias ll='ls -lah'
alias h='htop'
alias nf='neofetch'
alias shot='flameshot gui'

BLOCK_EOF

source ~/.bashrc
echo "Aliases installed! Test: maint && ports && nf"
echo "Repo: https://github.com/CMD126/bash-config"
