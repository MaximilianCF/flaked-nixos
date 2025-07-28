#!/usr/bin/env bash
set -e
echo "🔄 Atualizando flake.lock..."
nix flake update
echo "⚙️ Aplicando rebuild..."
sudo nixos-rebuild switch --flake .#nixos
