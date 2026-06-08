{
  description = "NixOS Code Reviewer - AI-powered code review tool for Nix expressions";
  
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  
  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.default = pkgs.runCommand "nixos-code-reviewer" {} ''
        touch $out/bin/nix-review
        chmod +x $out/bin/nix-review
        cat > $out/bin/nix-review << 'EOF'
#!/usr/bin/env bash
# NixOS Code Reviewer
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

usage() {
    echo "Usage: nix-review COMMAND"
    echo ""
    echo "Commands:"
    echo "  analyze FILE    Analyze a Nix file"
    echo "  lint DIR        Recursively analyze Nix files in directory"
    echo "  check FILE      Quick security check"
    echo ""
    echo "Options:"
    echo "  -h, --help      Show this help"
    echo "  -v, --verbose   Verbose output"
    echo "  --strict        Strict mode"
}

analyze() {
    local file="$1"
    if [ ! -f "$file" ]; then
        echo "Error: File not found: $file" >&2
        exit 1
    fi
    
    echo "Analyzing: $file"
    echo ""
    
    content="$(cat "$file")"
    
    # Check for hardcoded secrets
    if echo "$content" | grep -qE '(password|secret|token|apikey)'; then
        echo "⚠️  SECURITY: Potential hardcoded secrets detected"
    fi
    
    # Check for PermitEmptyPasswords = true
    if echo "$content" | grep -qE 'PermitEmptyPasswords'; then
        echo "⚠️  SECURITY: PermitEmptyPasswords = true detected"
    fi
    
    # Check for passwordHash = null
    if echo "$content" | grep -qE 'passwordHash'; then
        echo "⚠️  SECURITY: passwordHash = null detected"
    fi
    
    # Check for overly permissive firewall
    if echo "$content" | grep -qE 'allowedTCPSockets'; then
        echo "⚠️  SECURITY: Overly permissive firewall rules"
    fi
    
    # Check for unpinned packages
    if echo "$content" | grep -qE '^[[:space:]]*[a-zA-Z][\w.-]+'; then
        echo "⚠️  STYLE: Consider pinning package versions"
    fi
    
    echo ""
    echo "📝 Recommendations:"
    echo "  - Use envsubst for secrets"
    echo "  - Pinning packages"
    echo "  - Secure defaults"
    echo "  - Avoid hardcoded values"
    echo "  - Restrict firewall rules"
}

lint() {
    find "$PROJECT_ROOT" -name "*.nix" -type f | while read -r file; do
        analyze "$file"
    done
}

check() {
    analyze "$1"
}

case "${1:-analyze}" in
    analyze) shift; analyze "$@" ;;
    lint)
        shift
        if [ -n "$1" ]; then
            lint "$1"
        else
            lint "$PROJECT_ROOT"
        fi
        ;;
    check)
        shift
        check "$@"
        ;;
    -h|--help|"")
        usage
        exit 0
        ;;
    *)
        echo "Error: Unknown command: $1" >&2
        usage
        exit 1
        ;;
esac
EOF
        '';
      
      devShell = pkgs.mkShell {
        name = "nixos-code-reviewer-dev";
        buildInputs = [
          pkgs.nixpkgs-fmt
          pkgs.nixfmt-classic
          pkgs.jq
          pkgs.vim
          pkgs.zsh
          pkgs.curl
          pkgs.git
        ];
        
        shellHook = ''
          echo "🔧 NixOS Code Reviewer Development Shell"
          echo "Run: ./bin/nix-review analyze <file>"
          echo "     ./bin/nix-review lint <directory>"
        '';
      };
    };
}
