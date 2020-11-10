let
  nixpkgs = import ./nixpkgs.nix;
  pkgs = import nixpkgs {};
  mvn2nix = import (fetchTarball "https://github.com/fzakaria/mvn2nix/archive/master.tar.gz") { inherit nixpkgs; };

in

with pkgs;

runCommand "leiningen-with-clojure" { buildInputs = [makeWrapper]; } ''
  mkdir -p $out/bin/
  makeWrapper ${leiningen}/bin/lein $out/bin/lein --suffix PATH ":" ${clojure}/bin
''
