{ pkgs ? import <nixpkgs> {} }:

with pkgs;

stdenv.mkDerivation {
  name = "Cubix litepaper";
  buildInputs = [ (texlive.combine {
                    inherit (texlive)
                      scheme-small

                      # Add other LaTeX libraries (packages) here as needed:
                      collection-fontsrecommended
                      ly1
                      mathpartir
                      sourcecodepro
                      stmaryrd
                      appendix

                      # build tools
                      latexmk
                      ;
                  })
                  glibcLocales
                ];
  src = ./.;

  meta = with lib; {
    description = "Cubix litepaper";
    license = licenses.isc;
    platforms = platforms.linux;
  };
}
