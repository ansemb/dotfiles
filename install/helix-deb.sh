#!/bin/bash

# Get latest release info from GitHub API
LATEST_URL="https://api.github.com/repos/helix-editor/helix/releases/latest"
VERSION=$(curl -sL "$LATEST_URL" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
VERSION_NUM=$(echo "$VERSION" | sed 's/^v//')

# Construct download URL
DEB_URL="https://github.com/helix-editor/helix/releases/download/${VERSION}/helix_${VERSION_NUM}-1_amd64.deb"

# Download and install
wget "$DEB_URL"
sudo apt update
sudo apt install "./helix_${VERSION_NUM}-1_amd64.deb"
rm "./helix_${VERSION_NUM}-1_amd64.deb"