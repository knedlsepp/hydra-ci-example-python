let
  package = import ./. { };
  testNames = builtins.fromJSON (
      builtins.readFile (package+"/nix-support/pytest-tests")
    );
  pkgs = import <nixpkgs> {};
  runTests = testName: package.override { inherit testName; };
in builtins.map runTests testNames 