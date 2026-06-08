# NixOS Configuration with Issues - Bad Example (for testing)
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    # Unused import below
    # ./deprecated-modules.nix
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

  # INSECURE: Hardcoded password
  users.robert = {
    password = "admin123";
    passwordHash = null;  # Never do this in production!
  };

  # INSECURE: Sensitive file with no permissions
  fileSystems."/" = {
    device = "/dev/disk/by-label/root";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  # Missing security configuration
  # security.pam = { ... };
  # security.rtkit.enable = true;

  # Overly permissive firewall
  networking.firewall = {
    enable = true;
    allowedTCPSockets = [ "*" ];  # Allow all TCP sockets!
  };

  # INSECURE: Unnecessary services
  services.openssh = {
    enable = true;
    settings = {
      # Weak authentication
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
      PermitEmptyPasswords = true;  # Dangerous!
    };
  };

  # Unpinned package
  environment.systemPackages = with pkgs; [
    vim
    git
    # Very old, insecure package
    firefox
  ];

  # Deprecated module usage
  hardware.bluetooth.enable = true;  # Should use services.blueman
}
