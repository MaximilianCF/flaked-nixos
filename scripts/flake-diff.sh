#!/usr/bin/env bash
echo "📦 Comparando estado do flake.lock antes/depois..."
nix flake update --dry-run
