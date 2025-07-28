#!/usr/bin/env bash

# Hal-powered fuzzy finder for NixOS & Home Manager options

QUERY=$(curl -s https://search.nixos.org/options/search?q= | jq '.options')
HM_QUERY=$(curl -s https://nix-community.github.io/home-manager/options.json)

TMP=$(mktemp)

(
  echo "# NixOS Options"
  curl -s "https://search.nixos.org/options/search.json?query=" | jq -r '.options[] | "\(.name)\t\(.description)"'
  echo "# Home Manager Options"
  curl -s "https://nix-community.github.io/home-manager/options.json" | jq -r '.[] | "\(.name)\t\(.description)"'
) > "$TMP"

fzf --with-nth=1,2 \
    --delimiter='\t' \
    --preview "echo {} | cut -f2" \
    --preview-window=wrap \
    --height=40% --border --ansi

rm "$TMP"

