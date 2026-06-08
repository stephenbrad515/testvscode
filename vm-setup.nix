{ config, pkgs, ... }: {
  # VM Setup for GNOME Boxes with Spice VD Agent
  # Install spice-vdagent for better mouse integration
  
  # System packages
  system.build = [
    pkgs.spice-vdagent
  ];
  
  # Services
  services.xserver = {
    enable = true;
    xkb.layout = "us";
  };
  
  # Display manager
  services.displayManager.gdm.enable = true;
  
  # User packages to install after VM boot
  users.defaultShell = pkgs.zsh;
  
  # Install recommended packages
  environment.systemPackages = with pkgs; [
    # Development tools
    vim
    git
    curl
    wget
    # Nix tools
    nixfmt-classic
    nixpkgs-fmt
    # Security tools
    htop
    neovim
    # Productivity
    firefox
    # Monitoring
    bat
    fd
    # Utilities
    eza
    jq
    tree
    # Terminal
    zsh
    zsh-shell-history-search
  ];
  
  # Desktop environment - GNOME for GNOME Boxes
  environment.variables = {
    GTK3_THEME = "Yaru-dark";
    GNOME_VERSION = "43";
  };
  
  # Vim plugin
  programs.vim = {
    enable = true;
    vimPlug.enable = true;
  };
  
  # Zsh configuration
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };
  
  # Security settings
  security = {
    sudo.wheelNeedsPassword = false;
  };
}
