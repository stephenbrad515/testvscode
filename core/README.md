# Core Analysis Engine

The core module handles Nix expression parsing and static analysis:

- **Nix AST Parsing:** Parse Nix expressions using the Nix parser
- **Dependency Resolution:** Track package dependencies and imports
- **Type Inference:** Basic type checking for Nix expressions
- **Pattern Matching:** Identify common Nix patterns and anti-patterns

## Key Components

- `nix_parser.nix` - Nix expression parser wrapper
- `dependency_analyzer.nix` - Track imports and outputs
- `type_checker.nix` - Basic type inference
- `pattern_matcher.nix` - Detect idioms and anti-patterns

## Usage

```nix
(import ./nix_parser.nix { }).parseExpression "<nix-code>"
```
