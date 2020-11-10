let
  nixpkgs = import ./nixpkgs.nix;
  pkgs = import nixpkgs {};

  mvn2nix = import (fetchTarball "https://github.com/fzakaria/mvn2nix/archive/master.tar.gz") { inherit nixpkgs; };
  mavenRepository = mvn2nix.buildMavenRepository { dependencies = import ./dependencies.nix; };
  inherit (pkgs) lib stdenv jdk11_headless maven makeWrapper;
  inherit (stdenv) mkDerivation;

in

mkDerivation rec {
  pname = "clojupyter";
  version = "0.3.2";
  name = "${pname}-${version}";

  src = lib.cleanSource ./.;

  buildInputs = [ jdk11_headless maven makeWrapper ];
  buildPhase = ''
    echo "Building with maven repository ${mavenRepository}"
    mvn package --offline -Dmaven.repo.local=${mavenRepository}
  '';

  installPhase = ''
    # create the bin directory
    mkdir -p $out/bin

    # create a symbolic link for the lib directory
    ln -s ${mavenRepository}/.m2 $out/lib

    echo "TARGET CONTENTS:"
    ls -lh target

    # copy out the JAR
    # Maven already setup the classpath to use m2 repository layout
    # with the prefix of lib/
    cp target/${name}.jar $out/

    # create a wrapper that will automatically set the classpath
    # this should be the paths from the dependency derivation
    makeWrapper ${jdk11_headless}/bin/java $out/bin/${pname} \
          --add-flags "-jar $out/${name}.jar"
  '';
}
