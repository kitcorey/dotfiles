#!/usr/bin/env bash
# Bootstraps ansible on macOS or Linux (Debian/Ubuntu/Fedora/RedHat)
set -e

# Detect OS
OS="$(uname -s)"

if [[ "$OS" == "Darwin" ]]; then
    # macOS
    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    echo "Installing ansible via Homebrew..."
    brew install ansible
elif [[ -f /etc/debian_version ]]; then
    # Debian/Ubuntu
    echo "Updating apt and installing ansible..."
    sudo apt update
    sudo apt install -y ansible
elif [[ -f /etc/redhat-release ]]; then
    # Fedora/RedHat/CentOS
    echo "Installing ansible via dnf/yum..."
    if command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y ansible
    else
        sudo yum install -y ansible
    fi
else
    echo "Unsupported OS. Please install Ansible manually."
    exit 1
fi

echo "Ansible installation complete. Version info:"
ansible --version

echo "You can now run:"
echo "  ansible-playbook -K site.yml"
