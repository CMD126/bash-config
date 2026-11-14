# bashconfig.sh Installation Guide

## Overview

`bashconfig.sh` is an automated installer that adds useful Bash aliases and functions to your `~/.bashrc` file. It's optimized for Kali Linux, Ubuntu, and Debian-based distributions.

## Quick Start

```bash
# Option 1: Direct installation
chmod +x bashconfig.sh
./bashconfig.sh

# Option 2: From any directory
bash /path/to/bashconfig.sh

# Option 3: One-liner from GitHub
bash -c "$(curl -fsSL https://raw.githubusercontent.com/CMD126/bash-config/main/bashconfig.sh)"
```

After installation, reload your shell:
```bash
source ~/.bashrc
```

## What Gets Installed

### Aliases

**System Maintenance**
- `update` - Full apt update + upgrade
- `ifix` - Install fix for broken packages
- `fix` - Fix broken/missing packages
- `clean` - Autoclean + autoremove
- `maint` - Complete maintenance chain

**Network & Security**
- `ports` - List listening ports
- `portsfull` - Show ports with processes
- `conns` - Show active connections
- `ufwstat` - UFW firewall status
- `myip` - Display public IP address

**Pentest & Scanning**
- `scan` - Quick SYN scan on localhost
- `nmap-quick` - Fast scan of top ports
- `enum4` - Full TCP enumeration (function)

**Utilities**
- `cls` - Clear screen
- `ll` - Long directory listing
- `h` - Launch htop
- `nf` - Show neofetch system info
- `shot` - Flameshot screenshot tool

### Functions

**enum4()**
```bash
enum4 <target> [output_file]
```
Performs a full TCP port enumeration scan on the target and saves results to a file.

Examples:
```bash
enum4 127.0.0.1             # Saves to enum4_127.0.0.1_<date>.txt
enum4 192.168.1.1 scan.txt  # Scan with custom output file
```

## Requirements

- Bash shell
- sudo access
- apt (Debian/Ubuntu package manager)
- Optional tools: nmap, htop, neofetch, flameshot, curl, ss

Install optional tools:
```bash
sudo apt install nmap htop neofetch flameshot curl net-tools
```

## Testing Your Installation

Test all features:
```bash
# Test aliases
maint && ports && nf

# Test enum4 function
enum4 127.0.0.1
```

## Uninstallation

```bash
./bashconfig.sh --uninstall
source ~/.bashrc
```

The installer only touches the block between these two markers, so the rest of your `~/.bashrc` is never modified:
```bash
# >>> bash-config (CMD126) >>>
# <<< bash-config (CMD126) <<<
```
A timestamped backup (`~/.bashrc.bak.<date>`) is created before every install or uninstall.

## Reinstallation

The script automatically removes old blocks before reinstalling, so you can safely run it multiple times:
```bash
./bashconfig.sh  # Replaces the existing block (also cleans up blocks from older versions)
```

## Troubleshooting

**Issue: "command not found" for aliases**
- Run `source ~/.bashrc` to reload the configuration

**Issue: sudo password prompts for every alias**
- This is expected for aliases that require root access
- Configure sudo for passwordless access if desired

**Issue: Some tools not found**
- Install optional dependencies: `sudo apt install nmap htop neofetch`

## Author

lexlucas | https://github.com/CMD126/bash-config

## Support

For issues and feature requests, visit:
https://github.com/CMD126/bash-config
