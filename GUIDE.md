# NixOS Code Reviewer Guide

## Overview

The NixOS Code Reviewer is a static analysis tool for Nix expressions that helps identify security issues, best practice violations, and style inconsistencies.

## Features

- **Security Analysis**
  - Hardcoded secrets detection
  - Insecure SSH configurations
  - Password policy violations
  - Firewall configuration review

- **Best Practices**
  - Package version pinning recommendations
  - Import usage analysis
  - Configuration structure suggestions
  - Security hardening tips

- **Style Guidelines**
  - Consistent formatting recommendations
  - Nix idioms and patterns
  - Documentation completeness

## Installation

```bash
# Clone the repository
git clone <repository>
cd nixos-code-reviewer

# Add to your PATH (optional)
ln -s ~/workspace/nixos-code-reviewer/bin/nix-review ~/.nix-review
```

## Usage

### Analyze a Single File

```bash
nix-review analyze examples/simple.nix
```

### Lint Multiple Files

```bash
nix-review lint ./nixos-config/
```

### Quick Check

```bash
nix-review check flake.nix
```

## Options

```bash
# Help
nix-review --help

# Verbose output
nix-review -v analyze file.nix

# Quiet mode
nix-review -q lint directory/

# Strict mode
nix-review --strict analyze file.nix
```

## Exit Codes

- `0`: No issues found or issues found but not errors
- `1`: Issues found with error severity or file not found

## Common Issues

### ⚠️ Hardcoded Secrets

```nix
# Bad
users.users.robert.password = "secret123";

# Good
users.users.robert = {
  hashedPassword = config.lib.secret.readFile "/tmp/robert-pass";
};
```

### ⚠️ Insecure SSH Configuration

```nix
# Bad
services.openssh.settings.PermitEmptyPasswords = true;

# Good
services.openssh.settings.PermitEmptyPasswords = false;
```

### 💡 Package Version Pinning

```nix
# Bad
environment.systemPackages = with pkgs; [
  vim
  git
];

# Good
environment.systemPackages = with pkgs; [
  vim version = "9.0.1831"
  git version = "2.43.5"
];
```

## Integration

### Nix Flake

```nix
flake.nix
outputs = { self, nixpkgs, ... }:
  {
    packages.default = import ./nix-review.nix;
    apps."nix-review" = {
      type = "program";
      program = "${nixpkgs}/bin/nix-review";
    };
  };
```

### Pre-commit Hook

```bash
# .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: nix-review
        name: Nix Review
        entry: nix-review
        language: script
        files: \.(nix)$
```

### CI Integration

```yaml
# .github/workflows/ci.yml
jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: |
          nix-review lint ./nixos-config/
          nix-review --strict check flake.nix
```

## Development

### Adding New Rules

1. Create a rule file in `rules/` directory
2. Register in `nix-review.nix`
3. Add tests in `tests/`

### Testing

```bash
nix test .
nix run .#test
```

## Contributing

See `CONTRIBUTING.md` for guidelines.

## License

MIT License
