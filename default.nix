# To get a development shell use:
#   nix-shell
# To build with pinned nixpkgs use:
#   nix build
# To develop/build with your custom nixpkgs (from $NIX_PATH) use:
#   nix-shell --arg nixpkgs "<nixpkgs>"
#   nix build --arg nixpkgs "<nixpkgs>"

{ nixpkgs ? (builtins.fetchGit {
    url = git://github.com/NixOS/nixpkgs-channels;
    ref = "nixos-18.03";
    rev = "08d245eb31a3de0ad73719372190ce84c1bf3aee";
  })
, getPythonVersion ? (p: p.python3Packages)
, src ? builtins.fetchGit ./.
}:
let
  overlays = [ ];
  pkgs = import nixpkgs { inherit overlays; config = { }; };
  pyPkgs = getPythonVersion pkgs;
in with pkgs; pyPkgs.buildPythonPackage rec {
  name = "hydra-ci-example-python";
  inherit src;
  propagatedBuildInputs = with pyPkgs; [
    numpy
    pandas
    pint
    pytest
    pytestrunner
  ];

  meta.maintainers = [ 
    "Josef Kemetmueller <josef.kemetmueller@gmail.com>"
  ]; 
}