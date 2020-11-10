#!/usr/bin/env bash
set -euo pipefail

$(nix-build ./nix/lein.nix --no-out-link)/bin/lein pom
$(nix-build ./nix/mvn2nix.nix --no-out-link)/bin/mvn2nix pom.xml
