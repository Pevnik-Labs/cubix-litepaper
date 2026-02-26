{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation
{
  name = "CubixLitepaper";

  meta = with pkgs.lib;
  {
    description = "Cubix litepaper";
    license = licenses.isc;
    platforms = platforms.linux;
  };

  src = pkgs.lib.cleanSource ./.;

  enableParallelBuilding = true;

  buildInputs = with pkgs;
  [
    (texlive.combine
    {
      inherit (texlive)
        scheme-small

        # Build tool.
        latexmk

        # Graphics.
        pgf         # provides tikz

        # Font packages.
        collection-fontsrecommended
        ly1
        sourcecodepro

        # Math.
        mathpartir
        stmaryrd

        # Layout and tables.
        enumitem
        appendix
        ;
    })
    glibcLocales
  ];

  buildPhase =
  ''
    patchShebangs ./build.sh
    ./build.sh
  '';

  installPhase =
  ''
    INSTALLPATH=$out/share/pdf/

    mkdir -p $INSTALLPATH
    cp cubix-litepaper.pdf $INSTALLPATH/
  '';

  shellHook =
  ''
    GREEN="\033[1;32m"
    RESET="\033[0m"

    export PROJECT_ROOT=$(pwd)
    export PS1="\n\[''${GREEN}\]CubixLitepaper\''${PWD#\''$PROJECT_ROOT}>\[''${RESET}\] "

    echo ""
    echo -e "Cubix Litepaper"
    echo ""
    echo -e "''${GREEN}./build.sh''${RESET}   — Build the litepaper locally (required before committing)"
    echo -e "''${GREEN}nix build''${RESET}    — Build and install (requires Nix flakes)"
    echo -e "''${GREEN}nix develop''${RESET}  — Enter a Nix dev shell (requires Nix flakes)"
    echo -e "''${GREEN}nix-shell''${RESET}    — Enter a legacy Nix dev shell"
  '';
}
