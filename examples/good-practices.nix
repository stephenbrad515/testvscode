# Good Practices Example
# Use this as a reference for proper NixOS configuration
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Pin packages to specific versions
  environment.systemPackages = with pkgs; [
    vim version = "9.0.1831"
    git version = "2.43.5"
    curl version = "8.14.0"
    htop version = "3.0.5"
  ];

  # Users without hardcoded credentials
  users.users.robert = {
    username = "robert";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    description = "Robert's user account";
    # Use envsubst or secrets manager for credentials
  };

  # Secure SSH configuration
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      PubkeyAuthentication = true;
      PermitEmptyPasswords = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
      AllowTcpForwarding = false;
    };
  };

  # Proper firewall rules
  networking.firewall = {
    enable = true;
    # Only allow necessary services
    allowedTCPSockets = [ "22/tcp" ];
    allowedUDPSockets = [ "53/udp" ];
    # Use iptables to allow loopback
  };

  # User accounts with proper policies
  users.users = {
    robert = {
      password = "secret";  # Should use envsubst or secrets
      hashedPassword = "${config.lib.secret.readFile "/tmp/robert-pass"}";
    };
  };

  # Systemd services
  systemd.services = {
    myservice = {
      enable = true;
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = "5s";
        LimitNOFILE = 65536;
        ProtectSystem = "strict";
        PrivateTmp = true;
        PrivateDevices = true;
        ReadWritePaths = "/var/lib/myservice";
        ReadOnlyPaths = "/usr /etc";
        ProtectHome = true;
        NoNewPrivileges = true;
        CapabilityBoundingSet = "";
        AmbientCapabilities = "";
        SystemCallFilter = "@system-service @privileged @mount";
      };
    };
  };

  # Security hardening
  security = {
    rtkit.enable = true;
    pam = {
      limit = {
        pamName = "limit";
        type = "sys";
      };
    };
  };

  # File permissions
  fileSystems."/" = {
    device = "/dev/disk/by-label/root";
    fsType = "ext4";
    options = [ "noatime" "nodiratime" ];
  };

  # Network configuration
  networking = {
    firewall.enable = true;
    # DNS settings
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    # DNS over TLS
    # dns = { ... };
  };
}
