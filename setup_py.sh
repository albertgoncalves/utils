#!/usr/bin/env bash

cat << 'EOF' >> $1.py
#!/usr/bin/env python3
EOF

cat << 'EOF' >> shell.nix
{ pkgs ? import <nixpkgs> {} }:

with pkgs; mkShell {
    name = "python";

    buildInputs = [ python3
                    python36Packages.pylint
                    fzf
                  ];

    shellHook = ''
        copyfile() { cat $1 | pbcopy; }
        pylin()    { pylint -s n $1; }
        strcd()    { cd "$(dirname $1)"; }
        withfzf() {
            local h
            h=$(fzf)
            if (( $? == 0 )); then
                $1 "$h"
            fi
        }

        alias cpyfzf="withfzf copyfile"
        alias  cdfzf="withfzf strcd"
        alias pylfzf="withfzf pylin"
        alias runfzf="withfzf python3"
        alias vimfzf="withfzf vim"

        export -f copyfile
        export -f pylin
        export -f withfzf
    '';
}
EOF

cat << 'EOF' >> .pylintrc
[MESSAGES CONTROL]
disable=print-statement,
        parameter-unpacking,
        unpacking-in-except,
        old-raise-syntax,
        backtick,
        long-suffix,
        old-ne-operator,
        old-octal-literal,
        import-star-module-level,
        non-ascii-bytes-literal,
        raw-checker-failed,
        bad-inline-option,
        locally-disabled,
        locally-enabled,
        file-ignored,
        suppressed-message,
        useless-suppression,
        deprecated-pragma,
        use-symbolic-message-instead,
        apply-builtin,
        basestring-builtin,
        buffer-builtin,
        cmp-builtin,
        coerce-builtin,
        execfile-builtin,
        file-builtin,
        long-builtin,
        raw_input-builtin,
        reduce-builtin,
        standarderror-builtin,
        unicode-builtin,
        xrange-builtin,
        coerce-method,
        delslice-method,
        getslice-method,
        setslice-method,
        no-absolute-import,
        old-division,
        dict-iter-method,
        dict-view-method,
        next-method-called,
        metaclass-assignment,
        indexing-exception,
        raising-string,
        reload-builtin,
        oct-method,
        hex-method,
        nonzero-method,
        cmp-method,
        input-builtin,
        round-builtin,
        intern-builtin,
        unichr-builtin,
        map-builtin-not-iterating,
        zip-builtin-not-iterating,
        range-builtin-not-iterating,
        filter-builtin-not-iterating,
        using-cmp-argument,
        eq-without-hash,
        div-method,
        idiv-method,
        rdiv-method,
        exception-message-attribute,
        invalid-str-codec,
        sys-max-int,
        bad-python3-import,
        deprecated-string-function,
        deprecated-str-translate-call,
        deprecated-itertools-function,
        deprecated-types-field,
        next-method-defined,
        dict-items-not-iterating,
        dict-keys-not-iterating,
        dict-values-not-iterating,
        deprecated-operator-function,
        deprecated-urllib-function,
        xreadlines-attribute,
        deprecated-sys-function,
        exception-escape,
        comprehension-escape,
        missing-docstring,
        bad-whitespace,
        bad-continuation
EOF
