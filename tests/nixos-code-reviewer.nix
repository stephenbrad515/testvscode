{
  pkgs ? import <nixpkgs> {}
}:

let
  # Nix expression analyzer
  nixAnalyzer = {
    # Analyze a Nix file for security issues
    analyze = file:
      let
        content = builtins.readFile file;
      in
      {
        securityIssues = [
          # Check for hardcoded secrets
          (if (builtins.matchStrings content "\\b(password|secret|token|api[_-]?key)\\s*=\\s*['\"]?[a-zA-Z0-9!@#\\$%^&*()_+=\\-\\[\\]{}|:;<>?/~`\\-]+['\"]?") != null then
            "potential-hardcoded-secrets"
          else "")
          # Check for PermitEmptyPasswords = true
          (if (builtins.matchStrings content "PermitEmptyPasswords\\s*=\\s*true") != null then
            "insecure-permit-empty-passwords"
          else "")
          # Check for overly permissive firewall
          (if (builtins.matchStrings content "allowedTCPSockets\\s*=\\s*\\[\\s*\"\\*\"") != null then
            "overly-permissive-firewall"
          else "")
          # Check for passwordHash = null
          (if (builtins.matchStrings content "passwordHash\\s*=\\s*null") != null then
            "insecure-password-hash-null"
          else "")
          # Check for weak SSH settings
          (if (builtins.matchStrings content "PasswordAuthentication\\s*=\\s*true") != null &&
              (builtins.matchStrings content "PermitRootLogin\\s*=\\s*yes") != null then
            "insecure-ssh-config"
          else "")
          # Check for unpinned packages
          (if (builtins.matchStrings content "\\b[\\w\\.]+\\s*\\(\\n\\s*\\n\\s*\\n\\s*\\n\\s*\\b[\\w\\.]+\\b\\)") != null then
            "unpinned-packages"
          else "")
        ];
        
        # Suggest improvements
        suggestions = [
          # Suggest using envsubst for secrets
          "Consider using envsubst or secrets manager for credentials"
          # Suggest pinning packages
          "Pin package versions for reproducibility"
          # Suggest secure defaults
          "Use secure defaults for services"
          # Suggest avoiding hardcoded values
          "Avoid hardcoded passwords and tokens"
          # Suggest firewall hardening
          "Restrict firewall rules to necessary services only"
        ];
        
        # Summary
        summary = 
          "=== NixOS Code Review ===\n\n" +
          "File: ${builtins.baseNameOf file}\n\n" +
          "Security Issues Found: ${toString (builtins.length securityIssues)}\n\n" +
          "Issues:\n  ${concatMapStrings (issue: "  ⚠️  " + issue + "\n") securityIssues}\n\n" +
          "Suggestions:\n  ${concatMapStrings (suggestion: "  💡  " + suggestion + "\n") suggestions}";
      };
  };

in
nixAnalyzer
# Build command
rec {
  default = nixAnalyzer;
  analyze = nixAnalyzer.analyze;
}
