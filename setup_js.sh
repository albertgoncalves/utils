#!/usr/bin/env bash

cat << 'EOF' >> style.css
html, body {
    font-family: Verdana, Geneva, sans-serif;
}
EOF

cat << 'EOF' >> index.html
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <link rel="stylesheet" href="./style.css">
    </head>
    <body>
        <script src="./script.js"></script>
    </body>
</html>
EOF

cat << 'EOF' >> .jshintc
{ "esversion": 6
, "laxcomma" : true
}
EOF

cat << 'EOF' >> shell.nix
{ pkgs ? import <nixpkgs> {} }:

with pkgs; mkShell {
    name = "jshint";

    buildInputs = [ htmlTidy
                    nodejs
                  ];

    shellHook = ''
        if [ ! -e node_modules/.bin/jshint ]
        then
            npm install --save-dev jshint
        fi

        export PATH="$PWD/node_modules/.bin/:$PATH"
    '';
}
EOF
