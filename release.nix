{
  build-python2 = (import ./default.nix) {
    getPythonVersion = (p: p.python2Packages);
  };
  build-python3 = (import ./default.nix) {
    getPythonVersion = (p: p.python3Packages);
  };
}
