#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
POOL_DIR="$ROOT_DIR/apt/pool/main"
BUILD_TMP="/tmp/termux_deb_build"

TERMUX_PREFIX="/data/data/com.termux/files/usr"

rm -rf "$BUILD_TMP"
mkdir -p "$BUILD_TMP" "$POOL_DIR"

build_pkg() {
    local name="$1"
    local version="$2"
    local desc="$3"
    local depends="$4"
    local setup_func="$5"

    local pkg_dir="$BUILD_TMP/${name}_${version}_all"
    local debian_dir="$pkg_dir/DEBIAN"
    local prefix_dir="$pkg_dir$TERMUX_PREFIX"

    echo "==> Building Termux native package: $name ($version)..."
    mkdir -p "$debian_dir" "$prefix_dir/bin" "$prefix_dir/share/doc/$name"

    cat << EOF > "$debian_dir/control"
Package: $name
Version: $version
Architecture: all
Maintainer: zyekhabdul <zyekhabdulqadirjailani@gmail.com>
Depends: $depends
Section: utils
Priority: optional
Description: $desc
EOF

    # Execute custom file population
    $setup_func "$pkg_dir" "$prefix_dir"

    dpkg-deb --build --root-owner-group "$pkg_dir" "$POOL_DIR/${name}_${version}_all.deb"
    echo "    [ CREATED ] $POOL_DIR/${name}_${version}_all.deb"
}

setup_sshm() {
    local pkg_dir="$1"
    local prefix="$2"
    sed 's|#!/usr/bin/env bash|#!/data/data/com.termux/files/usr/bin/bash|' \
        /home/aomiqaza/Projects/sshm/bin/sshm > "$prefix/bin/sshm"
    chmod 755 "$prefix/bin/sshm"
    cp /home/aomiqaza/Projects/sshm/README.md "$prefix/share/doc/sshm/"
    cp /home/aomiqaza/Projects/sshm/LICENSE "$prefix/share/doc/sshm/copyright"
}

setup_agy_quota() {
    local pkg_dir="$1"
    local prefix="$2"
    local py_dest="$prefix/lib/python3/dist-packages"
    mkdir -p "$py_dest"
    cp -r /home/aomiqaza/Projects/agy-quota/src/agy_quota "$py_dest/"

    cat << 'EOF' > "$prefix/bin/agy-quota"
#!/data/data/com.termux/files/usr/bin/bash
export PYTHONPATH="/data/data/com.termux/files/usr/lib/python3/dist-packages:$PYTHONPATH"
exec /data/data/com.termux/files/usr/bin/python3 -m agy_quota.cli "$@"
EOF
    chmod 755 "$prefix/bin/agy-quota"
    ln -sf agy-quota "$prefix/bin/agy-tokens"
    cp /home/aomiqaza/Projects/agy-quota/README.md "$prefix/share/doc/agy-quota/"
    cp /home/aomiqaza/Projects/agy-quota/LICENSE "$prefix/share/doc/agy-quota/copyright"
}

setup_markora() {
    local pkg_dir="$1"
    local prefix="$2"
    local py_dest="$prefix/lib/python3/dist-packages"
    mkdir -p "$py_dest"
    cp -r /home/aomiqaza/Projects/markora/src/markora "$py_dest/"

    cat << 'EOF' > "$prefix/bin/markora"
#!/data/data/com.termux/files/usr/bin/bash
export PYTHONPATH="/data/data/com.termux/files/usr/lib/python3/dist-packages:$PYTHONPATH"
exec /data/data/com.termux/files/usr/bin/python3 -m markora.cli "$@"
EOF
    chmod 755 "$prefix/bin/markora"
    ln -sf markora "$prefix/bin/td"
    ln -sf markora "$prefix/bin/mo"
    cp /home/aomiqaza/Projects/markora/README.md "$prefix/share/doc/markora/"
    cp /home/aomiqaza/Projects/markora/LICENSE "$prefix/share/doc/markora/copyright"
}

setup_vol3_suite() {
    local pkg_dir="$1"
    local prefix="$2"
    local py_dest="$prefix/lib/python3/dist-packages"
    mkdir -p "$py_dest"
    cp -r /home/aomiqaza/Projects/volatility3-cyber-suite/vol3_suite "$py_dest/"

    cat << 'EOF' > "$prefix/bin/vol3-suite"
#!/data/data/com.termux/files/usr/bin/bash
export PYTHONPATH="/data/data/com.termux/files/usr/lib/python3/dist-packages:$PYTHONPATH"
exec /data/data/com.termux/files/usr/bin/python3 -m vol3_suite.cli "$@"
EOF
    chmod 755 "$prefix/bin/vol3-suite"
    ln -sf vol3-suite "$prefix/bin/vol-ai-triage"
    ln -sf vol3-suite "$prefix/bin/ebpf-detector"
    cp /home/aomiqaza/Projects/volatility3-cyber-suite/README.md "$prefix/share/doc/vol3-suite/"
    cp /home/aomiqaza/Projects/volatility3-cyber-suite/LICENSE "$prefix/share/doc/vol3-suite/copyright"
}

setup_agy_guard() {
    local pkg_dir="$1"
    local prefix="$2"
    local py_dest="$prefix/lib/python3/dist-packages"
    mkdir -p "$py_dest"
    cp -r /home/aomiqaza/Projects/agy-guard/src/agy_guard "$py_dest/"

    cat << 'EOF' > "$prefix/bin/agy-guard"
#!/data/data/com.termux/files/usr/bin/bash
export PYTHONPATH="/data/data/com.termux/files/usr/lib/python3/dist-packages:$PYTHONPATH"
exec /data/data/com.termux/files/usr/bin/python3 -m agy_guard.cli "$@"
EOF
    chmod 755 "$prefix/bin/agy-guard"
    cp /home/aomiqaza/Projects/agy-guard/README.md "$prefix/share/doc/agy-guard/"
    cp /home/aomiqaza/Projects/agy-guard/LICENSE "$prefix/share/doc/agy-guard/copyright"
}

# Clean old deb files in pool
rm -f "$POOL_DIR"/*.deb

build_pkg "sshm" "1.1.0" "Interactive SSH Fuzzy Manager with Live Metadata Preview" "bash, openssh, fzf" setup_sshm
build_pkg "agy-quota" "1.2.1" "Antigravity Multi-Account Token & Quota Bulk Checker" "python" setup_agy_quota
build_pkg "markora" "1.0.0" "Sovereign Markor-style Markdown Notebook, QuickNotes & Todo TUI" "python" setup_markora
build_pkg "vol3-suite" "2.0.0" "Unified Memory Forensics, eBPF Rootkit Detection, and AI-Driven Incident Triage Suite" "python" setup_vol3_suite
build_pkg "agy-guard" "3.0.1" "Deterministic AI Agent Governance, AST Blast-Radius Scanner & Verification Harness" "python" setup_agy_guard

rm -rf "$BUILD_TMP"
echo "==> All 5 Termux native deb packages built successfully!"
