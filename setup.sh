#!/usr/bin/env bash
set -euo pipefail

confirm() {
    local msg="$1"
    printf "%s [y/N] " "$msg"
    read -r reply || reply=""
    case "$reply" in
    [yY][eE][sS] | [yY]) return 0 ;;
    *) return 1 ;;
    esac
}

echo '__   ________  _____  _    _ '
echo '\ \ / /| ___ \|  _  || |  | |'
echo ' \ V / | |_/ /| | | || |  | |'
echo ' /   \ | ___ \| | | || |/\| |'
echo '/ /^\ \| |_/ /\ \_/ /\  /\  /'
echo '\/   \/\____/  \___/  \/  \/   Setup Script for Offensive AI Workshop'

# --- .env setup ---
echo ""
echo "Step 1: Environment file"
echo "  This copies .env.example to .env so you can configure local secrets."
if [ -f .env ]; then
    echo "[+] .env already exists, skipping."
else
    confirm "  Create .env from .env.example?" || {
        echo "[!] Skipped. .env is required — re-run when ready."
        exit 1
    }
    cp .env.example .env
    echo "[+] Created .env from .env.example"
fi

# --- Anthropic API key check ---
echo ""
echo "Step 2: Anthropic API key"
echo "  The ANTHROPIC_API_KEY is required to run the AI models in this project."
echo "  You can get a key from https://console.anthropic.com/"

# Prefer the environment variable if already set, then fall back to .env
if [ -n "${ANTHROPIC_API_KEY:-}" ]; then
    echo "[+] API key found in environment, skipping."
    # Remove it from .env so the environment value is always the source of truth
    if grep -q "^ANTHROPIC_API_KEY=" .env; then
        sed -i.bak "/^ANTHROPIC_API_KEY=/d" .env && rm -f .env.bak
        echo "[+] Removed ANTHROPIC_API_KEY from .env (environment variable takes precedence)."
    fi
else
    # Read the key directly from .env to avoid shell-parsing issues with placeholder values like <add key>
    ANTHROPIC_API_KEY=$(grep -m1 "^ANTHROPIC_API_KEY=" .env | cut -d'=' -f2-)
    if [ -n "${ANTHROPIC_API_KEY:-}" ] && [ "${ANTHROPIC_API_KEY}" != "<add key>" ]; then
        echo "[+] API key found in .env, skipping."
    else
        confirm "  Set your Anthropic API key now?" || {
            echo "[!] Skipped. Set ANTHROPIC_API_KEY in .env and re-run."
            exit 1
        }
        printf "  Paste your Anthropic API key and press Enter: "
        read -r api_key
        if [ -z "$api_key" ]; then
            echo "[!] Error: no key provided. Set ANTHROPIC_API_KEY in .env and re-run." >&2
            exit 1
        fi
        if grep -q "^ANTHROPIC_API_KEY=" .env; then
            sed -i.bak "s|^ANTHROPIC_API_KEY=.*|ANTHROPIC_API_KEY=${api_key}|" .env && rm -f .env.bak
        else
            echo "ANTHROPIC_API_KEY=${api_key}" >>.env
        fi
        echo "[+] API key saved to .env"
    fi
fi

# --- Clone PentestGPT ---
echo ""
echo "Step 3: PentestGPT"
echo "  PentestGPT is an AI-assisted penetration testing tool used in this project."
echo "  This will create a tools/ directory and clone it from GitHub."
if [ -d "tools/PentestGPT/.git" ]; then
    echo "[+] tools/PentestGPT already exists, skipping."
else
    if confirm "  Clone PentestGPT into tools/PentestGPT?"; then
        mkdir -p tools
        git clone https://github.com/greydgl/pentestgpt tools/PentestGPT
        echo "[+] Cloned PentestGPT into tools/PentestGPT"
    else
        echo "  [!] Skipped. Clone it manually with: git clone https://github.com/greydgl/pentestgpt tools/PentestGPT"
    fi
fi

# --- Pull latest Docker images ---
echo ""
echo "Step 4: Docker images"
echo "  This runs 'docker compose pull' to download the latest versions of all"
echo "  pre-built images (juice-shop, zap, temporal, postgres, temporal-ui)."
echo "  Note: pentestgpt and shannon-worker are built locally and are not pulled."
confirm "  Pull latest Docker images now?" || { echo "  [!] Skipped. Run 'docker compose pull' manually when ready."; }
echo "[+] Pulling..."
docker compose pull

echo ""
echo "[+] Setup complete. Run 'docker compose up' to start the stack."
