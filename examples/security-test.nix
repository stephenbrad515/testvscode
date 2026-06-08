# Test file: Contains various security issues
# Use this to test the code reviewer
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Issue 1: Hardcoded secret
  environment.etc."test-secrets".source = ../test-passwords.conf;

  # Issue 2: Unpinned package
  environment.systemPackages = with pkgs; [
    vim
    # Missing version pinning
    gcc
  ];

  # Issue 3: Overly permissive firewall
  networking.firewall.allowedTCPSockets = [ "1863/tcp" "22/tcp" ];

  # Issue 4: Sudo without password for all users
  security.sudo.extraSudoers = [
    "%wheel ALL=(ALL) NOPASSWD:ALL"
    "ALL=(ALL) NOPASSWD:ALL"
  ];
}
