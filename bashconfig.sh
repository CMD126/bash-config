#!/usr/bin/env bash
set -euo pipefail

echo "Instalando aliases..."

# Remove bloco antigo se existir
if grep -qF "# Bash Aliases" ~/.bashrc 2>/dev/null; then
    echo "Removendo bloco antigo..."
    sed -i '/# Bash Aliases/,/====*==*==*==*==*==*==*==*==*==*==*==*/d' ~/.bashrc
fi

# Adiciona aliases
cat >> ~/.bashrc << 'END_ALIASES'

# ========================================================
# Bash Aliases 
# lexlucas | https://github.com/CMD126/bash-config
# ========================================================

# Manutenção
alias update='sudo apt update && sudo apt full-upgrade -y'
alias ifix='sudo apt install -f'
alias fix='sudo apt --fix-broken install'
alias clean='sudo apt autoclean && sudo apt autoremove -y && sudo apt clean'
alias maint='update && clean'

# Rede/Segurança
alias ports='ss -tuln | grep LISTEN'
alias portsfull='sudo ss -tulnp'
alias conns='ss -tunap | grep ESTAB'
alias ufwstat='sudo ufw status verbose'
alias myip='curl -s ifconfig.me'

# Pentest
alias scan='sudo nmap -sS localhost -T4'
alias nmap-quick='sudo nmap -F -T4'

# Utilitários
alias cls='clear'
alias ll='ls -lah --color=auto'
alias h='htop'
alias nf='neofetch'
alias shot='flameshot gui'

END_ALIASES

# Cria diretório e função
mkdir -p ~/.bash
cat > ~/.bash/functions << 'END_FUNC'
# ========================================================
# Funções personalizadas
# ========================================================

enum4() {
    local target="${1:-localhost}"
    local output="${2:-enum_$(date +%Y%m%d_%H%M).txt}"
    echo "Scan $target → $output"
    sudo nmap -sC -sV -p- -oN "$output" "$target"
}
END_FUNC

# Source da função (se ainda não existir)
if ! grep -qF "source ~/.bash/functions" ~/.bashrc 2>/dev/null; then
    echo "" >> ~/.bashrc
    echo "# Funções personalizadas" >> ~/.bashrc
    echo "[[ -f ~/.bash/functions ]] && source ~/.bash/functions" >> ~/.bashrc
fi

source ~/.bashrc 2>/dev/null || true

echo "Feito."
echo "Teste: maint ports nf enum4 127.0.0.1"