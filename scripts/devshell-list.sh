#!/usr/bin/env bash
nix flake show --json | jq -r '.devShells."x86_64-linux" | keys[]' | fzf --prompt="Escolha um devShell → "
