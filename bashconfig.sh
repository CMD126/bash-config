#!/usr/bin/env bash
# bash-config installer
# Adds a block of aliases and functions to ~/.bashrc between two markers.
# Usage: ./bashconfig.sh            install or update
#        ./bashconfig.sh --uninstall remove the block
set -euo pipefail

BASHRC="${BASHRC:-$HOME/.bashrc}"
BEGIN_MARK="# >>> bash-config (CMD126) >>>"
END_MARK="# <<< bash-config (CMD126) <<<"

touch "$BASHRC"

remove_block() {
    local tmp
    tmp="$(mktemp)"
    # 1) Current format: delete only what sits between our own markers.
    # 2) Legacy format (no end marker): delete from the "# ====" line that
    #    directly precedes "# Bash Aliases" up to the closing "}" of enum4().
    awk -v begin="$BEGIN_MARK" -v end="$END_MARK" '
        $0 == begin { skip = 1; next }
        skip == 1 && $0 == end { skip = 0; next }
        skip == 1 { next }

        legacy == 0 && /^# =+$/ { held = $0; holding = 1; next }
        holding == 1 {
            holding = 0
            if ($0 ~ /^# Bash Aliases[[:space:]]*$/) { legacy = 1; next }
            print held
        }
        legacy == 1 {
            if ($0 ~ /^enum4\(\)[[:space:]]*\{/) { in_fn = 1 }
            if (in_fn == 1 && $0 ~ /^}[[:space:]]*$/) { legacy = 2 }
            next
        }
        { print }
        END { if (holding == 1) print held }
    ' "$BASHRC" > "$tmp"
    cat "$tmp" > "$BASHRC"
    rm -f "$tmp"
}

backup="$BASHRC.bak.$(date +%Y%m%d-%H%M%S)"
cp "$BASHRC" "$backup"
echo "Backup saved to $backup"

if [[ "${1:-}" == "--uninstall" ]]; then
    remove_block
    echo "bash-config removed. Run: source ~/.bashrc"
    exit 0
fi

echo "Installing aliases..."
remove_block

cat >> "$BASHRC" << END_ALIASES
$BEGIN_MARK
# Bash aliases and functions | https://github.com/CMD126/bash-config
# Remove with: ./bashconfig.sh --uninstall

# System
alias update='sudo apt update && sudo apt full-upgrade -y'
alias ifix='sudo apt install -f'
alias fix='sudo apt --fix-broken install'
alias clean='sudo apt autoclean && sudo apt autoremove -y && sudo apt clean'
alias maint='update && clean'

# Network monitoring
alias ports='ss -tuln | grep LISTEN'
alias portsfull='sudo ss -tulnp'
alias conns='ss -tunap | grep ESTAB'
alias ufwstat='sudo ufw status verbose'
alias myip='curl -s ifconfig.me'

# Pentest (only against systems you are authorised to test)
alias scan='sudo nmap -sS localhost -T4'
alias nmap-quick='sudo nmap -F -T4'

# Utils and productivity
alias cls='clear'
alias ll='ls -lah --color=auto'
alias h='htop'
alias nf='neofetch'
alias shot='flameshot gui'

# Full TCP enumeration; output file is dated so runs never overwrite each other
enum4() {
    local target="\${1:-localhost}"
    local output="\${2:-enum4_\${target//\//_}_\$(date +%Y%m%d-%H%M%S).txt}"
    echo "Scan \$target -> \$output"
    sudo nmap -sC -sV -p- -oN "\$output" "\$target"
}
$END_MARK
END_ALIASES

echo "Aliases installed successfully!"
echo "Reload your shell: source ~/.bashrc"
echo "Then try: ports, nf, enum4 127.0.0.1"
