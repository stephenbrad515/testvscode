# Tests

Test cases for the NixOS code reviewer:

## Categories

- **Basic Parsing Tests**: Verify Nix expression parsing
- **Security Tests**: Test secret detection, insecure configurations
- **Best Practice Tests**: Verify best practice suggestions
- **Edge Cases**: Malformed Nix expressions, large files

## Running Tests

```bash
nix run .#test
```
