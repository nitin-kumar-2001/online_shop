#!/bin/bash

# --- Step 1: Check if you are Root ---
# We need Admin powers to install software.
if [ "$EUID" -ne 0 ]; then
  echo "❌ Error: Please run this script with sudo (sudo ./install_docker.sh)"
  exit 1
fi

echo "🚀 Phase 1: Removing old Docker versions to avoid errors..."
# This stops conflicts that cause the 'exit-code' failure.
sudo apt-get remove -y docker.io docker-doc docker-compose podman-docker containerd runc

echo "🚀 Phase 2: Updating system and installing tools..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

echo "🚀 Phase 3: Saving the Docker Security Key (GPG)..."
# This ensures the software is official and safe.
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "🚀 Phase 4: Adding the Official Docker Store address..."
# Tells Ubuntu where to download the newest Docker version.
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "🚀 Phase 5: Installing Docker Engine and Compose..."
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "🚀 Phase 6: Setting up User Permissions..."
# This adds your current user to the 'docker' group.
# Now you can run docker commands without typing 'sudo' every time!
sudo usermod -aG docker $USER
echo "💡 Info: You have been added to the docker group."

echo "🚀 Phase 7: Verifying the installation..."
sudo docker --version

echo "------------------------------------------------------"
echo "✅ SUCCESS: Docker is installed!"
echo "⚠️  IMPORTANT: Run the command 'newgrp docker' now to apply permissions."
echo "------------------------------------------------------"
