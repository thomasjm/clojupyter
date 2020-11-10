let
  nixpkgs = import ./nixpkgs.nix;
  mvn2nix = import (fetchTarball "https://github.com/fzakaria/mvn2nix/archive/master.tar.gz") { inherit nixpkgs; };

in

mvn2nix.mvn2nix
