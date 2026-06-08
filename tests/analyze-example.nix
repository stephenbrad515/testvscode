# Test: Analyze example Nix files
{
  pkgs ? import <nixpkgs> {}
}:

let
  # Simple analyzer function
  analyzeNixFile = file: builtins.readFile file;

  # Test cases
  testCases = [
    {
      name = "simple-good-example";
      file = ../examples/simple.nix;
      expectedIssues = 0;
      expectedSuggestions = 3;
    };
    {
      name = "with-issues-example";
      file = ../examples/with-issues.nix;
      expectedIssues = 4;
      expectedSuggestions = 3;
    };
  ];

in
{
  testSimple = analyzeNixFile ../examples/simple.nix;
  testWithIssues = analyzeNixFile ../examples/with-issues.nix;
  runAllTests = (testCases // { default = testWithIssues; }):
    builtins.map (tc:
      "Running test: ${tc.name}\nFile: ${tc.file}\n"
    );
}
