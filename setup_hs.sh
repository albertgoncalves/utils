#!/usr/bin/env bash

cat << 'EOF' >> $1.hs
{-# OPTIONS_GHC -Wall #-}
EOF

cat << 'EOF' >> shell.nix
{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc861" }:

let

    inherit (nixpkgs) pkgs;

    f = { mkDerivation, base, stdenv }:
        mkDerivation {
            pname = "haskell";
            version = "0";
            src = ./.;
            isLibrary = false;
            isExecutable = true;
            executableHaskellDepends = [ base
                                         haskellPackages.random
                                       ];
            license = stdenv.lib.licenses.gpl3;
        };

    haskellPackages = if compiler == "default"
                          then pkgs.haskellPackages
                      else
                          pkgs.haskell.packages.${compiler};

    drv = haskellPackages.callPackage f {};

in

    if pkgs.lib.inNixShell
        then drv.env
    else drv
EOF
