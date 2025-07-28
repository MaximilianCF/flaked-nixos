#!/usr/bin/env bash
echo "🧼 Limpando com segurança..."
sudo nix-collect-garbage --delete-older-than 7d
sudo nix-store --gc
