#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APT_DIR="$REPO_ROOT/apt"
POOL_DIR="$APT_DIR/pool/main"
DISTS_DIR="$APT_DIR/dists/stable"

mkdir -p "$POOL_DIR"
mkdir -p "$DISTS_DIR/main/binary-all"

# Copy deb packages
cp -v /home/aomiqaza/Projects/sshm/packaging/debian/sshm_*.deb "$POOL_DIR/"
cp -v /home/aomiqaza/Projects/agy-quota/packaging/debian/agy-quota_*.deb "$POOL_DIR/"
cp -v /home/aomiqaza/Projects/markora/packaging/debian/markora_*.deb "$POOL_DIR/"

# Generate Packages file relative to apt/
cd "$APT_DIR"
dpkg-scanpackages --multiversion pool/main /dev/null > "$DISTS_DIR/main/binary-all/Packages"
gzip -9c "$DISTS_DIR/main/binary-all/Packages" > "$DISTS_DIR/main/binary-all/Packages.gz"

# Mirror to arch folders
for arch in aarch64 arm arm64 x86_64 i686 amd64; do
    mkdir -p "$DISTS_DIR/main/binary-$arch"
    cp "$DISTS_DIR/main/binary-all/Packages" "$DISTS_DIR/main/binary-$arch/Packages"
    cp "$DISTS_DIR/main/binary-all/Packages.gz" "$DISTS_DIR/main/binary-$arch/Packages.gz"
done

# Generate Release file
cd "$DISTS_DIR"
cat << 'EOF' > Release
Origin: zyekhabdul Termux Tap
Label: zyekhabdul
Suite: stable
Codename: stable
Architectures: all aarch64 arm arm64 x86_64 i686 amd64
Components: main
Description: Official Termux APT repository for zyekhabdul utilities
EOF

echo "==> APT repository generated successfully!"
