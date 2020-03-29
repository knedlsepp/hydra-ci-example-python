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
, getPythonVersion ? (p: p.python2Packages)
, src ? builtins.fetchGit ./.
}:
let
  pkgs = import nixpkgs { };
  pyPkgs = getPythonVersion pkgs;
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
  ];

  meta.maintainers = [
    "Josef Kemetmueller <josef.kemetmueller@gmail.com>"
  ];
}
