# zyekhabdul Termux APT Repository (Termux Tap)

Official APT repository for Termux on Android, providing native `pkg install` packages for `sshm`, `agy-quota`, and `markora`.

## Available Packages

| Package | Description | Official Command |
| :--- | :--- | :--- |
| `sshm` | Fast interactive SSH fuzzy manager with live metadata preview & port-forwarding | `pkg install sshm` |
| `agy-quota` | Multi-account token, quota & tier monitor TUI for Google Antigravity | `pkg install agy-quota` |
| `markora` | Sovereign Markor-style markdown notebook, quicknotes & todo TUI | `pkg install markora` |
| `vol3-suite` | Unified Memory Forensics, eBPF Rootkit Detection, and AI-Driven Incident Triage Suite | `pkg install vol3-suite` |
| `agy-guard` | Deterministic AI Agent Governance, AST Blast-Radius Scanner & Verification Harness | `pkg install agy-guard` |

## Quick Setup (1-Line Command)

Run this one-liner in Termux to add the repository and update package lists:

```bash
curl -fsSL https://raw.githubusercontent.com/zyekhabdul/termux-tap/main/setup.sh | bash
```

## Installation

Once added, install any package using official `pkg install`:

```bash
pkg install sshm
pkg install agy-quota
pkg install markora
pkg install vol3-suite
pkg install agy-guard
```

## Updating

Keep packages updated alongside your standard Termux system packages:

```bash
pkg update && pkg upgrade
```
