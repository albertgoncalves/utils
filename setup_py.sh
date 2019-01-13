#!/usr/bin/env bash

cat << 'EOF' >> $1.py
#!/usr/bin/env python3
EOF

cat << 'EOF' >> shell.nix
{ pkgs ? import <nixpkgs> {} }:
with pkgs; mkShell {
    name = "Python";
    buildInputs = [ python3
                    python36Packages.flake8
                    fzf
                  ];
    shellHook = ''
        copyfile() { cat $1 | pbcopy; }
        strcd() { cd "$(dirname $1)"; }
        withfzf() {
            local h
            h=$(fzf)
            if (( $? == 0 )); then
                $1 "$h"
            fi
        }

        alias flake8="flake8 --ignore E124,E128,E201,E203,E241,W503"
        alias cdfzf="withfzf strcd"
        alias cpyfzf="withfzf copyfile"
        alias flafzf="withfzf flake8"
        alias runfzf="withfzf python3"
        alias vimfzf="withfzf vim"

        export -f copyfile
        export -f withfzf
    '';
}
EOF
