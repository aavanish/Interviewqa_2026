##This is reusable script to check different Env installed

#!/bin/bash
set -e

echo "🔍 Checking environment..."

# Function to check if a command exists
check_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "❌ $1 not installed"
        exit 1
    fi
    echo "✅ $1 is installed"
}

check_command terraform
check_command docker

echo "🎉 Environment ready!"
