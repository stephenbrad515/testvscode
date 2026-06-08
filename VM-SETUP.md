# VM Setup Guide for GNOME Boxes

This guide will help you set up a NixOS VM in GNOME Boxes with spice-vdagent for better mouse integration and code reviewer tools.

## Quick Start

### 1. Create VM in GNOME Boxes

1. **Download NixOS ISO** from https://nixos.org/download.html
2. **Create VM** in GNOME Boxes with:
   - 2-4 GB RAM
   - 20-40 GB disk space
   - Spice display protocol (if available)

### 2. Enable QEMU Spice Agent

```bash
# After first boot, install spice-vdagent
sudo pacman -S spice-vdagent

# Enable the spice-guest-agent service
sudo systemctl enable --now spice-guest-agent

# Restart the VM or reboot
sudo reboot
```

### 3. Install Code Reviewer Tools

```bash
# Clone and set up
git clone <repository-url>
cd nixos-code-reviewer

# Install using Nix
nix develop

# Or add to your path
ln -s $HOME/workspace/nixos-code-reviewer/bin/nix-review ~/.local/bin/nix-review

# Test it
nix-review analyze examples/simple.nix
```

### 4. Create Nix User Configuration

Create `~/.config/nixpkgs/nixos/configuration.nix`:

```nix
{ config, pkgs, ... }: {
  # Install spice-vdagent
  system.build = [ pkgs.spice-vdagent ];
  
  # Desktop environment
  services.xserver.enable = true;
  
  # User environment
  users.defaultShell = pkgs.zsh;
  
  # Code reviewer tools
  environment.systemPackages = with pkgs; [
    # Add your favorite tools here
  ];
  
  # Security hardening
  security.sudo.extraSudoers = [
    "ALL=(ALL) NOPASSWD: /nix/store/*/nix-review"
  ];
}
```

## Full Setup Script

Save as `~/setup-vm.sh`:

```bash
#!/usr/bin/env bash

set -e

echo "🚀 Setting up NixOS VM with Code Reviewer..."

# Update system
sudo pacman -Syu

# Install spice-vdagent
sudo pacman -S spice-vdagent

# Install recommended packages
sudo pacman -S \
  vim \
  git \
  zsh \
  curl \
  wget \
  htop \
  firefox \
  jq

# Enable spice-guest-agent
sudo systemctl enable --now spice-guest-agent

# Set up user environment
mkdir -p ~/.config/zsh
cp ~/.nix-review ~/.local/bin/ 2>/dev/null || true

echo "✅ Setup complete!"
echo "Run: nix-review analyze <file>"
```

Make executable and run:

```bash
chmod +x ~/setup-vm.sh
~/setup-vm.sh
```

## Troubleshooting

### Mouse Not Working Well

```bash
# Check if spice-vdagent is running
sudo systemctl status spice-guest-agent

# Restart it
sudo systemctl restart spice-guest-agent
```

### Display Issues

```bash
# Install xorg drivers
sudo pacman -S xorg-server xorg-xauth

# Set proper display manager
sudo systemctl enable gdm
```

### Permissions

```bash
# Set proper permissions for nix-review
sudo chmod 755 ~/.local/bin/nix-review
sudo chown $USER:$USER ~/.local/bin/nix-review
```

## Verification

Check that everything is working:

```bash
# Check spice-vdagent
spice-vdagent --version

# Run code reviewer
nix-review --help
```

## Next Steps

1. Configure your user in `~/.config/nixpkgs/nixos/user.nix`
2. Add code reviewer to your development shell
3. Create your first NixOS configuration
4. Run `nix-review analyze` on your configs

## Resources

- [GNOME Boxes Documentation](https://docs.gnome.org/boxes/)
- [Spice Guest Agent](https://spice-space.org/spice-docs/protocols/protocols-guest-agent.html)
- [NixOS Configuration](https://nixos.wiki/wiki/Configuration)
- [Code Reviewer Guide](./GUIDE.md)
