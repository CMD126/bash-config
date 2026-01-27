# Bash Aliases Configuration

One-click installer for essential aliases for **Bash** shell.
Optimized for Kali Linux and Debian-based distros.

## Installation

```bash
chmod +x bashconfig.sh
./bashconfig.sh
source ~/.bashrc
```

## Available Aliases

### **Sysadmin** 
- `update` - Full apt update + upgrade
- `ifix` - Install fix for broken packages
- `fix` - Fix broken/missing packages  
- `clean` - Autoclean + autoremove
- `maint` - Complete maintenance chain (update + clean)

### **Security & Networking**
- `ports` - List listening ports only
- `portsfull` - Show ports with associated processes
- `conns` - Show active ESTABLISHED connections
- `ufwstat` - UFW firewall status (verbose)
- `myip` - Display your public IP address

### **Pentest Tools**
- `scan` - Quick SYN localhost scan with nmap
- `enum4` - Full TCP port enumeration (all ports) to enum.txt
- `nmap-quick` - Fast scan of top ports only

### **Utilities**
- `cls` - Clear screen
- `ll` - Long directory listing (ls -lah)
- `h` - Launch htop system monitor
- `nf` - Show system info with neofetch
- `shot` - Flameshot GUI screenshot tool

## Test Your Installation

```bash
# After running bashconfig.sh, test the aliases
source ~/.bashrc
maint && ports && nf
```

## Notes

- The installer appends aliases to `~/.bashrc`
- If aliases already exist, they will be removed and reinstalled
- Some aliases require `sudo` privileges
- Some tools require installation: `nmap`, `htop`, `neofetch`, `flameshot`

## Requirements

- Bash shell
- Kali Linux/Debian/Ubuntu
- Optional tools: `sudo apt install nmap htop neofetch flameshot`

## Author

lexlucas | https://github.com/CMD126/bash-config
