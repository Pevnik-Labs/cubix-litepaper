{ pkgs ? import <nixpkgs> {} }:

let
  litepaper = import ./default.nix { inherit pkgs; };
in

pkgs.mkShell
{
  inputsFrom =
  [
    litepaper
  ];

  shellHook =
  ''
    GREEN="\033[1;32m"
    RESET="\033[0m"

    export PROJECT_ROOT=$(pwd)
    export PS1="\n\[''${GREEN}\]CubixLitepaper\''${PWD#\''$PROJECT_ROOT}>\[''${RESET}\] "

    echo ""
    echo "Cubix Litepaper development shell"
    echo ""
    echo -e "''${GREEN}./build.sh''${RESET} — Build the litepaper locally (required before committing)"
  '';
}
