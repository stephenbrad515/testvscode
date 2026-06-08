# Static Analysis Rules

This directory contains static analysis rules for NixOS configurations:

## Rule Categories

### Imports
- Unused imports
- Circular dependencies
- Deprecated package imports

### Outputs
- Unused outputs
- Dangerous public outputs
- Missing output metadata

### Overlays
- Overlay dependency chains
- Duplicate overlay definitions
- Overlays that break existing packages

### Best Practices
- Use of let bindings for constants
- Module arguments structure
- Configuration composition

## Rule Format

```nix
{
  name = "unused-import";
  severity = "warning";
  message = "Unused import detected";
  pattern = "...";
  fixes = [ ... ];
}
```
