#!/usr/bin/env bash
# NixOS Code Reviewer - CLI wrapper
# Analyzes Nix expressions for security and best practices

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] COMMAND

NixOS Code Reviewer - Static analysis for Nix expressions

Commands:
    analyze FILE    Analyze a single Nix file
    lint DIR        Recursively analyze Nix files in directory
    check FILE      Quick security check (simplified)

Options:
    -h, --help      Show this help message
    -v, --verbose   Enable verbose output
    -q, --quiet     Suppress non-error output
    --strict        Enable strict mode (all warnings as errors)

Examples:
    $(basename "$0") analyze examples/simple.nix
    $(basename "$0") lint ./nixos-config/
    $(basename "$0") check flake.nix

EOF
    exit 0
}

verbose=""
quiet=false
strict=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            ;;
        -v|--verbose)
            verbose="-v"
            shift
            ;;
        -q|--quiet)
            quiet=true
            shift
            ;;
        --strict)
            strict=true
            shift
            ;;
        -*)
            echo "Error: Unknown option: $1" >&2
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

COMMAND="${1:-analyze}"
SHIFTED=1

case $COMMAND in
    analyze|lint|check)
        ;;
    *)
        echo "Error: Unknown command: $COMMAND" >&2
        usage
        ;;
esac

# Run analysis using nix-review.nix
if [ -f "$PROJECT_ROOT/nix-review.nix" ]; then
    nix eval "$PROJECT_ROOT/nix-review.nix" -- "$PROJECT_ROOT/$COMMAND" --verbose 2>/dev/null || \
    nix build "$PROJECT_ROOT" --output out 2>/dev/null && \
    echo "Analysis complete" || true
else
    echo "Error: Main analysis engine not found at $PROJECT_ROOT/nix-review.nix" >&2
    exit 1
fi
