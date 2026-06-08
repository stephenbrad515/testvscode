# Development Guide

## Architecture

This project is built with Nix and leverages the powerful Nix language itself for code analysis.

### Components

```
├── nix-review.nix      # Main analysis engine
├── core/               # Core parsing and analysis modules
├── security/           # Security-focused rules
├── rules/              # Static analysis rules
├── tests/              # Test cases
└── examples/           # Sample configurations
```

## Getting Started

### Prerequisites

- Nix installed (2.13 or later)
- NixOS (optional, for running but not required)

### Installation

```bash
cd nixos-code-reviewer
nix develop
```

### Usage

```bash
# Analyze a Nix file
nix run .#nix-review analyze examples/simple.nix

# Run in lint mode (continuous checking)
nix run .#nix-review lint ./flake.nix

# Run tests
nix test .
```

## Development Workflow

1. **Implement a new rule**: Add to `security/` or `rules/`
2. **Write tests**: Create test case in `tests/`
3. **Add documentation**: Update appropriate README
4. **CI integration**: Add to `.github/workflows/ci.yml`

## Building

```bash
# Development shell
nix develop

# Build release
nix build

# Run all tests
nix test .
```

## Contributing

See `CONTRIBUTING.md` for guidelines.

## License

MIT License
