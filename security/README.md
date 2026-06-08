# Security Analysis

Security-focused linting and hardening rules:

## Checks

### Secrets Detection
- Hardcoded passwords/tokens
- Sensitive files in paths
- Unencrypted secrets

### Network Hardening
- Unnecessary network services
- Open ports
- Firewall rules

### Package Security
- Known vulnerable packages
- Outdated dependencies
- Unpinned package versions

### System Hardening
- Sudo configurations
- User creation policies
- File permissions

## Example Rule

```nix
{
  name = "hardcoded-secrets";
  severity = "error";
  message = "Potential secret detected in configuration";
  pattern = "\\b(password|secret|token)\\s*=\\s*[^\\\"']";
}
```
