#!/usr/bin/env bash

cat << 'EOF' >> $1.R
#!/usr/bin/env Rscript
EOF

cat << 'EOF' >> shell.nix
with import <nixpkgs> {};

stdenv.mkDerivation {
    name = "R";

    buildInputs = [ R
                    rPackages.lintr
                  ];

    shellHook = ''
        copyfile() { cat $1 | pbcopy; }
        export -f copyfile
    '';
}
EOF

cat << 'EOF' >> .lintr
linters: with_defaults( infix_spaces_linter = NULL
                      , object_usage_linter = NULL
                      , assignment_linter   = NULL
                      , camel_case_linter   = NULL
                      , NULL
                      )
EOF
