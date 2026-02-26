# Cubix Litepaper

## Overview

This repo contains the sources of the Cubix Litepaper, an early (pre-whitepaper) and incomplete draft of Cubix and its programming language, Axi.

## Building

The build requires [Nix](https://nixos.org/). All LaTeX dependencies are managed by Nix — no system-wide TeX installation is needed.

### Local development

Enter the dev shell first (requires Nix flakes):

```sh
nix develop
```

or when flakes are not available:

```sh
nix-shell
```

Then build the PDF in place:

```sh
./build.sh
```

This produces `cubix-litepaper.pdf` in the project root.

**Run this before committing!**

### Nix build

To build via Nix (requires Nix flakes enabled):

```sh
nix build
```

or when flakes are not available:

```sh
nix-build
```

The PDF will be placed at `./result/share/pdf/cubix-litepaper.pdf`.

### Adding TeX packages

When adding a new TeX package in `cubix-litepaper.tex`, you must also add it to `default.nix` or else the build will break. In case of trouble you can ask AI for help, they are good enough to handle Nix.