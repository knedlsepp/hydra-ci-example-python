# Build using:
#   nix build -f release.nix
{ nixpkgs ? <nixpkgs>
, src ? builtins.fetchGit ./.
}:
rec {
  build-python2 = (import ./default.nix) {
    inherit nixpkgs src;
    getPythonVersion = (p: p.python2Packages);
  };
  build-python3 = (import ./default.nix) {
    inherit nixpkgs src;
    getPythonVersion = (p: p.python3Packages);
  };
}
