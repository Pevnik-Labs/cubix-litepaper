{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation
{
  name = "CubixLitepaper";

  meta = with pkgs.lib;
  {
    description = "Cubix litepaper";
    license = licenses.asl20;
    platforms = platforms.linux;
  };

  src = pkgs.lib.cleanSource ./.;

  nativeBuildInputs = with pkgs;
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
}
