#!/usr/bin/env bash

set -euo pipefail

TITLE="🧠 Nix Hub TUI"
PROMPT="👉 Escolha uma opção:"
OPTIONS=(
  "🔄 Atualizar sistema (nixos-upgrade)"
  "🧼 Limpeza segura (nix-gc-safe)"
  "📚 Ver opções declarativas (nixos-options-fzf)"
  "🧠 Comparar flake.lock (flake-diff)"
  "🛠 Listar DevShells disponíveis"
  "🧪 Entrar em um devShell declarativo"
  "💡 Ver versão do sistema"
  "🚪 Sair"
)

run_option() {
  case "$1" in
    "🔄 Atualizar sistema (nixos-upgrade)")
      nixos-upgrade
      ;;
    "🧼 Limpeza segura (nix-gc-safe)")
      nix-gc-safe
      ;;
    "📚 Ver opções declarativas (nixos-options-fzf)")
      nixos-options-fzf
      ;;
    "🧠 Comparar flake.lock (flake-diff)")
      flake-diff
      ;;
    "🛠 Listar DevShells disponíveis")
      devshell-list
      ;;
    "🧪 Entrar em um devShell declarativo")
      ALL_SHELLS=$(for path in . shell/*; do
        [ -f "$path/flake.nix" ] || continue
        nix flake show --json "$path" | jq -r --arg path "$path" '
          .devShells."x86_64-linux" | keys[] | "\($path):\(. )"
        ' 2>/dev/null
      done)

      SELECTED=$(printf "%s\n" "$ALL_SHELLS" | fzf --prompt="Escolha o devShell → ")

      if [ -n "$SELECTED" ]; then
        FLAKE_PATH=$(echo "$SELECTED" | cut -d: -f1)
        SHELL_NAME=$(echo "$SELECTED" | cut -d: -f2)
        echo "🧪 nix develop $FLAKE_PATH#$SHELL_NAME"
        nix develop "$FLAKE_PATH#$SHELL_NAME"
      fi
      ;;
    "💡 Ver versão do sistema")
      echo -e "\n🔍 NixOS: $(nixos-version)"
      echo "🔧 Flake: $(nix eval .#nixosConfigurations.nixos.config.system.nixos.version --raw 2>/dev/null || echo N/A)"
      echo "🧩 Kernel: $(uname -r)"
      read -rp $'\nPressione Enter para voltar ao menu...'
      ;;
    "🚪 Sair")
      echo "👋 Valeu, Max!"
      exit 0
      ;;
  esac
}

while true; do
  SELECTED=$(printf "%s\n" "${OPTIONS[@]}" | fzf --prompt="$PROMPT " --header="$TITLE" --height=40% --border)
  [ -z "$SELECTED" ] && break
  clear
  run_option "$SELECTED"
  echo -e "\n✅ Comando finalizado. Voltando ao menu...\n"
  sleep 1
done
