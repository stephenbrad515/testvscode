# Test: Hardcoded Password Detection
{
  name = "password-hardcoded-test";
  
  testCases = {
    hasPassword = {
      input = {
        username = "robert";
        password = "secret123";
      };
      expected = {
        issueFound = true;
        issueType = "hardcoded-secrets";
        message = "Hardcoded password detected";
      };
    };
    
    noPassword = {
      input = {
        username = "robert";
        shell = "/bin/bash";
      };
      expected = {
        issueFound = false;
      };
    };
  };
  
  validate = { testCases, expectedResults }:
    assert builtins.length testCases == builtins.length expectedResults;
  in true;
}
