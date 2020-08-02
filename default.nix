# To get a development shell use:
#   nix-shell
# To get a development shell for python2 use:
#   nix-shell --arg getPythonVersion "(p: p.python2Packages)"
# To build with pinned nixpkgs use:
#   nix build
# To develop/build with your custom nixpkgs (from $NIX_PATH) use:
#   nix-shell --arg nixpkgs "<nixpkgs>"
#   nix build --arg nixpkgs "<nixpkgs>"

{ 
  nixpkgs ? (builtins.fetchTarball {
    url  = "https://github.com/NixOS/nixpkgs/archive/3924b344254350e4bee875a3353c1093e325743f.tar.gz";
    sha256 = "0hyifn1bqy5hbjvvvh9jfqfvywq0b5qwizavi8wkrpcc989kacwn";
  })
, getPythonVersion ? (p: p.python3Packages)
, src ? builtins.fetchGit ./.
, testName ? ""
}:
let
  pkgs = import nixpkgs { };
  pyPkgs = getPythonVersion pkgs;
  pytest-metadata = pyPkgs.buildPythonPackage rec {
    pname = "pytest-metadata";
    version = "1.10.0";
    src = pyPkgs.fetchPypi {
      inherit pname version;
      sha256 = "0593jf8l30ayrqr9gkmwfbhz9h8cyqp7mgwp7ah1gjysbajf1rmp";
    };
    propagatedBuildInputs = with pyPkgs; [
      setuptools_scm
      pytest
    ];
  };
  pytest-json-report = pyPkgs.buildPythonPackage rec {
    pname = "pytest-json-report";
    version = "1.2.1";
    src = pyPkgs.fetchPypi {
      inherit pname version;
      sha256 = "0f7wva4j64hq5x2dnwvfz3jg5rjcd5jqzb82yndhdpvfiwx2m2v2";
    };
    propagatedBuildInputs = with pyPkgs; [
      pytest
      pytest-metadata
    ];
  };
in with pkgs; pyPkgs.buildPythonPackage rec {
  name = "hydra-ci-example-python";
  inherit src;
  propagatedBuildInputs = with pyPkgs; [
    numpy
    pandas
    pint
  ];

  checkInputs = with pyPkgs; [
    pytest
    pytestrunner
    pytest-flake8
    pytest-json-report
  ];
  pytestFlags = [ testName ];
  nativeBuildInputs = with pkgs; [
    jq
  ];
  meta.maintainers = [
    "Josef Kemetmueller <josef.kemetmueller@gmail.com>"
  ];
  postInstall = ''
    mkdir -p $out/nix-support/
    pytest --json-report --collect-only
    cat .report.json | jq '.collectors | .[].result | .[] | select(.type=="Function") | .nodeid' | jq --slurp '.' > $out/nix-support/pytest-tests
  '';
}
