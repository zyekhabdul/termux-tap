#!/usr/bin/env bash
set -euo pipefail

# Auto-detect Termux environment
if [ -z "${PREFIX:-}" ] || [ ! -d "${PREFIX}/etc/apt" ]; then
    echo "[ ERROR ] This installer is specifically designed for Termux (Android)."
    echo "For standard Linux/macOS, use Homebrew ('brew install zyekhabdul/tap/<pkg>') or PyPI ('pip install <pkg>')."
    exit 1
fi

echo "======================================================"
echo "      zyekhabdul Termux Official APT Repository       "
echo "======================================================"

SOURCES_DIR="${PREFIX}/etc/apt/sources.list.d"
mkdir -p "$SOURCES_DIR"

LIST_FILE="$SOURCES_DIR/zyekhabdul.list"
REPO_URL="https://raw.githubusercontent.com/zyekhabdul/termux-tap/main/apt"

echo "==> Configuring APT repository in $LIST_FILE..."
cat << EOF > "$LIST_FILE"
# zyekhabdul Termux Official Repository
deb [trusted=yes] $REPO_URL stable main
EOF

echo "==> Updating Termux package indices..."
pkg update -y || apt-get update -y

echo ""
echo "======================================================"
echo "[ SUCCESS ] Termux APT repository successfully added!"
echo "======================================================"
echo "You can now install any of the packages using standard Termux commands:"
echo ""
echo "  pkg install sshm"
echo "  pkg install agy-quota"
echo "  pkg install markora"
echo ""
