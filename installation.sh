#!/usr/bin/env bash

# Create a temporary directory
temp=$(mktemp -d)

# Function to cleanup temporary directory on exit
cleanup() {
  rm -rf "$temp"
}
trap cleanup EXIT

# Create the directory where sshd expects to find the host keys
install -d -m755 "$temp/etc/ssh"

# Copy your existing host key to the temporary directory
sudo cat /etc/ssh/ssh_host_ed25519_key > "$temp/etc/ssh/ssh_host_ed25519_key"

# Set the correct permissions so sshd will accept the key
chmod 600 "$temp/etc/ssh/ssh_host_ed25519_key"

# Install NixOS to the host system with our secrets

# Execute this command to rebuild the flake cache.

# nix flake lock --update-input dotfiles --extra-experimental-features nix-command --extra-experimental-features flakes
# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount /tmp/disk-config.nix
# sudo nixos-rebuld switch --flake '/home/nixos/nixos#lenovo'

nixos-anywhere --extra-files "$temp" --flake '.#lenovo' nixos@192.168.1.143

