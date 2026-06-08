# Simple NixOS Configuration - Good Example
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.hostPlatform = config.nixpkgs.hostPlatform;

  # User configuration
  users.users.robert = {
    username = "robert";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    description = "Robert's user account";
  };

  # Security settings
  security.sudo = {
    extraSudoers = [ 
      "ALL=(ALL:ALL) ALL"
    ];
    allowSudoWithoutPassword = {
      users = [ "robert" ];
    };
  };

  # System services
  services = {
    ssh.enable = true;
    ssh.settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      PubkeyAuthentication = true;
      PermitEmptyPasswords = false;
    };
  };

  # Enable packages
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    htop
  ];
}
