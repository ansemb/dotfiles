#!/bin/bash

# Get latest release info and extract .deb download URL
LATEST_URL="https://api.github.com/repos/helix-editor/helix/releases/latest"
DEB_URL=$(curl -sL "$LATEST_URL" | grep '"browser_download_url".*\.deb"' | sed -E 's/.*"browser_download_url": "([^"]+)".*/\1/')

# Extract filename from URL
DEB_FILE=$(basename "$DEB_URL")

# Download and install
wget "$DEB_URL"
sudo apt update
sudo apt install "./${DEB_FILE}"
rm "./${DEB_FILE}"