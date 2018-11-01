#!/usr/bin/env bash

cat << 'EOF' >> $1.py
#!/usr/bin/env python
EOF

cat << 'EOF' >> shell.sh
#!/usr/bin/env bash

nix-shell -p 'python3.withPackages(ps: with ps; [ numpy ])'
EOF
