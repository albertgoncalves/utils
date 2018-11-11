#!/usr/bin/env bash

cat << 'EOF' >> $1.hs
{-# OPTIONS_GHC -Wall #-}
EOF

cat << 'EOF' >> shell.nix
{ pkgs ? import <nixpkgs> {} }:

with pkgs; mkShell {
    name = "haskell";
    buildInputs = [ (haskell.packages.ghc861.ghcWithPackages (pkgs: [
                      pkgs.base
                    ]))
                    haskellPackages.hlint
                    libiconv
                    fzf
                  ];
    shellHook = ''
        withfzf() { $1 "$(fzf)"; }
        alias vimfzf="withfzf vim"
        alias runfzf="withfzf runhaskell"
        alias hlifzf="withfzf hlint -c=never"
    '';
}
EOF
